from rest_framework import serializers
from .models.training import Course, CourseAssignment
from django.contrib.auth import get_user_model
from .models.workspaces import Company
from .models import UserCompany, Company, CourseAssignment, OnboardingTemplate, \
    OnboardingTaskTemplate, Onboarding, \
    OnboardingTaskInstance
from .models.competencies import Competency, CompetencyCourse
from .models import Badge

class BadgeSerializer(serializers.ModelSerializer):
    """
    Serializer for the Badge model.
    """
    class Meta:
        model = Badge
        fields = ['id', 'course', 'name', 'description', 'image']


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
        fields = [
            'id',
            'workspace',
            'title',
            'description',
            'thumbnail',
            'duration',
            'completion_badge',
        ]

class CourseAssignmentSerializer(serializers.ModelSerializer):
    badge_id = serializers.IntegerField(write_only=True, required=False)

    class Meta:
        model = CourseAssignment
        fields = ['id', 'course', 'user', 'assigned_by_user', 'status', 'badge_id']
        read_only_fields = ['assigned_by_user'] # Set automatically

    def update(self, instance, validated_data):
        validated_data.pop('badge_id', None)
        return super().update(instance, validated_data)

    def create(self, validated_data):
        validated_data.pop('badge_id', None)
        return super().create(validated_data)
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
        
class CompanyUserAddSerializer(serializers.ModelSerializer):
    """Służy do dodawania istniejącego lub nowego użytkownika do firmy"""
    email = serializers.EmailField()
    first_name = serializers.CharField(required=False)
    last_name = serializers.CharField(required=False)
    role = serializers.ChoiceField(choices=[('employee', 'Employee'), ('admin', 'Admin')], default='employee')

    class Meta:
        model = UserCompany
        fields = ['email', 'first_name', 'last_name', 'role']

class UserCompanyListSerializer(serializers.ModelSerializer):
    """Do wyświetlania listy pracowników"""
    email = serializers.EmailField(source='user.email')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    user_id = serializers.IntegerField(source='user.id')
    courses_count = serializers.SerializerMethodField()

    class Meta:
        model = UserCompany
        fields = ['id', 'user_id', 'email', 'first_name', 'last_name', 'role', 'courses_count']

    def get_courses_count(self, obj):
        # Liczymy przypisania kursów dla użytkownika (CourseAssignment)
        try:
            return CourseAssignment.objects.filter(user=obj.user).count()
        except Exception:
            return 0

# --- Serializery do Przypisywania Kursów ---

class BulkCourseAssignmentSerializer(serializers.Serializer):
    """Pozwala przypisać wielu użytkowników do jednego kursu na raz"""
    course_id = serializers.IntegerField()
    user_ids = serializers.ListField(
        child=serializers.IntegerField(),
        allow_empty=False
    )

# --- Serializery do Kompetencji ---

class CompetencySerializer(serializers.ModelSerializer):
    """Serializer for listing and creating competencies"""
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
        
        # Filtruj kursy na podstawie workspace
        request = self.context.get('request')
        if request and request.method in ['POST', 'PUT', 'PATCH']:
            # Podczas tworzenia/edycji - filtruj na podstawie workspace z requesta
            workspace_id = request.data.get('workspace')
            if workspace_id:
                self.fields['courses'].queryset = Course.objects.filter(workspace_id=workspace_id)
        elif self.instance:
            # Podczas edycji istniejącej kompetencji
            self.fields['courses'].queryset = Course.objects.filter(workspace=self.instance.workspace)
    
    def validate(self, data):
        """Sprawdź czy wybrane kursy należą do tego samego workspace co kompetencja"""
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
        
        # Przypisz kursy do kompetencji
        for course in courses_data:
            CompetencyCourse.objects.create(competency=competency, course=course)
        
        return competency
    
    def update(self, instance, validated_data):
        courses_data = validated_data.pop('courses', None)
        
        # Aktualizuj podstawowe pola
        instance.name = validated_data.get('name', instance.name)
        instance.description = validated_data.get('description', instance.description)
        instance.workspace = validated_data.get('workspace', instance.workspace)
        instance.save()
        
        # Jeśli przesłano kursy, zaktualizuj relacje
        if courses_data is not None:
            # Usuń istniejące relacje
            CompetencyCourse.objects.filter(competency=instance).delete()
            # Dodaj nowe
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
        competency_courses = CompetencyCourse.objects.filter(competency=obj).select_related('course')
        courses = [cc.course for cc in competency_courses]
        return CourseSerializer(courses, many=True).data


