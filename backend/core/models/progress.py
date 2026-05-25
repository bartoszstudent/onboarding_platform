from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from backend.core.models.training import Course, CourseAssignment
from backend.core.models.section import Section
from django.shortcuts import get_object_or_404
from django.db import models

# Define the SectionProgress model if it doesn't exist yet
class SectionProgress(models.Model):
    assignment = models.ForeignKey(CourseAssignment, on_delete=models.CASCADE)
    section = models.ForeignKey(Section, on_delete=models.CASCADE)
    completed = models.BooleanField(default=False)

    class Meta:
        unique_together = ('assignment', 'section')

class SectionProgressView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        """
        Expects JSON: {
          "course_id": int,
          "section_id": int,
          "completed": bool
        }
        """
        data = request.data
        user = request.user

        course = get_object_or_404(Course, pk=data["course_id"])
        section = get_object_or_404(Section, pk=data["section_id"])
        assignment = get_object_or_404(CourseAssignment, user=user, course=course)

        sp, created = SectionProgress.objects.get_or_create(
            assignment=assignment, section=section,
            defaults={'completed': data.get("completed", False)}
        )
        if not created:
            sp.completed = data.get("completed", False)
            sp.save()

        # Recalculate progress
        all_sections = Section.objects.filter(course=course).count()
        completed_sections = SectionProgress.objects.filter(assignment=assignment, completed=True).count()
        progress = int((completed_sections / all_sections) * 100) if all_sections else 0

        # Optionally: Put progress on assignment or handle other status logic
        assignment.status = f"{progress}% complete"
        assignment.save()

        return Response({
            "course_id": course.id,
            "section_id": section.id,
            "completed": sp.completed,
            "progress": progress,
            "status": assignment.status,
            "total_sections": all_sections,
            "completed_sections": completed_sections,
        }, status=status.HTTP_200_OK)