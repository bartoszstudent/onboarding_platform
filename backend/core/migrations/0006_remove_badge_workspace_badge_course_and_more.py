# backend/core/migrations/0006_add_timestamps_and_image_alt.py

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0005_merge_20260606_1759'),
    ]

    operations = [
        # Dodaj timestampy do Section
        migrations.AddField(
            model_name='section',
            name='created_at',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
        migrations.AddField(
            model_name='section',
            name='updated_at',
            field=models.DateTimeField(auto_now=True),
        ),
        
        # Dodaj timestampy i image_alt do Block
        migrations.AddField(
            model_name='block',
            name='image_alt',
            field=models.CharField(blank=True, max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='block',
            name='created_at',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
        migrations.AddField(
            model_name='block',
            name='updated_at',
            field=models.DateTimeField(auto_now=True),
        ),
        
        # Meta ordering
        migrations.AlterModelOptions(
            name='section',
            options={'ordering': ['order']},
        ),
        migrations.AlterModelOptions(
            name='block',
            options={'ordering': ['order']},
        ),
    ]