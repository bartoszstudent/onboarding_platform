from rest_framework import serializers
from .models.training import Course, CourseAssignment
from django.contrib.auth import get_user_model
from .models.workspaces import Company

class CompanySerializer(serializers.ModelSerializer):
    """Serializer do tworzenia i pobierania firm"""

    class Meta:
        model = Company
        fields = [
            "id",
            "name",
            "domain",
            "logo_url",
            "primary_color",
            "secondary_color",
            "accent_color",
            "created_at",
        ]
        read_only_fields = ["id", "created_at"]

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
from .models import Quiz, Question, Answer

class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['id', 'answer_text'] # IMPORTANT: Don't send is_correct to the user!

class QuestionSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(many=True, read_only=True) # Nested serializer

    class Meta:
        model = Question
        fields = ['id', 'question_text', 'question_type', 'image_url', 'answers']

class QuizDetailSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True, read_only=True) # Nested serializer

    class Meta:
        model = Quiz
        fields = ['id', 'title', 'questions']
