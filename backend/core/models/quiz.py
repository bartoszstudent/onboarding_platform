# backend/core/models/quiz.py

from django.db import models
from .section import Section

class Quiz(models.Model):
    section = models.ForeignKey(Section, on_delete=models.CASCADE, related_name='quizzes')
    title = models.CharField(max_length=255)
    order = models.PositiveIntegerField(default=0)

    def __str__(self):
        return f"{self.title} (Section: {self.section.title})"