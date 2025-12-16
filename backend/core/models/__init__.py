# --- Workspaces & Companies ---
from .workspaces import Company, Workspace, Invitation

# --- Training & Courses ---
from .training import Course, CourseAssignment
from .section import Section
from .block import Block
from .quiz import Quiz
from .question import Question  # ADD THIS LINE
from .answer import Answer      # ADD THIS LINE

# --- Onboarding ---
from .onboarding import OnboardingTemplate, OnboardingTaskTemplate, Onboarding, OnboardingTaskInstance

# --- Competencies ---
from .competencies import Competency, CompetencyCourse, UserCompetency

# --- Gamification ---
from .gamification import Badge, UserBadge, MentorRating

# --- Reporting ---
from .reporting import Notification

# This __all__ list acts as the public API for your models package.
# Every model must be listed here to be visible.
__all__ = [
    'Company',
    'Workspace',
    'Invitation',
    'Course',
    'CourseAssignment',
    'Section',
    'Block',
    'Quiz',
    'Question',
    'Answer',
    'OnboardingTemplate',
    'OnboardingTaskTemplate',
    'Onboarding',
    'OnboardingTaskInstance',
    'Competency',
    'CompetencyCourse',
    'UserCompetency',
    'Badge',
    'UserBadge',
    'MentorRating',
    'Notification',
]