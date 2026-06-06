from rest_framework import serializers
from .models.training import Course, CourseAssignment
from .models.section import Section
from .models.block import Block
from django.contrib.auth import get_user_model
from .models.workspaces import Company
from .models import UserCompany, Company, CourseAssignment, Quiz
from .models.competencies import Competency, CompetencyCourse
from .models import Badge, Question, Answer

# ============================================================================
# BLOCK SERIALIZERS
# ============================================================================

class QuizDetailBlockSerializer(serializers.ModelSerializer):
    """Serializer for Quiz details within a Block"""
    questions = serializers.SerializerMethodField()
    
    class Meta:
        model = Quiz
        fields = ['id', 'title', 'questions']
    
    def get_questions(self, obj):
        """Get questions with answers for the quiz"""
        from .serializers import QuestionSerializer
        questions = obj.questions.all()
        return QuestionSerializer(questions, many=True).data


class BlockSerializer(serializers.ModelSerializer):
    """
    Serializer for Block model.
    Handles all block types: TEXT, IMAGE, VIDEO, QUIZ
    Dynamically includes content based on block_type
    """
    # Include quiz details if this is a quiz block
    quiz_details = serializers.SerializerMethodField()
    
    # Content field that returns the appropriate content based on block_type
    content = serializers.SerializerMethodField()
    
    class Meta:
        model = Block
        fields = [
            'id',
            'order',
            'block_type',
            'content',
            'quiz_details',
            'text_content',
            'image_url',
            'image_alt',
            'video_url',
        ]
        read_only_fields = ['id']
    
    def get_content(self, obj):
        """Return the appropriate content field based on block_type"""
        if obj.block_type == Block.BlockType.TEXT:
            return obj.text_content
        elif obj.block_type == Block.BlockType.IMAGE:
            return obj.image_url
        elif obj.block_type == Block.BlockType.VIDEO:
            return obj.video_url
        elif obj.block_type == Block.BlockType.QUIZ:
            return None  # Quiz content is in quiz_details
        return None
    
    def get_quiz_details(self, obj):
        """Return full quiz details if this is a QUIZ block"""
        if obj.block_type == Block.BlockType.QUIZ and obj.quiz:
            return QuizDetailBlockSerializer(obj.quiz).data
        return None
    
    def validate_block_type(self, value):
        """Validate that block_type is one of the allowed choices"""
        valid_types = [choice[0] for choice in Block.BlockType.choices]
        if value not in valid_types:
            raise serializers.ValidationError(
                f"Invalid block type. Must be one of: {', '.join(valid_types)}"
            )
        return value


# ============================================================================
# SECTION SERIALIZERS
# ============================================================================

class SectionSerializer(serializers.ModelSerializer):
    """
    Serializer for Section model with nested blocks.
    Optimized for frontend structure: Section contains Blocks
    """
    blocks = BlockSerializer(many=True, read_only=True)
    blocks_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Section
        fields = [
            'id',
            'title',
            'order',
            'blocks',
            'blocks_count',
            'created_at', 
            'updated_at',
        ]
        read_only_fields = ['id']
    
    def get_blocks_count(self, obj):
        """Get total number of blocks in section"""
        return obj.blocks.count()


class SectionCreateUpdateSerializer(serializers.ModelSerializer):
    """Serializer for creating/updating sections (without nested blocks)"""
    
    class Meta:
        model = Section
        fields = [
            'id',
            'title',
            'order',
        ]
        read_only_fields = ['id']


# ============================================================================
# COURSE SERIALIZERS
# ============================================================================

class CourseListSerializer(serializers.ModelSerializer):
    """
    Simplified course serializer for list endpoints.
    Returns basic course info with section count.
    """
    sections_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Course
        fields = [
            'id',
            'workspace',
            'title',
            'description',
            'thumbnail',
            'duration',
            'completion_badge',
            'sections_count',
        ]
        read_only_fields = ['id']
    
    def get_sections_count(self, obj):
        """Get total number of sections in course"""
        return obj.sections.count()


