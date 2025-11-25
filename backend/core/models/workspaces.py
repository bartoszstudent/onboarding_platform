from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Company(models.Model):
    name = models.CharField(max_length=255)
    domain = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Workspace(models.Model):
    company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name="workspaces")
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Invitation(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE, related_name="invitations")
    email = models.EmailField()
    token = models.CharField(max_length=255)
    invited_by_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sent_invitations")

    def __str__(self):
        return f"Invitation to {self.email} for {self.workspace.name}"