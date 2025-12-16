from django.db import models
from django.conf import settings
from .workspaces import Workspace

# This file now defines the top-level training models.
# The content structure (Section, Block) is handled in separate files.

class Course(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)

    def __str__(self):
        return self.title


class CourseAssignment(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    assigned_by_user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='course_assigned_by', on_delete=models.SET_NULL, null=True)
    status = models.CharField(max_length=50)
