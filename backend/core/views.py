import json
from datetime import timedelta

from django.conf import settings
from django.contrib.auth import authenticate, get_user_model
from django.core import signing
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from rest_framework import viewsets, permissions
from .models.training import Course, CourseAssignment
from .serializers import CourseSerializer, CourseAssignmentSerializer

User = get_user_model()

# ile sekund ważny jest token (tu: 7 dni)
AUTH_TOKEN_MAX_AGE = 60 * 60 * 24 * 7  # 7 dni


def _generate_token(user: User) -> str:
    """
    Tworzy prosty, podpisany token na bazie SECRET_KEY Django.
    Nie jest to "prawdziwy" JWT, ale działa stateless i jest bezpieczny
    dla prostego API mobilnego.
    """
    payload = {
        "user_id": user.id,
        "email": user.email,
        "exp": int(
            (timezone.now() + timedelta(seconds=AUTH_TOKEN_MAX_AGE)).timestamp()
        ),
    }
    # salt tylko dla tokenów auth, żeby odróżnić od innych potencjalnych podpisów
    return signing.dumps(payload, salt="auth-token")


@csrf_exempt  # Flutter nie używa CSRF, więc tu wyłączamy
@require_POST
def login_view(request):
    """
    REST-owe logowanie.

    Oczekiwany JSON body:
    {
      "email": "user@example.com",
      "password": "sekret"
    }

    Odpowiedź przy 200 OK:
    {
      "token": "<string>",
      "user": {
        "id": 1,
        "email": "user@example.com",
        "first_name": "Jan",
        "last_name": "Kowalski",
        "username": "jan",
        "is_staff": true,
        "is_superuser": false
      }
    }
    """
    try:
        data = json.loads(request.body.decode("utf-8"))
    except json.JSONDecodeError:
        return JsonResponse(
            {"detail": "Nieprawidłowe JSON body."},
            status=400,
        )

    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return JsonResponse(
            {"detail": "Pola 'email' i 'password' są wymagane."},
            status=400,
        )

    # Szukamy użytkownika po mailu w bazie (auth_user w Twojej bazie MSSQL)
    try:
        user_obj = User.objects.get(email__iexact=email)
    except User.DoesNotExist:
        return JsonResponse(
            {"detail": "Nieprawidłowe dane logowania."},
            status=401,
        )

    # Uwierzytelnienie przez standardowy mechanizm Django
    user = authenticate(
        request,
        username=user_obj.get_username(),
        password=password,
    )

    if user is None:
        return JsonResponse(
            {"detail": "Nieprawidłowe dane logowania."},
            status=401,
        )

    token = _generate_token(user)

    return JsonResponse(
        {
            "token": token,
            "user": {
                "id": user.id,
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "username": user.get_username(),
                "is_staff": user.is_staff,
                "is_superuser": user.is_superuser,
            },
        },
        status=200,
    )
class CourseViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows courses to be viewed or edited.
    Provides CRUD operations for Courses.
    """
    queryset = Course.objects.all()
    serializer_class = CourseSerializer
    # You should configure permissions, e.g., permissions.IsAuthenticated
    # and check if the user is a 'mentor' or 'admin'
    permission_classes = [permissions.AllowAny] # Change to IsAuthenticated later

class UserAssignedCoursesViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint to view courses assigned to a specific user.
    """
    serializer_class = CourseSerializer
    permission_classes = [permissions.AllowAny] # Change to IsAuthenticated later

    def get_queryset(self):
        """
        This view should return a list of all the courses
        for the user ID provided in the URL.
        """
        user_id = self.kwargs['user_id']
        assigned_courses = CourseAssignment.objects.filter(user_id=user_id)
        course_ids = [assignment.course.id for assignment in assigned_courses]
        return Course.objects.filter(id__in=course_ids)

class CourseAssignmentViewSet(viewsets.ModelViewSet):
    """
    API endpoint for assigning courses to users.
    """
    queryset = CourseAssignment.objects.all()
    serializer_class = CourseAssignmentSerializer
    permission_classes = [permissions.AllowAny] # Change to IsAuthenticated later

    def perform_create(self, serializer):
        # Set the 'assigned_by_user' to the current user automatically
        serializer.save(assigned_by_user=self.request.user)