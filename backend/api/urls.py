from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
from core.views import (
    QuizDetailView, SubmitQuizView, login_view, CourseViewSet, 
    UserAssignedCoursesViewSet, CourseAssignmentViewSet, 
    create_company, list_companies, get_company,
    my_badges, CompanyManagementViewSet, CompanyUsersViewSet, 
    CompanyCourseViewSet, CompetencyViewSet
)

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'courses', CourseViewSet, basename='course')
router.register(r'course-assignments', CourseAssignmentViewSet)
router.register(r'companies', CompanyManagementViewSet, basename='company')
router.register(r'competencies', CompetencyViewSet, basename='competency')

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/login/', login_view, name='api-login'),
    path('api/companies/', create_company, name='api-create-company'),
    path('api/companies/list/', list_companies, name='api-list-companies'),
    path('api/companies/<int:pk>/', get_company, name='api-get-company'),
    
    # The API URLs are now determined automatically by the router.
    path('api/', include(router.urls)),

    # Custom URL for getting courses for a specific user
    path('api/users/<int:user_id>/courses/', UserAssignedCoursesViewSet.as_view({'get': 'list'}), name='user-courses'),
    
    # Quizzes
    path('api/quizzes/<int:pk>/', QuizDetailView.as_view(), name='quiz-detail'),
    path('api/quizzes/<int:pk>/submit/', SubmitQuizView.as_view(), name='quiz-submit'),

    # Badges
    path('api/my-badges/', my_badges, name='my-badges'),
    
    # Company Users Management
    path('companies/<int:company_pk>/users/', CompanyUsersViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('companies/<int:company_pk>/users/<int:pk>/', CompanyUsersViewSet.as_view({'delete': 'destroy'})),

    # Company Courses Management
    path('companies/<int:company_pk>/courses/', CompanyCourseViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('companies/<int:company_pk>/courses/assign/', CompanyCourseViewSet.as_view({'post': 'assign_users'})),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)