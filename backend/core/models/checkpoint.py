from django.db import models
from .training import Course

class Checkpoint(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='checkpoints')
    title = models.CharField(max_length=255)
    content = models.TextField(help_text="Content of the checkpoint/lesson", blank=True, null=True)
    order = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f"{self.course.title} - {self.title}"