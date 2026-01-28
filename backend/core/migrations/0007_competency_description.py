# Generated manually

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0006_question_answer'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='competency',
            options={'verbose_name_plural': 'Competencies'},
        ),
        migrations.AddField(
            model_name='competency',
            name='description',
            field=models.TextField(blank=True, default=''),
        ),
    ]
