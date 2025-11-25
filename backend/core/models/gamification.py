from django.db import models
from django.conf import settings
from .workspaces import Workspace
from .onboarding import OnboardingTaskInstance


class Badge(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)


class UserBadge(models.Model):
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)


class MentorRating(models.Model):
    mentor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    onboarding_task_instance = models.ForeignKey(OnboardingTaskInstance, on_delete=models.CASCADE)
    rating = models.PositiveIntegerField()
