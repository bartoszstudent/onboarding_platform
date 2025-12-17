from django.db import models
from .question import Question

class Answer(models.Model):
    question = models.ForeignKey(Question, related_name='answers', on_delete=models.CASCADE)
    answer_text = models.CharField(max_length=255)
    
    # This boolean tells us if this is the correct answer for the question
    is_correct = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.answer_text} (for: {self.question.question_text[:30]}...)"