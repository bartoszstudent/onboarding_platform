from django.db import models
# REMOVED: from .section import Section

class Quiz(models.Model):
    # REMOVED: section = models.ForeignKey(Section, on_delete=models.CASCADE, related_name='quizzes')
    title = models.CharField(max_length=255)
    # REMOVED: order = models.PositiveIntegerField(default=0)
    
    # You can add other fields here later, like a description.

    def __str__(self):
        return self.title