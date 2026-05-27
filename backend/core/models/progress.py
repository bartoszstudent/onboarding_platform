from django.db import models
from .training import CourseAssignment
from .section import Section


class SectionProgress(models.Model):
    assignment = models.ForeignKey(CourseAssignment, on_delete=models.CASCADE)
    section = models.ForeignKey(Section, on_delete=models.CASCADE)
    completed = models.BooleanField(default=False)

    class Meta:
        unique_together = ('assignment', 'section')