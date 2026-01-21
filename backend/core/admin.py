from django.contrib import admin
from . import models

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
