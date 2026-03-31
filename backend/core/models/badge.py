from django.db import models

class Badge(models.Model):
    """
    Represents a badge that a user can earn by completing a course.
    """
    name = models.CharField(max_length=255)
    description = models.TextField()
    image = models.ImageField(upload_to='badges/')

    def __str__(self):
        return self.name