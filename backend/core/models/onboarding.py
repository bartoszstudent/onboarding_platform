from django.db import models
from django.conf import settings
from .workspaces import Workspace

class OnboardingTemplate(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    created_by_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

class OnboardingTaskTemplate(models.Model):
    template = models.ForeignKey(OnboardingTemplate, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    sequence = models.PositiveIntegerField()

class Onboarding(models.Model):
    template = models.ForeignKey(OnboardingTemplate, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='onboarded_user', on_delete=models.CASCADE)
    mentor = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='onboarding_mentor', on_delete=models.SET_NULL, null=True)
    status = models.CharField(max_length=50)

class OnboardingTaskInstance(models.Model):
    onboarding = models.ForeignKey(Onboarding, on_delete=models.CASCADE)
    template_task = models.ForeignKey(OnboardingTaskTemplate, on_delete=models.CASCADE)

    assigned_to_user = models.ForeignKey(settings.AUTH_USER_MODEL,
                                         related_name='assigned_to_user',
                                         on_delete=models.SET_NULL, null=True)

    assigned_by_user = models.ForeignKey(settings.AUTH_USER_MODEL,
                                         related_name='assigned_by_user',
                                         on_delete=models.SET_NULL, null=True)

    mentor_user = models.ForeignKey(settings.AUTH_USER_MODEL,
                                    related_name='mentor_task_user',
                                    on_delete=models.SET_NULL, null=True)

    status = models.CharField(max_length=50)
