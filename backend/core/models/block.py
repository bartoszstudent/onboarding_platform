from django.db import models
from .section import Section
from .quiz import Quiz

# This is the central model for your course structure.
class Block(models.Model):
    class BlockType(models.TextChoices):
        TEXT = 'TEXT', 'Text'
        IMAGE = 'IMAGE', 'Image'
        VIDEO = 'VIDEO', 'Video'
        QUIZ = 'QUIZ', 'Quiz'

    # Every block belongs to a section
    section = models.ForeignKey(Section, related_name='blocks', on_delete=models.CASCADE)
    order = models.PositiveIntegerField(help_text="Order within the section (1, 2, 3...)")
    
    # This field tells us what kind of block this is
    block_type = models.CharField(max_length=10, choices=BlockType.choices)

    # --- Fields for content ---
    # Only one of these will be filled, depending on the block_type.
    
    # For TEXT blocks
    text_content = models.TextField(blank=True, null=True)

    # For IMAGE blocks
    image_url = models.URLField(blank=True, null=True)

    # For VIDEO blocks
    video_url = models.URLField(blank=True, null=True)

    # For QUIZ blocks, we link to the actual Quiz model
    # This allows a quiz to have its own questions and answers in the future
    quiz = models.ForeignKey(Quiz, blank=True, null=True, on_delete=models.SET_NULL)

    def __str__(self):
        return f"Block {self.order} ({self.get_block_type_display()}) in Section '{self.section.title}'"