class CourseDetailSerializer(serializers.ModelSerializer):
    """
    Complete course serializer with full nested structure.
    Course → Sections → Blocks (with all block details)
    
    Includes:
    - All course metadata
    - All sections in order
    - All blocks for each section in order
    - Quiz details for quiz blocks
    
    Frontend can render the full course structure from this single endpoint.
    """
    sections = SectionSerializer(many=True, read_only=True)
    badge_details = serializers.SerializerMethodField()
    total_blocks = serializers.SerializerMethodField()
    
    class Meta:
        model = Course
        fields = [
            'id',
            'workspace',
            'title',
            'description',
            'thumbnail',
            'duration',
            'completion_badge',
            'badge_details',
            'sections',
            'total_blocks',
            'created_at', 
            'updated_at',
        ]
        read_only_fields = ['id', 'workspace']
    
    def get_badge_details(self, obj):
        """Return badge details if completion_badge is set"""
        if obj.completion_badge:
            return BadgeSerializer(obj.completion_badge).data
        return None
    
    def get_total_blocks(self, obj):
        """Calculate total number of blocks across all sections"""
        return sum(section.blocks.count() for section in obj.sections.all())


class CourseSerializer(serializers.ModelSerializer):
    """
    Standard course serializer for basic CRUD operations.
    Use CourseDetailSerializer for full nested data.
    """
    
    class Meta:
        model = Course
        fields = [
            'id',
            'workspace',
            'title',
            'description',
            'thumbnail',
            'duration',
            'completion_badge',
        ]
        read_only_fields = ['id']


class CourseCreateUpdateSerializer(serializers.ModelSerializer):
    """Serializer for creating and updating courses"""
    
    class Meta:
        model = Course
        fields = [
            'workspace',
            'title',
            'description',
            'thumbnail',
            'duration',
            'completion_badge',
        ]
    
    def validate_title(self, value):
        """Validate that title is not empty"""
        if not value or not value.strip():
            raise serializers.ValidationError("Course title cannot be empty.")
        return value.strip()


# ============================================================================
# QUIZ/QUESTION/ANSWER SERIALIZERS
# ============================================================================

class AnswerSerializer(serializers.ModelSerializer):
    """Serializer for Answer model"""
    
    class Meta:
        model = Answer
        fields = ['id', 'answer_text']
        # IMPORTANT: Don't send is_correct to the user!
        read_only_fields = ['id']


class QuestionSerializer(serializers.ModelSerializer):
    """Serializer for Question model with nested answers"""
    answers = AnswerSerializer(many=True, read_only=True)
    
    class Meta:
        model = Question
        fields = ['id', 'question_text', 'question_type', 'image_url', 'answers']
        read_only_fields = ['id']


class QuizDetailSerializer(serializers.ModelSerializer):
    """Serializer for Quiz with full question details"""
    questions = QuestionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Quiz
        fields = ['id', 'title', 'questions']
        read_only_fields = ['id']


# ============================================================================
# BADGE SERIALIZER
# ============================================================================

class BadgeSerializer(serializers.ModelSerializer):
    """Serializer for Badge model"""
    
    class Meta:
        model = Badge
        fields = ['id', 'name', 'description', 'image']
        read_only_fields = ['id']


# ============================================================================
# COMPANY SERIALIZERS
# ============================================================================

class CompanySerializer(serializers.ModelSerializer):
    """Serializer for Company/Workspace model"""

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


# ============================================================================
# COURSE ASSIGNMENT SERIALIZERS
# ============================================================================

class CourseAssignmentSerializer(serializers.ModelSerializer):
    """Serializer for CourseAssignment model"""
    badge_id = serializers.IntegerField(write_only=True, required=False)

    class Meta:
        model = CourseAssignment
        fields = ['id', 'course', 'user', 'assigned_by_user', 'status', 'badge_id']
        read_only_fields = ['assigned_by_user']

    def update(self, instance, validated_data):
        validated_data.pop('badge_id', None)
        return super().update(instance, validated_data)

    def create(self, validated_data):
        validated_data.pop('badge_id', None)
        return super().create(validated_data)


