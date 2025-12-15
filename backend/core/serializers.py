from rest_framework import serializers
from .models.training import Course, CourseAssignment
from django.contrib.auth import get_user_model

User = get_user_model()

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = ['id', 'workspace', 'title']

class CourseAssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseAssignment
        fields = ['id', 'course', 'user', 'assigned_by_user', 'status']
        read_only_fields = ['assigned_by_user'] # Set automatically