from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0002_add_badge_fields'),
    ]

    operations = [
        migrations.AddField(
            model_name='course',
            name='description',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='course',
            name='thumbnail',
            field=models.URLField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='course',
            name='duration',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]
