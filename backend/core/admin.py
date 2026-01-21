from django.contrib import admin
from . import models

# Custom admin for CompetencyCourse
class CompetencyCourseAdmin(admin.ModelAdmin):
    list_display = ['competency', 'course']
    list_filter = ['competency__workspace']
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        """Filtruj kursy na podstawie workspace wybranej kompetencji"""
        if db_field.name == "course":
            # Pobierz competency_id z URL-a lub z POST data
            competency_id = request.resolver_match.kwargs.get('object_id')
            if not competency_id and request.method == 'POST':
                competency_id = request.POST.get('competency')
            
            if competency_id:
                try:
                    competency = models.Competency.objects.get(pk=competency_id)
                    kwargs["queryset"] = models.Course.objects.filter(workspace=competency.workspace)
                except models.Competency.DoesNotExist:
                    pass
        
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

# Inline admin for CompetencyCourse within Competency
class CompetencyCourseInline(admin.TabularInline):
    model = models.CompetencyCourse
    extra = 1
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        """Filtruj kursy na podstawie workspace kompetencji"""
        if db_field.name == "course":
            # Pobierz competency_id z URL-a
            competency_id = request.resolver_match.kwargs.get('object_id')
            if competency_id:
                try:
                    competency = models.Competency.objects.get(pk=competency_id)
                    kwargs["queryset"] = models.Course.objects.filter(workspace=competency.workspace)
                except models.Competency.DoesNotExist:
                    pass
        
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

# Custom admin for Competency with inline courses
class CompetencyAdmin(admin.ModelAdmin):
    list_display = ['name', 'workspace', 'description']
    list_filter = ['workspace']
    search_fields = ['name', 'description']
    inlines = [CompetencyCourseInline]

# Register your models here to see them in the admin UI.
# This will now work because __init__.py is correctly configured.

# --- Inlines ---

# This allows you to add Questions directly inside a Quiz
class QuestionInline(admin.StackedInline):
    model = models.Question
    extra = 1

# This allows you to add Answers directly inside a Question
class AnswerInline(admin.TabularInline):
    model = models.Answer
    extra = 2

# This allows you to add a BADGE directly inside a COURSE (Your request)
class BadgeInline(admin.StackedInline):
    model = models.Badge
    can_delete = False
    verbose_name_plural = 'Badge (Optional)'

class BlockInline(admin.StackedInline):
    model = models.Block
    extra = 0

class SectionInline(admin.StackedInline):
    model = models.Section
    extra = 0
    
admin.site.register(models.Company)
admin.site.register(models.UserCompany)
admin.site.register(models.Workspace)
admin.site.register(models.Course)
admin.site.register(models.Section)
admin.site.register(models.Block)
admin.site.register(models.Quiz)
admin.site.register(models.Question)
admin.site.register(models.Answer)
admin.site.register(models.Competency)
admin.site.register(models.Badge) 
admin.site.register(models.UserBadge)
admin.site.register(models.UserCompany)
admin.site.register(models.Invitation)
admin.site.register(models.CourseAssignment)
admin.site.register(models.CompetencyCourse)
admin.site.register(models.UserCompetency)
admin.site.register(models.Notification)
admin.site.register(models.OnboardingTemplate)
admin.site.register(models.Onboarding)
admin.site.register(models.Competency, CompetencyAdmin)
admin.site.register(models.CompetencyCourse, CompetencyCourseAdmin)
