from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Company(models.Model):
    name = models.CharField(max_length=255)
    domain = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

        # Pola personalizacji UI
    logo_url = models.URLField(blank=True, null=True)
    primary_color = models.CharField(max_length=7, default="#2563EB")
    secondary_color = models.CharField(max_length=7, default="#1E40AF")
    accent_color = models.CharField(max_length=7, default="#3B82F6")

    def __str__(self):
        return self.name

class Workspace(models.Model):
    company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name="workspaces")
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name
    
class UserCompany(models.Model):
        user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="user_company")
        company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name="company_users")
        role = models.CharField(max_length=50, default="employee")

        def __str__(self):
            return f"{self.user.username} -> {self.company.name}"

class Invitation(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE, related_name="invitations")
    email = models.EmailField()
    token = models.CharField(max_length=255)
    invited_by_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sent_invitations")

    def __str__(self):
        return f"Invitation to {self.email} for {self.workspace.name}"