# backend/core/models/section.py

from django.db import models
from .training import Course

class Section(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='sections')
    title = models.CharField(max_length=255)
    order = models.PositiveIntegerField(default=0)

    def __str__(self):
        return f"{self.title} (Course: {self.course.title})"