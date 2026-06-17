import json
from datetime import timedelta
from django.conf import settings
from django.contrib.auth import authenticate, get_user_model
from django.core import signing
from django.db.models import Avg, Count
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets, permissions, status, generics, views, filters
from rest_framework.exceptions import ValidationError
from .models.training import Course, CourseAssignment
from .serializers import CourseSerializer, CourseAssignmentSerializer, MentorStatsSerializer, MentorRatingSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes, action
from rest_framework.permissions import AllowAny, IsAuthenticated
from .models import (Quiz, Company, UserCompany, Answer, Workspace, Course, CourseAssignment, Badge, UserBadge, \
                     OnboardingTemplate, \
                     OnboardingTaskInstance, Onboarding, \
                     OnboardingTemplate, \
                     OnboardingTaskInstance, OnboardingTaskTemplate, MentorRating)
from .serializers import QuizDetailSerializer, CompanySerializer
from django.shortcuts import get_object_or_404
from .models.workspaces import User  # lub get_user_model()
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from .models.progress import SectionProgress
from .models.section import Section
from .serializers import (  
    CourseDetailSerializer, 
    CourseListSerializer,
    CourseCreateUpdateSerializer,
    CourseSerializer, 
    CompanyUserAddSerializer, 
    UserCompanyListSerializer,
    BulkCourseAssignmentSerializer,
    CourseAssignmentSerializer,
    CompetencySerializer,
    CompetencyDetailSerializer,
    BadgeSerializer,
    OnboardingTemplateSerializer,
    OnboardingTaskTemplateSerializer,
    OnboardingSerializer,
    OnboardingTaskInstanceSerializer
)

from .models import Badge
from .permissions import IsCompanyAdmin, IsCompanyAdminOrHR
from .models.competencies import Competency
from . import serializers
from .models import UserBadge
from .serializers import UserBadgeSerializer
from .models import CourseAssignment, UserBadge
import datetime
from django.db.models import Sum
from rest_framework.views import APIView
from .models import XPTransaction, Milestone
from .serializers import XPTransactionSerializer, MilestoneSerializer
User = get_user_model()

# ile sekund ważny jest token (tu: 7 dni)
AUTH_TOKEN_MAX_AGE = 60 * 60 * 24 * 7  # 7 dni

class BadgeViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows badges to be viewed or edited.
    """
    queryset = Badge.objects.all()
    serializer_class = BadgeSerializer

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

    def _resolve_badge_for_completion(self, assignment, badge_id):
        if badge_id is not None and badge_id != '':
            try:
                badge = Badge.objects.get(pk=int(badge_id))
            except (TypeError, ValueError):
                raise ValidationError({'badge_id': 'badge_id musi być liczbą całkowitą.'})
            except Badge.DoesNotExist:
                raise ValidationError({'badge_id': 'Nie znaleziono odznaki o podanym ID.'})
        else:
            badge = assignment.course.completion_badge

        if badge is None:
            return None

        if badge.workspace_id != assignment.course.workspace_id:
            raise ValidationError({'badge_id': 'Odznaka musi należeć do tego samego workspace co kurs.'})

        return badge

    def perform_update(self, serializer):
        assignment = serializer.instance
        target_status = (serializer.validated_data.get('status', assignment.status) or '').lower()
        badge = None

        if target_status == 'completed':
            badge = self._resolve_badge_for_completion(assignment, self.request.data.get('badge_id'))

        assignment = serializer.save()

        if target_status == 'completed' and badge is not None:
            # Idempotentne przypisanie - brak duplikatów przy kolejnych update'ach.
            UserBadge.objects.get_or_create(user=assignment.user, badge=badge)

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

        if score >= 80:
            # Blokada przed wielokrotnym zdobywaniem punktów za ten sam quiz
            quiz_reason = f"Zaliczony quiz ID: {pk}"
            if not XPTransaction.objects.filter(user=request.user, reason=quiz_reason).exists():
                XPTransaction.objects.create(
                    user=request.user,
                    amount=250,
                    reason=quiz_reason
                )

        # Requirement 4: Show end-score
        return Response({
            "quiz_id": quiz.id,
            "total_questions": total_questions,
            "correct_answers": correct_answers,
            "score": round(score, 2)
        }, status=status.HTTP_200_OK)
    

@api_view(["GET"])
@permission_classes([AllowAny])
def get_quiz_for_course(request, course_id):
    """
    Znajduje quiz powiązany z kursem. Przeszukuje bloki w sekcjach kursu i
    zwraca pierwszy napotkany quiz (jeśli istnieje).
    """
    try:
        course = Course.objects.get(pk=course_id)
    except Course.DoesNotExist:
        return Response({"detail": "Course not found."}, status=status.HTTP_404_NOT_FOUND)

    # Szukamy pierwszego bloku, który ma przypisany quiz w sekcjach tego kursu
    from .models import Block

    block = Block.objects.filter(section__course=course, quiz__isnull=False).select_related('quiz').first()

    if not block or not block.quiz:
        return Response({"detail": "Quiz not found for this course."}, status=status.HTTP_404_NOT_FOUND)

    quiz = block.quiz
    serializer = QuizDetailSerializer(quiz)
    return Response(serializer.data, status=status.HTTP_200_OK)

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
    # Zmieniamy na IsAuthenticated, aby każdy zalogowany mógł wywołać widok
    permission_classes = [permissions.IsAuthenticated]

    def get_permissions(self):
        if self.request.method in ['POST', 'DELETE']:
            # ZMIANA: Zastępujemy IsCompanyAdmin() nową klasą IsCompanyAdminOrHR()
            return [permissions.IsAuthenticated(), IsCompanyAdminOrHR()]
        return [permissions.IsAuthenticated()]

    def list(self, request, company_pk=None):
        """Pobieranie listy użytkowników - dostępne dla każdego członka firmy"""
        # Sprawdzenie czy użytkownik należy do firmy o którą pyta (zabezpieczenie)
        if not UserCompany.objects.filter(user=request.user, company_id=company_pk).exists():
            return Response(
                {"detail": "Nie masz uprawnień do przeglądania tej firmy."}, 
                status=status.HTTP_403_FORBIDDEN
            )

        queryset = UserCompany.objects.filter(company_id=company_pk).select_related('user')
        serializer = UserCompanyListSerializer(queryset, many=True)
        return Response(serializer.data)

    def create(self, request, company_pk=None):
        """Dodawanie użytkownika - wywoływane przez POST, chronione przez IsCompanyAdmin"""
        # ... tutaj zostawiasz swoją logikę dodawania usera ...
        return Response({"status": "user created"}, status=status.HTTP_201_CREATED)

    def destroy(self, request, *args, **kwargs):
        return Response(status=status.HTTP_200_OK)


class CourseViewSet(viewsets.ModelViewSet):
    """
    API endpoint for Course management with full structure.
    
    GET /api/courses/                  → Lista kursów (basic info)
    GET /api/courses/{id}/             → Szczegóły kursu (FULL NESTED STRUCTURE)
    POST /api/courses/                 → Tworzenie kursu
    PUT/PATCH /api/courses/{id}/       → Edycja kursu
    """
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        """
        Pobierz kursy użytkownika z optymalizacją.
        prefetch_related() redukuje liczbę SQL queries.
        """
        user = self.request.user
        try:
            user_company = UserCompany.objects.get(user=user)
            queryset = Course.objects.filter(
                workspace__company=user_company.company
            ).prefetch_related(
                'sections', 
                'sections__blocks',
                'sections__blocks__quiz',
            )
            return queryset
        except UserCompany.DoesNotExist:
            return Course.objects.none()

    def get_serializer_class(self):
        """Użyj odpowiedniego serializera w zależności od akcji"""
        if self.action == 'retrieve':
            return CourseDetailSerializer
        elif self.action == 'list':
            return CourseListSerializer
        elif self.action in ['create']:
            return CourseCreateUpdateSerializer
        elif self.action in ['update', 'partial_update']:
            return CourseCreateUpdateSerializer
        return CourseSerializer

    def perform_create(self, serializer):
        """Automatycznie ustaw workspace na workspace użytkownika"""
        try:
            user_company = UserCompany.objects.get(user=self.request.user)
            workspace = user_company.company.workspaces.first()
            serializer.save(workspace=workspace)
        except Exception as e:
            # Używamy zadeklarowanego na szczycie pliku rest_framework.exceptions.ValidationError
            # Zamiast serializers.ValidationError
            print(f"Błąd zapisu kursu w perform_create: {e}")
            raise ValidationError(
                {"detail": f"Nie udało się zapisać kursu: {str(e)}"}
            )

    @action(detail=True, methods=['get'])
    def structure(self, request, pk=None):
        """
        Dodatkowy endpoint do pobierania SAMEJ struktury kursu
        (sekcje + bloki) bez metadanych kursu.
        
        GET /api/courses/{id}/structure/ → { sections: [...] }
        """
        course = self.get_object()
        sections = course.sections.all().prefetch_related('blocks')
        from .serializers import SectionSerializer
        data = SectionSerializer(sections, many=True).data
        return Response({"course_id": course.id, "sections": data})

class CompanyCourseViewSet(viewsets.ViewSet):
    """
    Zarządzanie kursami w kontekście firmy.
    Ścieżka: /api/companies/{company_pk}/courses/
    """
    permission_classes = [permissions.IsAuthenticated, IsCompanyAdminOrHR]

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

class SectionProgressView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        data = request.data
        user = request.user

        course = get_object_or_404(Course, pk=data.get("course_id"))
        section = get_object_or_404(Section, pk=data.get("section_id"))

        # optional safety check
        if section.course_id != course.id:
            return Response({"detail": "Section does not belong to this course."},
                            status=status.HTTP_400_BAD_REQUEST)

        assignment = get_object_or_404(CourseAssignment, user=user, course=course)

        sp, _ = SectionProgress.objects.update_or_create(
            assignment=assignment,
            section=section,
            defaults={"completed": bool(data.get("completed", False))},
        )

        all_sections = Section.objects.filter(course=course).count()
        completed_sections = SectionProgress.objects.filter(
            assignment=assignment, completed=True
        ).count()
        progress = int((completed_sections / all_sections) * 100) if all_sections else 0

        assignment.status = f"{progress}% complete"
        assignment.save(update_fields=["status"])

        return Response({
            "course_id": course.id,
            "section_id": section.id,
            "completed": sp.completed,
            "progress": progress,
            "status": assignment.status,
            "total_sections": all_sections,
            "completed_sections": completed_sections,
        }, status=status.HTTP_200_OK)

class MentorRatingViewSet(viewsets.ModelViewSet):
    queryset = MentorRating.objects.all()
    serializer_class = MentorRatingSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """
        Możliwość filtrowania ocen po mentor_id w query params:
        GET /api/ratings/?mentor_id=5
        """
        queryset = super().get_queryset()
        mentor_id = self.request.query_params.get('mentor_id')
        if mentor_id:
            queryset = queryset.filter(mentor_id=mentor_id)
        return queryset

    @action(detail=False, url_path='mentor/(?P<mentor_id>\d+)/stats', methods=['get'])
    def mentor_stats(self, request, mentor_id=None):
        """
        Endpoint agregujący: GET /api/ratings/mentor/{mentor_id}/stats/
        """
        # Sprawdzamy czy mentor w ogóle istnieje w systemie
        if not User.objects.filter(id=mentor_id).exists():
            return Response(
                {"error": "Mentor nie istnieje."},
                status=status.HTTP_404_NOT_FOUND
            )

        # Agregacja danych z bazy
        stats = MentorRating.objects.filter(mentor_id=mentor_id).aggregate(
            average_rating=Avg('rating'),
            total_ratings=Count('id')
        )

        # Obsługa przypadku, gdy mentor nie ma jeszcze żadnych ocen
        if stats['average_rating'] is None:
            stats['average_rating'] = 0.0

        # Zaokrąglenie średniej do 2 miejsc po przecinku
        stats['average_rating'] = round(stats['average_rating'], 2)

        serializer = MentorStatsSerializer(stats)
        return Response(serializer.data, status=status.HTTP_00_OK)
class OnboardingTemplateViewSet(viewsets.ModelViewSet):
    queryset = OnboardingTemplate.objects.all().prefetch_related('onboardingtasktemplate_set')
    serializer_class = OnboardingTemplateSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['workspace']
    search_fields = ['name']


class OnboardingTaskTemplateViewSet(viewsets.ModelViewSet):
    queryset = OnboardingTaskTemplate.objects.all()
    serializer_class = OnboardingTaskTemplateSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['template']


class OnboardingViewSet(viewsets.ModelViewSet):
    # prefetch_related optymalizuje zapytania SQL zapobiegając problemowi N+1
    queryset = Onboarding.objects.all().select_related('template', 'user', 'mentor').prefetch_related('onboardingtaskinstance_set')
    serializer_class = OnboardingSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['user', 'status', 'template']


class OnboardingTaskInstanceViewSet(viewsets.ModelViewSet):
    queryset = OnboardingTaskInstance.objects.all().select_related('onboarding', 'template_task', 'assigned_to_user')
    serializer_class = OnboardingTaskInstanceSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['onboarding', 'assigned_to_user', 'status']

class UserBadgeViewSet(viewsets.ModelViewSet):
    """
    Endpoint pozwalający na ręczne przydzielanie i pobieranie 
    odznak konkretnego użytkownika.
    """
    queryset = UserBadge.objects.all()
    serializer_class = UserBadgeSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Filtrowanie odznak po konkretnym użytkowniku: ?user_id=X
        user_id = self.request.query_params.get('user_id')
        if user_id:
            return self.queryset.filter(user_id=user_id)
        return self.queryset
    
class DashboardView(APIView):
    """
    Endpoint agregujący statystyki i aktywności dla Dashboardu.
    Zwraca inne dane dla Admina/HR, a inne dla zwykłego pracownika.
    """
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        try:
            user_company = UserCompany.objects.select_related('company').get(user=request.user)
            company = user_company.company
            role = user_company.role
        except UserCompany.DoesNotExist:
            return Response({"error": "Brak przypisanej firmy."}, status=status.HTTP_400_BAD_REQUEST)

        # --- DANE DLA ADMINA / HR ---
        if role in ['admin', 'super_admin', 'hr']:
            employees_count = UserCompany.objects.filter(company=company).count()
            courses_count = Course.objects.filter(workspace__company=company).count()
            
            recent_onboardings = OnboardingTaskInstance.objects.filter(
                onboarding__template__workspace__company=company
            ).select_related('assigned_to_user', 'template_task').order_by('-id')[:5]

            activities = []
            for task in recent_onboardings:
                user_name = f"{task.assigned_to_user.first_name} {task.assigned_to_user.last_name}".strip() or task.assigned_to_user.email
                status_map = {"pending": "Rozpoczął", "in_progress": "Kontynuuje", "completed": "Ukończył"}
                
                activities.append({
                    "user": user_name,
                    "action": status_map.get(task.status, "Aktualizacja zadania"),
                    "course": task.template_task.title,
                    "time": "Ostatnio"
                })

            return Response({
                "stats": {
                    "courses": courses_count,
                    "employees": employees_count,
                    "avg_completion_hours": 4.5
                },
                "activities": activities
            }, status=status.HTTP_200_OK)

        # --- DANE DLA PRACOWNIKA ---
        else:
            assignments = CourseAssignment.objects.filter(user=request.user)
            # Zliczamy ukończone (gdzie status to explicit 'completed' lub string zawierający '100')
            completed_count = assignments.filter(status__icontains='100').count() + assignments.filter(status='completed').count()
            in_progress_count = assignments.exclude(status='completed').exclude(status__icontains='100').count()

            return Response({
                "stats": {
                    "completed_courses": completed_count,
                    "in_progress_courses": in_progress_count,
                    "learning_time": "12h",
                    "streak": 1
                },
                "activities": [] # Puste dla pracownika
            }, status=status.HTTP_200_OK)
        
class GamificationAnalyticsView(APIView):
    """Endpoint agregujący pełne statystyki profilu grywalizacyjnego pracownika."""
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        
        # 1. Łączny dorobek punktowy
        total_xp = XPTransaction.objects.filter(user=user).aggregate(Sum('amount'))['amount__sum'] or 0

        # 2. Rozkład tygodniowy (Pn - Nd) dla bieżącego tygodnia
        now = timezone.now()
        start_of_week = now - datetime.timedelta(days=now.weekday())
        start_of_week = start_of_week.replace(hour=0, minute=0, second=0, microsecond=0)
        
        weekly_xp = [0] * 7
        transactions_this_week = XPTransaction.objects.filter(user=user, created_at__gte=start_of_week)
        for t in transactions_this_week:
            # t.created_at.weekday() zwraca 0 dla Pn, 6 dla Nd
            weekly_xp[t.created_at.weekday()] += t.amount

        # 3. Ostatnie aktywności użytkownika
        recent = XPTransaction.objects.filter(user=user).order_by('-created_at')[:5]
        recent_serializer = XPTransactionSerializer(recent, many=True)

        # 4. Lista kamieni milowych z bazy (jeśli pusta, zwracamy domyślne)
        milestones = Milestone.objects.order_by('level')
        if not milestones.exists():
            # Automatyczne uzupełnienie podstawowych progów w bazie przy pierwszym wywołaniu
            Milestone.objects.bulk_create([
                Milestone(level=1, title="Nowicjusz", required_xp=0),
                Milestone(level=2, title="Uczeń", required_xp=250),
                Milestone(level=3, title="Praktykant", required_xp=750),
                Milestone(level=4, title="Junior", required_xp=1500),
                Milestone(level=5, title="Mid", required_xp=3000),
            ])
            milestones = Milestone.objects.order_by('level')

        milestones_serializer = MilestoneSerializer(milestones, many=True)

        return Response({
            "total_xp": total_xp,
            "weekly_xp": weekly_xp,
            "recent_activities": recent_serializer.data,
            "milestones": milestones_serializer.data
        }, status=status.HTTP_200_OK)