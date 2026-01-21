from django.db import models
from django.conf import settings
from .workspaces import Workspace
from .training import Course


class Competency(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, default='')

    class Meta:
        verbose_name_plural = "Competencies"

    def __str__(self):
        return self.name


class CompetencyCourse(models.Model):
    competency = models.ForeignKey(Competency, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)


class UserCompetency(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    competency = models.ForeignKey(Competency, on_delete=models.CASCADE)
    level = models.PositiveIntegerField()