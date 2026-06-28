# Generated manually on 2026-05-25
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("core", "0003_sectionprogress_remove_badge_workspace_badge_course_and_more"),
    ]

    operations = [
        # 1) Add missing column core_course.completion_badge_id
        migrations.AddField(
            model_name="course",
            name="completion_badge",
            field=models.ForeignKey(
                to="core.badge",
                on_delete=django.db.models.deletion.SET_NULL,
                null=True,
                blank=True,
                related_name="courses_with_completion_badge",
            ),
        ),

        # 2) Create missing core_sectionprogress table
        migrations.CreateModel(
            name="SectionProgress",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("completed", models.BooleanField(default=False)),
                ("assignment", models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to="core.courseassignment")),
                ("section", models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to="core.section")),
            ],
            options={
                "unique_together": {("assignment", "section")},
            },
        ),
    ]