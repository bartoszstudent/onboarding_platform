# --- Workspaces & Companies ---
from .workspaces import Company, Workspace, Invitation, UserCompany

# --- Training & Courses ---
from .training import *
from .section import Section
from .block import Block
from .quiz import Quiz
from .question import Question  # ADD THIS LINE
from .answer import Answer      # ADD THIS LINE

# --- Onboarding ---
from .onboarding import *

# --- Competencies ---
from .competencies import *

# --- Gamification ---
from .gamification import *

# --- Reporting ---
from .reporting import *

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
