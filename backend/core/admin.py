from django.contrib import admin
from . import models

# Register your models here.
admin.site.register(models.Company)
admin.site.register(models.Workspace)
admin.site.register(models.Course)
admin.site.register(models.CourseAssignment)
admin.site.register(models.OnboardingTemplate)
admin.site.register(models.Onboarding)
admin.site.register(models.Competency)