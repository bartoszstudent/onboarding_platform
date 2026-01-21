from django.db import models
from django.conf import settings
from .workspaces import Workspace
from .training import Course

class Badge(models.Model):
    # Link Badge to a Course (1 Course = 1 Badge)
    course = models.OneToOneField(Course, on_delete=models.CASCADE, related_name='badge', null=True, blank=True)
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE, null=True, blank=True)
    
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    
    # Changed to URLField as per your request (no Pillow/Upload needed)
    image_url = models.URLField(blank=True, null=True, help_text="Paste the URL of the badge image here")

    def __str__(self):
        return self.name

class UserBadge(models.Model):
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    awarded_at = models.DateTimeField(auto_now_add=True)