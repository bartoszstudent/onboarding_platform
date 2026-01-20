from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models.training import Course, CourseAssignment
from .models.workspaces import Company
from .models.gamification import Badge, UserBadge
from .models.quiz import Quiz
from .models.question import Question
from .models.answer import Answer
from .models.checkpoint import Checkpoint

User = get_user_model()

class CompanySerializer(serializers.ModelSerializer):
    """Serializer do tworzenia i pobierania firm"""
    class Meta:
        model = Company
        fields = [
            "id", "name", "domain", "logo_url", 
            "primary_color", "secondary_color", "accent_color", "created_at"
        ]
        read_only_fields = ["id", "created_at"]

class CheckpointSerializer(serializers.ModelSerializer):
    class Meta:
        model = Checkpoint
        fields = ['id', 'title', 'content', 'order']

class BadgeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Badge
        fields = ['id', 'name', 'description', 'image_url'] 

class UserBadgeSerializer(serializers.ModelSerializer):
    badge = BadgeSerializer() # Nested serializer to show badge details
    class Meta:
        model = UserBadge
        fields = ['id', 'badge', 'awarded_at']

class CourseSerializer(serializers.ModelSerializer):
    checkpoints = CheckpointSerializer(many=True, read_only=True)
    badge = BadgeSerializer(read_only=True)
    
    # Changed to URLField
    badge_image_url = serializers.URLField(write_only=True, required=False)
    badge_name = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = Course
        fields = ['id', 'workspace', 'title', 'checkpoints', 'badge', 'badge_image_url', 'badge_name']

    def create(self, validated_data):
        badge_image_url = validated_data.pop('badge_image_url', None)
        badge_name = validated_data.pop('badge_name', None)
        
        course = Course.objects.create(**validated_data)
        
        if badge_image_url:
            Badge.objects.create(
                course=course,
                name=badge_name if badge_name else f"{course.title} Badge",
                image_url=badge_image_url,
                workspace=course.workspace
            )
        return course

class CourseAssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = CourseAssignment
        fields = ['id', 'course', 'user', 'assigned_by_user', 'status']
        read_only_fields = ['assigned_by_user']

class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['id', 'answer_text'] 

class QuestionSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(many=True, read_only=True) 

    class Meta:
        model = Question
        fields = ['id', 'question_text', 'question_type', 'image_url', 'answers']

class QuizDetailSerializer(serializers.ModelSerializer):
    questions = QuestionSerializer(many=True, read_only=True) 

    class Meta:
        model = Quiz
        fields = ['id', 'title', 'questions']