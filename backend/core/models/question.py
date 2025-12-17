from django.db import models
from .quiz import Quiz

class Question(models.Model):
    class QuestionType(models.TextChoices):
        MULTIPLE_CHOICE = 'MC', 'Multiple Choice'  
        TRUE_FALSE = 'TF', 'True/False'

    quiz = models.ForeignKey(Quiz, related_name='questions', on_delete=models.CASCADE)
    question_text = models.CharField(max_length=500)
    question_type = models.CharField(max_length=2, choices=QuestionType.choices)
    
    image_url = models.URLField(blank=True, null=True, help_text="Optional URL for an image relevant to the question")
    
    order = models.PositiveIntegerField(help_text="The order of the question in the quiz")

    class Meta:
        ordering = ['order']

    def __str__(self):
        return self.question_text