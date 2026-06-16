from django.db import models
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.utils import timezone

User = get_user_model()

# Stałe dla ról - definiujesz dostępne role w jednym miejscu
class UserRole:
    HR = "hr"
    MENTOR = "mentor"
    EMPLOYEE = "employee"
    ADMIN = "admin"
    OWNER = "owner"
    
    CHOICES = [
        (HR, "HR"),
        (MENTOR, "Mentor"),
        (EMPLOYEE, "Employee"),
        (ADMIN, "Admin"),
        (OWNER, "Owner"),
    ]
    
    # Role z dostępem administracyjnym
    ADMIN_ROLES = {HR, ADMIN, OWNER}

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
    """
    Łączy użytkownika z firmą i przypisuje mu rolę.
    
    Role:
    - owner: Pełne uprawnienia do firmy
    - admin: Zarządzanie użytkownikami i kursami
    - hr: Zarządzanie onboardingiem i pracownikami
    - mentor: Może mentorować pracowników
    - employee: Standardowy pracownik
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="user_company")
    company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name="company_users")
    role = models.CharField(
        max_length=50, 
        choices=UserRole.CHOICES,
        default=UserRole.EMPLOYEE
    )
    assigned_at = models.DateTimeField(auto_now_add=True)
    assigned_by = models.ForeignKey(
        User, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name="assigned_users"
    )
    
    class Meta:
        unique_together = ('user', 'company')
        ordering = ['-assigned_at']

    def __str__(self):
        return f"{self.user.username} ({self.role}) -> {self.company.name}"
    
    def is_admin(self):
        """Czy użytkownik ma uprawnienia administracyjne"""
        return self.role in UserRole.ADMIN_ROLES
    
    def can_manage_users(self):
        """Czy użytkownik może zarządzać innymi użytkownikami"""
        return self.role in [UserRole.OWNER, UserRole.ADMIN, UserRole.HR]
    
    def can_manage_courses(self):
        """Czy użytkownik może zarządzać kursami"""
        return self.role in [UserRole.OWNER, UserRole.ADMIN]
    
    def clean(self):
        """Walidacja - zapobiega przypisaniu niedozwolonych ról"""
        if self.role not in dict(UserRole.CHOICES):
            raise ValidationError(f"Niedozwolona rola: {self.role}")

class Invitation(models.Model):
    workspace = models.ForeignKey(Workspace, on_delete=models.CASCADE, related_name="invitations")
    email = models.EmailField()
    token = models.CharField(max_length=255)
    invited_by_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sent_invitations")

    def __str__(self):
        return f"Invitation to {self.email} for {self.workspace.name}"