import json
from datetime import timedelta

from django.conf import settings
from django.contrib.auth import authenticate, get_user_model
from django.core import signing
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.shortcuts import get_object_or_404

from rest_framework import viewsets, permissions, status, generics, views
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes, action
from rest_framework.permissions import AllowAny, IsAuthenticated

from .models.training import Course, CourseAssignment
from .models.workspaces import User, Workspace
from .models import (
    Quiz, Company, UserCompany, Question, Answer,
    Badge, UserBadge
)
from .permissions import IsCompanyAdmin
from .models.competencies import Competency
from .serializers import (
    CourseSerializer, 
    CourseAssignmentSerializer, 
    QuizDetailSerializer, 
    CompanySerializer, 
    UserBadgeSerializer, 
    CompanyUserAddSerializer, 
    UserCompanyListSerializer, 
    BulkCourseAssignmentSerializer,
    CompetencySerializer,
    CompetencyDetailSerializer
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
    
class CompanyManagementViewSet(viewsets.ModelViewSet):
    """
    Zarządzanie ustawieniami firmy.
    Tylko Admin firmy może edytować (PUT/PATCH).
    """
    queryset = Company.objects.all()
    serializer_class = CompanySerializer
    
    def get_permissions(self):
        if self.action in ['update', 'partial_update', 'destroy']:
            return [permissions.IsAuthenticated(), IsCompanyAdmin()]
        return [permissions.AllowAny()] # Lub IsAuthenticated dla odczytu

    # 1. Zarządzanie ustawieniami firmy (PUT/PATCH obsługiwane przez domyślne metody ModelViewSet)


class CompanyUsersViewSet(viewsets.ViewSet):
    """
    Endpointy do zarządzania użytkownikami wewnątrz konkretnej firmy.
    Ścieżka: /api/companies/{company_pk}/users/
    """
    permission_classes = [permissions.IsAuthenticated, IsCompanyAdmin]

    # GET: Lista użytkowników w firmie
    def list(self, request, company_pk=None):
        queryset = UserCompany.objects.filter(company_id=company_pk).select_related('user')
        serializer = UserCompanyListSerializer(queryset, many=True)
        return Response(serializer.data)

    # POST: Dodawanie użytkownika do firmy
    def create(self, request, company_pk=None):
        company = get_object_or_404(Company, pk=company_pk)
        serializer = CompanyUserAddSerializer(data=request.data)
        
        if serializer.is_valid():
            email = serializer.validated_data['email']
            role = serializer.validated_data['role']
            
            # Sprawdź czy user istnieje, jak nie to stwórz (prosta logika)
            user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    'username': email, 
                    'first_name': serializer.validated_data.get('first_name', ''),
                    'last_name': serializer.validated_data.get('last_name', '')
                }
            )
            # Jeśli user został stworzony, wypadałoby wysłać mu email z hasłem/linkiem (tu pomijamy dla uproszczenia)

            # Przypisz do firmy
            user_company, created_relation = UserCompany.objects.get_or_create(
                user=user, 
                company=company,
                defaults={'role': role}
            )
            
            if not created_relation:
                return Response({"detail": "User already in company"}, status=status.HTTP_400_BAD_REQUEST)

            return Response(UserCompanyListSerializer(user_company).data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # DELETE: Usuwanie pracownika
    def destroy(self, request, pk=None, company_pk=None):
        # pk tutaj to ID relacji UserCompany, nie usera!
        user_company = get_object_or_404(UserCompany, pk=pk, company_id=company_pk)
        user_company.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class CompanyCourseViewSet(viewsets.ViewSet):
    """
    Zarządzanie kursami w kontekście firmy.
    Ścieżka: /api/companies/{company_pk}/courses/
    """
    permission_classes = [permissions.IsAuthenticated, IsCompanyAdmin]

    # GET: Lista kursów firmy
    def list(self, request, company_pk=None):
        # Pobieramy workspace'y firmy, a potem kursy
        workspaces = Workspace.objects.filter(company_id=company_pk)
        courses = Course.objects.filter(workspace__in=workspaces)
        serializer = CourseSerializer(courses, many=True)
        return Response(serializer.data)

    # POST: Dodawanie kursu w firmie
    def create(self, request, company_pk=None):
        # Wymagamy podania workspace_id, ale sprawdzamy czy należy do tej firmy
        workspace_id = request.data.get('workspace')
        
        # Security check: czy workspace należy do firmy z URL?
        if not Workspace.objects.filter(id=workspace_id, company_id=company_pk).exists():
             return Response({"detail": "Invalid workspace for this company"}, status=status.HTTP_400_BAD_REQUEST)

        serializer = CourseSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # ASSIGN: Przypisywanie użytkowników do kursu
    @action(detail=False, methods=['post'], url_path='assign')
    def assign_users(self, request, company_pk=None):
        """
        Body: { "course_id": 1, "user_ids": [10, 12, 15] }
        """
        serializer = BulkCourseAssignmentSerializer(data=request.data)
        if serializer.is_valid():
            course_id = serializer.validated_data['course_id']
            user_ids = serializer.validated_data['user_ids']

            # Weryfikacja: Czy kurs należy do tej firmy?
            course = get_object_or_404(Course, pk=course_id)
            if course.workspace.company.id != int(company_pk):
                return Response({"detail": "Course does not belong to this company"}, status=status.HTTP_403_FORBIDDEN)

            assignments = []
            for uid in user_ids:
                # Weryfikacja: Czy user jest w tej firmie?
                if UserCompany.objects.filter(company_id=company_pk, user_id=uid).exists():
                    # Unikamy duplikatów
                    obj, created = CourseAssignment.objects.get_or_create(
                        course=course,
                        user_id=uid,
                        defaults={
                            'assigned_by_user': request.user,
                            'status': 'assigned'
                        }
                    )
                    assignments.append(obj)
            
            return Response({"assigned": len(assignments)}, status=status.HTTP_200_OK)
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CompetencyViewSet(viewsets.ModelViewSet):
    """
    API endpoint for CRUD operations on Competencies.
    
    GET /api/competencies/ - list all competencies
    POST /api/competencies/ - create new competency
    GET /api/competencies/{id}/ - retrieve single competency with details
    PUT /api/competencies/{id}/ - update competency
    PATCH /api/competencies/{id}/ - partial update competency
    DELETE /api/competencies/{id}/ - delete competency
    
    Body dla POST/PUT:
    {
      "workspace": 1,
      "name": "Nazwa kompetencji",
      "description": "Krótki opis kompetencji",
      "courses": [1, 2, 3]  // IDs kursów
    }
    """
    queryset = Competency.objects.all()
    permission_classes = [permissions.AllowAny]  # Change to IsAuthenticated later
    
    def get_serializer_class(self):
        # Użyj szczegółowego serializera dla retrieve (GET single)
        if self.action == 'retrieve':
            return CompetencyDetailSerializer
        return CompetencySerializer
    
    def list(self, request, *args, **kwargs):
        """List all competencies with their courses"""
        queryset = self.get_queryset()
        # Opcjonalnie filtruj po workspace
        workspace_id = request.query_params.get('workspace', None)
        if workspace_id:
            queryset = queryset.filter(workspace_id=workspace_id)
        
        serializer = CompetencyDetailSerializer(queryset, many=True)
        return Response(serializer.data)
