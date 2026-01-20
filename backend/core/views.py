import json
from datetime import timedelta
from django.conf import settings
from django.contrib.auth import authenticate, get_user_model
from django.core import signing
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from rest_framework import viewsets, permissions, status, generics, views
from .models.training import Course, CourseAssignment
from .serializers import CourseSerializer, CourseAssignmentSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from .models import Quiz, Company, UserCompany, Answer
from .serializers import QuizDetailSerializer, CompanySerializer
from rest_framework.permissions import AllowAny, IsAuthenticated # Added IsAuthenticated
from .models import (
    Course, CourseAssignment, Question, Answer,
    Company, UserCompany, UserBadge, Badge, Quiz
)
from .serializers import (
    CourseSerializer, CourseAssignmentSerializer, 
    QuizDetailSerializer, CompanySerializer, UserBadgeSerializer # Added UserBadgeSerializer
)

User = get_user_model()

# ile sekund ważny jest token (tu: 7 dni)
AUTH_TOKEN_MAX_AGE = 60 * 60 * 24 * 7  # 7 dni


def _generate_token(user) -> str:
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

    # Dane personalizacji firmy przypisanej do użytkownika
    company_data = None
    role = "employee"
    try:
        user_company = UserCompany.objects.select_related("company").get(user=user)
        role = user_company.role
        company_data = CompanySerializer(user_company.company).data
    except UserCompany.DoesNotExist:
        company_data = None

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
                "role": role,
            },
            "company": company_data,
        },
        status=200,
    )


@api_view(["POST"])
@permission_classes([AllowAny])
def create_company(request):
    """
    API endpoint do tworzenia nowej firmy z personalizacją.

    Oczekiwany JSON body:
    {
      "name": "Nazwa firmy",
      "domain": "example.com",
      "logo_url": "https://example.com/logo.png",
      "primary_color": "#2563EB",
      "secondary_color": "#1E40AF",
      "accent_color": "#3B82F6"
    }

    Odpowiedź przy 201 Created:
    {
      "id": 1,
      "name": "Nazwa firmy",
      "domain": "example.com",
      "logo_url": "https://example.com/logo.png",
      "primary_color": "#2563EB",
      "secondary_color": "#1E40AF",
      "accent_color": "#3B82F6",
      "created_at": "2025-12-15T10:30:00Z"
    }
    """
    serializer = CompanySerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET"])
@permission_classes([AllowAny])
def list_companies(request):
    """
    API endpoint do pobierania listy wszystkich firm.

    Odpowiedź:
    [
      {
        "id": 1,
        "name": "Nazwa firmy",
        "domain": "example.com",
        "logo_url": "https://example.com/logo.png",
        "primary_color": "#2563EB",
        "secondary_color": "#1E40AF",
        "accent_color": "#3B82F6",
        "created_at": "2025-12-15T10:30:00Z"
      },
      ...
    ]
    """
    companies = Company.objects.all()
    serializer = CompanySerializer(companies, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(["GET"])
@permission_classes([AllowAny])
def get_company(request, pk):
    """
    API endpoint do pobierania szczegółów konkretnej firmy.

    Parametry URL:
    - pk: ID firmy

    Odpowiedź:
    {
      "id": 1,
      "name": "Nazwa firmy",
      "domain": "example.com",
      "logo_url": "https://example.com/logo.png",
      "primary_color": "#2563EB",
      "secondary_color": "#1E40AF",
      "accent_color": "#3B82F6",
      "created_at": "2025-12-15T10:30:00Z"
    }
    """
    try:
        company = Company.objects.get(pk=pk)
    except Company.DoesNotExist:
        return Response(
            {"detail": "Firma nie znaleziona."},
            status=status.HTTP_404_NOT_FOUND,
        )
    serializer = CompanySerializer(company)
    return Response(serializer.data, status=status.HTTP_200_OK)
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

# --- View to get a full quiz with questions and answers ---
class QuizDetailView(generics.RetrieveAPIView):
    queryset = Quiz.objects.all()
    serializer_class = QuizDetailSerializer
    permission_classes = [permissions.IsAuthenticated] # Or AllowAny if quizzes are public

# --- View to submit answers and get a score ---
class SubmitQuizView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        # The user will send a POST request with a list of answer IDs they selected
        # Example body: { "submitted_answer_ids": [1, 5, 10] }
        submitted_answer_ids = request.data.get('submitted_answer_ids', [])
        
        if not isinstance(submitted_answer_ids, list):
            return Response({"error": "submitted_answer_ids must be a list"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            quiz = Quiz.objects.get(pk=pk)
        except Quiz.DoesNotExist:
            return Response({"error": "Quiz not found"}, status=status.HTTP_404_NOT_FOUND)

        # Get all questions for this quiz
        total_questions = quiz.questions.count()
        
        # Find how many of the submitted answers are correct
        correct_answers = Answer.objects.filter(
            question__quiz=quiz, 
            id__in=submitted_answer_ids, 
            is_correct=True
        ).count()
        
        score = (correct_answers / total_questions) * 100 if total_questions > 0 else 0

        # Requirement 4: Show end-score
        return Response({
            "quiz_id": quiz.id,
            "total_questions": total_questions,
            "correct_answers": correct_answers,
            "score": round(score, 2)
        }, status=status.HTTP_200_OK)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def my_badges(request):
    user_badges = UserBadge.objects.filter(user=request.user)
    serializer = UserBadgeSerializer(user_badges, many=True)
    return Response(serializer.data)