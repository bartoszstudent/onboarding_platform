from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from core.views import login_view, CourseViewSet, UserAssignedCoursesViewSet, CourseAssignmentViewSet

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'courses', CourseViewSet)
router.register(r'course-assignments', CourseAssignmentViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/login/', login_view, name='api-login'),
    
    # The API URLs are now determined automatically by the router.
    path('api/', include(router.urls)),

    # Custom URL for getting courses for a specific user
    path('api/users/<int:user_id>/courses/', UserAssignedCoursesViewSet.as_view({'get': 'list'}), name='user-courses'),
]