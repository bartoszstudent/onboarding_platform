import { useState } from 'react';
import { Login } from './components/auth/Login';
import { MainLayout } from './components/layout/MainLayout';
import { Dashboard } from './components/pages/Dashboard';
import { CoursesList } from './components/pages/CoursesList';
import { CreateCourse } from './components/pages/CreateCourse';
import { CoursePlayer } from './components/pages/CoursePlayer';
import { CompanyManagement } from './components/pages/CompanyManagement';
import { UserManagement } from './components/pages/UserManagement';
import { Settings } from './components/pages/Settings';

export type UserRole = 'super-admin' | 'admin' | 'hr' | 'employee';

export interface User {
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
}

export type Page = 'dashboard' | 'courses' | 'create-course' | 'course-player' | 'users' | 'companies' | 'settings';

export default function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [currentPage, setCurrentPage] = useState<Page>('dashboard');
  const [selectedCourseId, setSelectedCourseId] = useState<string | null>(null);

  const handleLogin = (email: string, role: UserRole) => {
    const name = email.split('@')[0];
    setCurrentUser({
      name,
      email,
      role,
      avatar: undefined
    });
    setIsLoggedIn(true);
    setCurrentPage('dashboard');
  };

  const handleLogout = () => {
    setIsLoggedIn(false);
    setCurrentUser(null);
    setCurrentPage('dashboard');
  };

  const handleNavigate = (page: Page) => {
    setCurrentPage(page);
    if (page !== 'course-player') {
      setSelectedCourseId(null);
    }
  };

  const handlePlayCourse = (courseId: string) => {
    setSelectedCourseId(courseId);
    setCurrentPage('course-player');
  };

  if (!isLoggedIn || !currentUser) {
    return <Login onLogin={handleLogin} />;
  }

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard user={currentUser} />;
      case 'courses':
        return <CoursesList user={currentUser} onPlayCourse={handlePlayCourse} onCreateCourse={() => handleNavigate('create-course')} />;
      case 'create-course':
        return <CreateCourse onBack={() => handleNavigate('courses')} />;
      case 'course-player':
        return <CoursePlayer courseId={selectedCourseId} onBack={() => handleNavigate('courses')} />;
      case 'users':
        return <UserManagement user={currentUser} />;
      case 'companies':
        return <CompanyManagement />;
      case 'settings':
        return <Settings user={currentUser} />;
      default:
        return <Dashboard user={currentUser} />;
    }
  };

  return (
    <MainLayout
      user={currentUser}
      currentPage={currentPage}
      onNavigate={handleNavigate}
      onLogout={handleLogout}
    >
      {renderPage()}
    </MainLayout>
  );
}
