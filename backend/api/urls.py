from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
from core.views import (
    QuizDetailView, SubmitQuizView, login_view, CourseViewSet, 
    UserAssignedCoursesViewSet, CourseAssignmentViewSet, 
    create_company, list_companies, get_company,
    my_badges, CompanyManagementViewSet, CompanyUsersViewSet, CompanyCourseViewSet
)
from core.views import QuizDetailView, SubmitQuizView, login_view, CourseViewSet, UserAssignedCoursesViewSet, CourseAssignmentViewSet, create_company, list_companies, get_company, CompanyManagementViewSet, CompanyUsersViewSet, CompanyCourseViewSet, CompetencyViewSet

router = DefaultRouter()
router.register(r'courses', CourseViewSet, basename='course')
router.register(r'course-assignments', CourseAssignmentViewSet, basename='course-assignment')
router.register(r'companies', CompanyManagementViewSet, basename='company')
router.register(r'competencies', CompetencyViewSet, basename='competency')

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/login/', login_view, name='api-login'),
    path('api/companies/new/', create_company, name='api-create-company'),
    path('api/companies/all/', list_companies, name='api-list-companies'),
    path('api/companies/details/<int:pk>/', get_company, name='api-get-company'),
    
    path('api/', include(router.urls)),

    path('api/users/<int:user_id>/courses/', UserAssignedCoursesViewSet.as_view({'get': 'list'}), name='user-courses'),
    
    path('api/quizzes/<int:pk>/', QuizDetailView.as_view(), name='quiz-detail'),
    path('api/quizzes/<int:pk>/submit/', SubmitQuizView.as_view(), name='quiz-submit'),

    path('api/my-badges/', my_badges, name='my-badges'),

    # User Management
    path('companies/<int:company_pk>/users/', CompanyUsersViewSet.as_view({'get': 'list', 'post': 'create'}), name='company-users'),
    path('companies/<int:company_pk>/users/<int:pk>/', CompanyUsersViewSet.as_view({'delete': 'destroy'}), name='company-user-delete'),

    # Course Management
    path('companies/<int:company_pk>/courses/', CompanyCourseViewSet.as_view({'get': 'list', 'post': 'create'}), name='company-courses'),
    path('companies/<int:company_pk>/courses/assign/', CompanyCourseViewSet.as_view({'post': 'assign_users'}), name='company-course-assign'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)