import { Plus, Play, BarChart3 } from 'lucide-react';
import { User } from '../../App';

interface CoursesListProps {
  user: User;
  onPlayCourse: (courseId: string) => void;
  onCreateCourse: () => void;
}

const mockCourses = [
  {
    id: '1',
    title: 'Wprowadzenie do React',
    description: 'Poznaj podstawy biblioteki React i twórz interaktywne aplikacje webowe.',
    thumbnail: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=225&fit=crop',
    progress: 75,
    duration: '4h 30min',
  },
  {
    id: '2',
    title: 'TypeScript Podstawy',
    description: 'Naucz się programowania w TypeScript od podstaw.',
    thumbnail: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400&h=225&fit=crop',
    progress: 45,
    duration: '3h 15min',
  },
  {
    id: '3',
    title: 'Git i GitHub',
    description: 'Opanuj kontrolę wersji i współpracę w zespole.',
    thumbnail: 'https://images.unsplash.com/photo-1556075798-4825dfaaf498?w=400&h=225&fit=crop',
    progress: 100,
    duration: '2h 45min',
  },
  {
    id: '4',
    title: 'CSS Advanced',
    description: 'Zaawansowane techniki stylowania i animacji CSS.',
    thumbnail: 'https://images.unsplash.com/photo-1507721999472-8ed4421c4af2?w=400&h=225&fit=crop',
    progress: 20,
    duration: '5h 00min',
  },
  {
    id: '5',
    title: 'Node.js Backend',
    description: 'Twórz skalowalne aplikacje serwerowe z Node.js.',
    thumbnail: 'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=400&h=225&fit=crop',
    progress: 0,
    duration: '6h 20min',
  },
  {
    id: '6',
    title: 'UI/UX Design Principles',
    description: 'Podstawy projektowania interfejsów użytkownika.',
    thumbnail: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400&h=225&fit=crop',
    progress: 30,
    duration: '4h 00min',
  },
];

export function CoursesList({ user, onPlayCourse, onCreateCourse }: CoursesListProps) {
  const canCreateCourse = ['super-admin', 'admin', 'hr'].includes(user.role);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-[#0F172A] mb-2">Wszystkie kursy</h2>
          <p className="text-[#475569]">Przeglądaj i zarządzaj kursami onboardingowymi</p>
        </div>
        {canCreateCourse && (
          <button
            onClick={onCreateCourse}
            className="flex items-center gap-2 px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors"
          >
            <Plus className="w-5 h-5" />
            Dodaj kurs
          </button>
        )}
      </div>

      {/* Courses grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {mockCourses.map((course) => (
          <div
            key={course.id}
            className="bg-white rounded-2xl border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow"
          >
            {/* Thumbnail */}
            <div className="relative h-48 bg-gray-200 overflow-hidden">
              <img 
                src={course.thumbnail} 
                alt={course.title}
                className="w-full h-full object-cover"
              />
              {course.progress > 0 && (
                <div className="absolute top-3 right-3 px-3 py-1 bg-white/90 backdrop-blur-sm rounded-lg text-xs text-[#0F172A]">
                  {course.progress}% ukończono
                </div>
              )}
            </div>

            {/* Content */}
            <div className="p-6">
              <h3 className="text-[#0F172A] mb-2">{course.title}</h3>
              <p className="text-sm text-[#475569] mb-4 line-clamp-2">{course.description}</p>

              {/* Progress bar (for employees) */}
              {user.role === 'employee' && (
                <div className="mb-4">
                  <div className="w-full bg-[#F1F5F9] rounded-full h-2">
                    <div
                      className="bg-[#2563EB] h-2 rounded-full transition-all"
                      style={{ width: `${course.progress}%` }}
                    />
                  </div>
                </div>
              )}

              {/* Footer */}
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1 text-sm text-[#475569]">
                  <BarChart3 className="w-4 h-4" />
                  {course.duration}
                </div>
                <button
                  onClick={() => onPlayCourse(course.id)}
                  className="flex items-center gap-2 px-4 py-2 bg-[#F8FAFC] hover:bg-[#F1F5F9] text-[#2563EB] rounded-xl transition-colors"
                >
                  <Play className="w-4 h-4" />
                  {course.progress > 0 && course.progress < 100 ? 'Kontynuuj' : course.progress === 100 ? 'Przejrzyj' : 'Rozpocznij'}
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
