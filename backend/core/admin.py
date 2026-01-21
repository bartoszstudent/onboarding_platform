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
admin.site.register(models.Company)
admin.site.register(models.UserCompany)
admin.site.register(models.Workspace)
admin.site.register(models.Course)
admin.site.register(models.CourseAssignment)
admin.site.register(models.Section)
admin.site.register(models.Block)
admin.site.register(models.Quiz)
admin.site.register(models.Question)
admin.site.register(models.Answer)
admin.site.register(models.OnboardingTemplate)
admin.site.register(models.Onboarding)
admin.site.register(models.Competency, CompetencyAdmin)
admin.site.register(models.CompetencyCourse, CompetencyCourseAdmin)