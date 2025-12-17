from django.test import TestCase

# Create your tests here.
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from .models.workspaces import Company, Workspace
from .models.training import Course

User = get_user_model()

class CourseAPITests(APITestCase):
    def setUp(self):
        # Create a test user
        self.user = User.objects.create_user(username='testuser', password='testpassword')
        self.client.force_authenticate(user=self.user)
        
        # Create other necessary objects for context
        self.company = Company.objects.create(name="Test Company", domain="test.com")
        self.workspace = Workspace.objects.create(company=self.company, name="Test Workspace")
        
        # Create a course for testing
        self.course = Course.objects.create(workspace=self.workspace, title="Test Course")
        self.url = reverse('course-list') # Assumes router is registered with basename 'course'

    def test_list_courses(self):
        """
        Ensure we can list courses.
        """
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['title'], self.course.title)

    def test_create_course(self):
        """
        Ensure we can create a new course.
        """
        data = {'workspace': self.workspace.id, 'title': 'Another Course'}
        response = self.client.post(self.url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Course.objects.count(), 2)
        self.assertEqual(Course.objects.latest('id').title, 'Another Course')
