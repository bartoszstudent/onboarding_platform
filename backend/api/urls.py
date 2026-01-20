from django.contrib import admin
from django.urls import path, include
from django.conf import settings # Added import
from django.conf.urls.static import static # Added import
from rest_framework.routers import DefaultRouter
from core.views import (
    QuizDetailView, SubmitQuizView, login_view, CourseViewSet, 
    UserAssignedCoursesViewSet, CourseAssignmentViewSet, 
    create_company, list_companies, get_company,
    my_badges # Added import
)

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'courses', CourseViewSet)
router.register(r'course-assignments', CourseAssignmentViewSet)

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
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)