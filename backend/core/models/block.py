from django.db import models
from .section import Section
from .quiz import Quiz

class Block(models.Model):
    class BlockType(models.TextChoices):
        TEXT = 'TEXT', 'Text'
        IMAGE = 'IMAGE', 'Image'
        VIDEO = 'VIDEO', 'Video'
        QUIZ = 'QUIZ', 'Quiz'

    section = models.ForeignKey(Section, related_name='blocks', on_delete=models.CASCADE)
    order = models.PositiveIntegerField(help_text="Order within the section (1, 2, 3...)")
    block_type = models.CharField(max_length=10, choices=BlockType.choices)

    text_content = models.TextField(blank=True, null=True)
    image_url = models.URLField(blank=True, null=True)
    image_alt = models.CharField(max_length=255, blank=True, null=True)  # ← Dodaj
    video_url = models.URLField(blank=True, null=True)
    quiz = models.ForeignKey(Quiz, blank=True, null=True, on_delete=models.SET_NULL)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['order']  # ← WAŻNE: Zawsze zwracaj bloki w kolejności

    def __str__(self):
        return f"Block {self.order} ({self.get_block_type_display()}) in Section '{self.section.title}'"