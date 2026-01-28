from django.db import models

class Quiz(models.Model):
    title = models.CharField(max_length=255)
    
    # The minimum percentage required to pass
    passing_score = models.PositiveIntegerField(default=50, help_text="Minimum percentage required to pass (0-100)")

    def __str__(self):
        return self.title