# ==========================================
# 1. SZABLONY ONBOARDINGU (Templates)
# ==========================================

class OnboardingTaskTemplateSerializer(serializers.ModelSerializer):
    class Meta:
        model = OnboardingTaskTemplate
        fields = ['id', 'template', 'title', 'sequence']


class OnboardingTemplateSerializer(serializers.ModelSerializer):
    # Wyświetlamy zadania szablonu jako zagnieżdżoną listę (tylko do odczytu w tym miejscu)
    tasks = OnboardingTaskTemplateSerializer(many=True, read_only=True, source='onboardingtasktemplate_set')

    class Meta:
        model = OnboardingTemplate
        fields = ['id', 'workspace', 'name', 'created_by_user', 'tasks']
        read_only_fields = ['created_by_user']

    def create(self, validated_data):
        # Automatycznie przypisujemy zalogowanego użytkownika jako twórcę
        request = self.context.get('request')
        if request and request.user:
            validated_data['created_by_user'] = request.user
        return super().create(validated_data)


# ==========================================
# 2. INSTANCJE ONBOARDINGU (User Instances)
# ==========================================

class OnboardingTaskInstanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = OnboardingTaskInstance
        fields = ['id', 'onboarding', 'template_task', 'assigned_to_user', 'assigned_by_user', 'mentor_user', 'status']
        read_only_fields = ['assigned_by_user']

    def validate(self, data):
        """
        Walidacja spójności: Sprawdza, czy szablon zadania (template_task)
        należy do tego samego szablonu głównego, na którym bazuje instancja onboardingu.
        """
        onboarding = data.get('onboarding') or (self.instance.onboarding if self.instance else None)
        template_task = data.get('template_task') or (self.instance.template_task if self.instance else None)

        if onboarding and template_task:
            if template_task.template != onboarding.template:
                raise serializers.ValidationError({
                    "template_task": "Wybrane zadanie nie należy do szablonu przypisanego do tego procesu onboardingu."
                })
        return data

    def create(self, validated_data):
        request = self.context.get('request')
        if request and request.user:
            validated_data['assigned_by_user'] = request.user
        return super().create(validated_data)


class OnboardingSerializer(serializers.ModelSerializer):
    # Podgląd powiązanych zadań-instancji wewnątrz widoku szczegółowego onboardingu
    task_instances = OnboardingTaskInstanceSerializer(many=True, read_only=True, source='onboardingtaskinstance_set')

    class Meta:
        model = Onboarding
        fields = ['id', 'template', 'user', 'mentor', 'status', 'task_instances']

    def create(self, validated_data):
        """
        Automatyzacja cyklu życia: Podczas tworzenia nowego onboardingu dla użytkownika,
        system automatycznie generuje dla niego instancje zadań na podstawie szablonu.
        """
        template = validated_data['template']
        onboarding = Onboarding.objects.create(**validated_data)

        # Pobierz wszystkie definicje zadań z szablonu
        task_templates = OnboardingTaskTemplate.objects.filter(template=template)

        # Generuj instancje zadań dla użytkownika
        request = self.context.get('request')
        assigned_by = request.user if request and request.user.is_authenticated else None

        task_instances = [
            OnboardingTaskInstance(
                onboarding=onboarding,
                template_task=task_template,
                assigned_to_user=onboarding.user,
                assigned_by_user=assigned_by,
                mentor_user=onboarding.mentor,
                status="pending"  # Domyślny status początkowy
            )
            for task_template in task_templates
        ]

        # Masowe dodawanie do bazy (wydajność SQL Optimization)
        OnboardingTaskInstance.objects.bulk_create(task_instances)

        return onboarding