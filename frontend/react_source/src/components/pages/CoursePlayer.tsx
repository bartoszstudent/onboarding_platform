import { useState } from 'react';
import { ArrowLeft, ChevronRight, CheckCircle } from 'lucide-react';
import { QuizBlock } from '../ui/QuizBlock';

interface CoursePlayerProps {
  courseId: string | null;
  onBack: () => void;
}

const mockCourse = {
  id: '1',
  title: 'Wprowadzenie do React',
  sections: [
    {
      id: '1',
      title: 'Podstawy React',
      completed: true,
      content: [
        { type: 'text', content: 'React to biblioteka JavaScript do tworzenia interfejsów użytkownika. Pozwala na budowanie interaktywnych aplikacji webowych w prosty i efektywny sposób.' },
        { type: 'image', content: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800&h=400&fit=crop' },
      ]
    },
    {
      id: '2',
      title: 'Komponenty i Props',
      completed: false,
      content: [
        { type: 'text', content: 'Komponenty są podstawowymi elementami budowania aplikacji React. Możesz je tworzyć jako funkcje lub klasy.' },
        { type: 'text', content: 'Props (properties) to sposób przekazywania danych między komponentami. Działają podobnie jak argumenty funkcji.' },
      ]
    },
    {
      id: '3',
      title: 'Quiz - Sprawdź swoją wiedzę',
      completed: false,
      content: [
        { 
          type: 'quiz', 
          question: 'Co to jest React?',
          answers: [
            'Framework do tworzenia aplikacji webowych',
            'Biblioteka JavaScript do budowania UI',
            'Język programowania',
            'Baza danych'
          ],
          correctAnswer: 1
        },
      ]
    },
    {
      id: '4',
      title: 'State i Lifecycle',
      completed: false,
      content: [
        { type: 'text', content: 'State to wewnętrzny stan komponentu, który może się zmieniać w czasie. Używamy hooka useState do zarządzania stanem.' },
        { type: 'video', content: 'https://www.youtube.com/embed/example' },
      ]
    },
  ]
};

export function CoursePlayer({ courseId, onBack }: CoursePlayerProps) {
  const [currentSectionIndex, setCurrentSectionIndex] = useState(0);
  const currentSection = mockCourse.sections[currentSectionIndex];

  const goToNextSection = () => {
    if (currentSectionIndex < mockCourse.sections.length - 1) {
      setCurrentSectionIndex(currentSectionIndex + 1);
    }
  };

  const goToPreviousSection = () => {
    if (currentSectionIndex > 0) {
      setCurrentSectionIndex(currentSectionIndex - 1);
    }
  };

  return (
    <div className="flex gap-6 h-[calc(100vh-200px)]">
      {/* Section list */}
      <div className="w-80 bg-white rounded-2xl border border-gray-200 p-6 overflow-y-auto">
        <button
          onClick={onBack}
          className="flex items-center gap-2 text-[#475569] hover:text-[#0F172A] mb-6 transition-colors"
        >
          <ArrowLeft className="w-4 h-4" />
          Powrót do listy
        </button>

        <h3 className="text-[#0F172A] mb-4">{mockCourse.title}</h3>

        <div className="space-y-2">
          {mockCourse.sections.map((section, index) => (
            <button
              key={section.id}
              onClick={() => setCurrentSectionIndex(index)}
              className={`w-full text-left p-4 rounded-xl transition-colors ${
                index === currentSectionIndex
                  ? 'bg-[#2563EB] text-white'
                  : 'bg-[#F8FAFC] text-[#0F172A] hover:bg-[#F1F5F9]'
              }`}
            >
              <div className="flex items-start gap-3">
                <div className={`w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 ${
                  section.completed
                    ? 'bg-green-500'
                    : index === currentSectionIndex
                    ? 'bg-white/20'
                    : 'bg-gray-300'
                }`}>
                  {section.completed ? (
                    <CheckCircle className="w-4 h-4 text-white" />
                  ) : (
                    <span className={`text-xs ${index === currentSectionIndex ? 'text-white' : 'text-gray-600'}`}>
                      {index + 1}
                    </span>
                  )}
                </div>
                <span className="text-sm">{section.title}</span>
              </div>
            </button>
          ))}
        </div>

        {/* Progress */}
        <div className="mt-6 pt-6 border-t border-gray-200">
          <p className="text-sm text-[#475569] mb-2">Postęp kursu</p>
          <div className="w-full bg-[#F1F5F9] rounded-full h-2 mb-2">
            <div
              className="bg-[#2563EB] h-2 rounded-full transition-all"
              style={{ width: `${(mockCourse.sections.filter(s => s.completed).length / mockCourse.sections.length) * 100}%` }}
            />
          </div>
          <p className="text-xs text-[#475569]">
            {mockCourse.sections.filter(s => s.completed).length} z {mockCourse.sections.length} sekcji ukończono
          </p>
        </div>
      </div>

      {/* Content area */}
      <div className="flex-1 bg-white rounded-2xl border border-gray-200 p-8 overflow-y-auto">
        <h2 className="text-[#0F172A] mb-6">{currentSection.title}</h2>

        <div className="space-y-6 mb-8">
          {currentSection.content.map((block, index) => {
            if (block.type === 'text') {
              return (
                <p key={index} className="text-[#475569] leading-relaxed">
                  {block.content}
                </p>
              );
            }
            if (block.type === 'image') {
              return (
                <img
                  key={index}
                  src={block.content}
                  alt="Course content"
                  className="w-full rounded-xl"
                />
              );
            }
            if (block.type === 'video') {
              return (
                <div key={index} className="aspect-video bg-gray-200 rounded-xl flex items-center justify-center">
                  <p className="text-[#475569]">Video player placeholder</p>
                </div>
              );
            }
            if (block.type === 'quiz') {
              return (
                <QuizBlock
                  key={index}
                  question={block.question}
                  answers={block.answers}
                  correctAnswer={block.correctAnswer}
                />
              );
            }
            return null;
          })}
        </div>

        {/* Navigation */}
        <div className="flex items-center justify-between pt-6 border-t border-gray-200">
          <button
            onClick={goToPreviousSection}
            disabled={currentSectionIndex === 0}
            className="px-6 py-3 bg-[#F8FAFC] text-[#475569] rounded-xl hover:bg-[#F1F5F9] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Poprzednia sekcja
          </button>
          <button
            onClick={goToNextSection}
            disabled={currentSectionIndex === mockCourse.sections.length - 1}
            className="flex items-center gap-2 px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Następna sekcja
            <ChevronRight className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
}
