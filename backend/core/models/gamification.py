from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models
from django.conf import settings
from .workspaces import Workspace
from .onboarding import OnboardingTaskInstance
from .training import Course
from django.utils import timezone


class Badge(models.Model):
    course = models.OneToOneField(
        Course,
        on_delete=models.CASCADE,
        related_name="badge",
        null=True,     # <-- add
        blank=True,    # <-- add
    )
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    image = models.ImageField(upload_to="badge_images/", blank=True, null=True)
    icon = models.CharField(max_length=50, default='star')
    category = models.CharField(max_length=100, default='Ogólne')
    rarity = models.CharField(max_length=50, default='common') # common, rare, epic, legendary
    xp_reward = models.IntegerField(default=100)

    def __str__(self):
        return self.name


class UserBadge(models.Model):
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['badge', 'user'], name='uniq_user_badge')
        ]


class MentorRating(models.Model):
        mentor = models.ForeignKey(
            settings.AUTH_USER_MODEL,
            on_delete=models.CASCADE,
            related_name="mentor_ratings"
        )
        # Zakładam, że task instance ma powiązanie z użytkownikiem (studentem), który ocenia
        onboarding_task_instance = models.ForeignKey(
            OnboardingTaskInstance,
            on_delete=models.CASCADE,
            related_name="mentor_ratings"
        )
        # Zmiana na Decimal dla ocen typu 4.5
        rating = models.DecimalField(
            max_digits=2,
            decimal_places=1,
            validators=[MinValueValidator(1.0), MaxValueValidator(5.0)]
        )
        created_at = models.DateTimeField(auto_now_add=True)

        class Meta:
            # Zapewnia, że jedno zadanie może być ocenione tylko raz
            constraints = [
                models.UniqueConstraint(
                    fields=['onboarding_task_instance'],
                    name='uniq_onboarding_task_rating'
                )
            ]

        def __str__(self):
            return f"Rating {self.rating} for Mentor {self.mentor_id}"
        
class XPTransaction(models.Model):
    """Rejestr pojedynczych transakcji zdobywania punktów doświadczenia przez użytkownika."""
    user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='xp_transactions')
    amount = models.IntegerField()
    reason = models.CharField(max_length=255)
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"{self.user.username}: +{self.amount} XP ({self.reason})"


class Milestone(models.Model):
    """Definicja progów poziomów (kamieni milowych) ustawiana globalnie w systemie."""
    level = models.IntegerField(unique=True)
    title = models.CharField(max_length=100)
    required_xp = models.IntegerField()

    def __str__(self):
        return f"Poziom {self.level}: {self.title} ({self.required_xp} XP)"