class BulkCourseAssignmentSerializer(serializers.Serializer):
    """Serializer for bulk assigning users to a course"""
    course_id = serializers.IntegerField()
    user_ids = serializers.ListField(
        child=serializers.IntegerField(),
        allow_empty=False
    )


# ============================================================================
# USER COMPANY SERIALIZERS
# ============================================================================

class UserCompanyListSerializer(serializers.ModelSerializer):
    """Serializer for listing company users"""
    email = serializers.EmailField(source='user.email')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    user_id = serializers.IntegerField(source='user.id')
    courses_count = serializers.SerializerMethodField()

    class Meta:
        model = UserCompany
        fields = ['id', 'user_id', 'email', 'first_name', 'last_name', 'role', 'courses_count']

    def get_courses_count(self, obj):
        """Get count of assigned courses for user"""
        try:
            return CourseAssignment.objects.filter(user=obj.user).count()
        except Exception:
            return 0


class CompanyUserAddSerializer(serializers.ModelSerializer):
    """Serializer for adding users to company"""
    email = serializers.EmailField()
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    role = serializers.ChoiceField(
        choices=[('employee', 'Employee'), ('admin', 'Admin')],
        default='employee'
    )

    class Meta:
        model = UserCompany
        fields = ['email', 'first_name', 'last_name', 'role']


# ============================================================================
# COMPETENCY SERIALIZERS
# ============================================================================

class CompetencySerializer(serializers.ModelSerializer):
    """Serializer for creating/updating competencies"""
    courses = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Course.objects.all(),
        required=False,
        write_only=True
    )

    class Meta:
        model = Competency
        fields = ['id', 'workspace', 'name', 'description', 'courses']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        # Filter courses based on workspace
        request = self.context.get('request')
        if request and request.method in ['POST', 'PUT', 'PATCH']:
            # During create/update - filter by workspace from request
            workspace_id = request.data.get('workspace')
            if workspace_id:
                self.fields['courses'].queryset = Course.objects.filter(workspace_id=workspace_id)
        elif self.instance:
            # During update of existing competency
            self.fields['courses'].queryset = Course.objects.filter(workspace=self.instance.workspace)

    def validate(self, data):
        """Validate that selected courses belong to the same workspace"""
        workspace = data.get('workspace')
        courses = data.get('courses', [])

        if workspace and courses:
            for course in courses:
                if course.workspace != workspace:
                    raise serializers.ValidationError({
                        'courses': f'Kurs "{course.title}" nie należy do wybranego workspace.'
                    })

        return data

    def create(self, validated_data):
        courses_data = validated_data.pop('courses', [])
        competency = Competency.objects.create(**validated_data)

        # Assign courses to competency
        for course in courses_data:
            CompetencyCourse.objects.create(competency=competency, course=course)

        return competency

    def update(self, instance, validated_data):
        courses_data = validated_data.pop('courses', None)

        # Update basic fields
        instance.name = validated_data.get('name', instance.name)
        instance.description = validated_data.get('description', instance.description)
        instance.workspace = validated_data.get('workspace', instance.workspace)
        instance.save()

        # Update course relationships if provided
        if courses_data is not None:
            CompetencyCourse.objects.filter(competency=instance).delete()
            for course in courses_data:
                CompetencyCourse.objects.create(competency=instance, course=course)

        return instance


class CompetencyDetailSerializer(serializers.ModelSerializer):
    """Detailed serializer with full course information"""
    courses = serializers.SerializerMethodField()

    class Meta:
        model = Competency
        fields = ['id', 'workspace', 'name', 'description', 'courses']

    def get_courses(self, obj):
        """Get full course details for courses in this competency"""
        competency_courses = CompetencyCourse.objects.filter(
            competency=obj
        ).select_related('course')
        courses = [cc.course for cc in competency_courses]
        return CourseListSerializer(courses, many=True).data
