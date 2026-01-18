from django.contrib import admin
from . import models

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
admin.site.register(models.Competency)