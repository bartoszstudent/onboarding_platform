from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from core.views import QuizDetailView, SubmitQuizView, login_view, CourseViewSet, UserAssignedCoursesViewSet, CourseAssignmentViewSet, create_company, list_companies, get_company

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
    path('api/quizzes/<int:pk>/', QuizDetailView.as_view(), name='quiz-detail'),
    
    # URL to submit answers for a quiz
    path('api/quizzes/<int:pk>/submit/', SubmitQuizView.as_view(), name='quiz-submit'),
]
