from django.db import models
from django.conf import settings
from .workspaces import Workspace
from .onboarding import OnboardingTaskInstance


class Badge(models.Model):
    workspace = models.ForeignKey(
        Workspace, on_delete=models.CASCADE, related_name="badges"
    )
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    image = models.ImageField(upload_to="badge_images/", blank=True, null=True)

    def __str__(self):
        return self.name


class UserBadge(models.Model):
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)


class MentorRating(models.Model):
    mentor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    onboarding_task_instance = models.ForeignKey(
        OnboardingTaskInstance, on_delete=models.CASCADE
    )
    rating = models.PositiveIntegerField()