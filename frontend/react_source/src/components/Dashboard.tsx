import { useState } from 'react';
import { 
  LogOut, 
  CheckCircle2, 
  Circle, 
  User, 
  Settings, 
  Book, 
  Video, 
  Users,
  BarChart3
} from 'lucide-react';

interface DashboardProps {
  userName: string;
  onLogout: () => void;
}

interface OnboardingStep {
  id: number;
  title: string;
  description: string;
  completed: boolean;
  icon: React.ReactNode;
}

export function Dashboard({ userName, onLogout }: DashboardProps) {
  const [steps, setSteps] = useState<OnboardingStep[]>([
    {
      id: 1,
      title: 'Uzupełnij profil',
      description: 'Dodaj zdjęcie i podstawowe informacje',
      completed: false,
      icon: <User className="w-5 h-5" />
    },
    {
      id: 2,
      title: 'Obejrzyj tutorial',
      description: 'Poznaj podstawowe funkcje platformy',
      completed: false,
      icon: <Video className="w-5 h-5" />
    },
    {
      id: 3,
      title: 'Przeczytaj dokumentację',
      description: 'Zapoznaj się z przewodnikiem użytkownika',
      completed: false,
      icon: <Book className="w-5 h-5" />
    },
    {
      id: 4,
      title: 'Zaproś członków zespołu',
      description: 'Dodaj współpracowników do projektu',
      completed: false,
      icon: <Users className="w-5 h-5" />
    }
  ]);

  const toggleStep = (id: number) => {
    setSteps(steps.map(step => 
      step.id === id ? { ...step, completed: !step.completed } : step
    ));
  };

  const completedCount = steps.filter(step => step.completed).length;
  const progress = (completedCount / steps.length) * 100;

  return (
    <div className="min-h-screen p-6 bg-gray-50">
      {/* Header */}
      <header className="bg-white rounded-2xl shadow-sm p-4 mb-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-slate-900 rounded-xl flex items-center justify-center">
              <User className="w-6 h-6 text-white" />
            </div>
            <div>
              <h2 className="text-gray-900 capitalize">{userName}</h2>
              <p className="text-gray-600">Twój panel onboardingowy</p>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <button className="p-2 hover:bg-gray-100 rounded-xl transition-colors">
              <Settings className="w-5 h-5 text-gray-600" />
            </button>
            <button
              onClick={onLogout}
              className="flex items-center gap-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-xl transition-colors"
            >
              <LogOut className="w-5 h-5 text-gray-600" />
              <span className="text-gray-700">Wyloguj</span>
            </button>
          </div>
        </div>
      </header>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Content */}
        <div className="lg:col-span-2 space-y-6">
          {/* Welcome Card */}
          <div className="bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 rounded-2xl p-8 text-white shadow-lg">
            <h1 className="mb-2">Witaj, {userName}! 👋</h1>
            <p className="text-slate-300 mb-6">
              Cieszymy się, że jesteś z nami. Rozpocznij swoje onboardingowe kroki, aby w pełni wykorzystać platformę.
            </p>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/10">
              <div className="flex items-center justify-between mb-2">
                <span>Postęp onboardingu</span>
                <span>{completedCount}/{steps.length}</span>
              </div>
              <div className="w-full bg-white/20 rounded-full h-2.5">
                <div 
                  className="bg-emerald-400 h-2.5 rounded-full transition-all duration-500"
                  style={{ width: `${progress}%` }}
                />
              </div>
            </div>
          </div>

          {/* Onboarding Steps */}
          <div className="bg-white rounded-2xl shadow-sm p-6">
            <h3 className="text-gray-900 mb-4">Kroki onboardingowe</h3>
            <div className="space-y-3">
              {steps.map((step) => (
                <div
                  key={step.id}
                  onClick={() => toggleStep(step.id)}
                  className={`flex items-start gap-4 p-4 rounded-xl border-2 cursor-pointer transition-all ${
                    step.completed
                      ? 'bg-emerald-50 border-emerald-200 hover:border-emerald-300'
                      : 'bg-gray-50 border-gray-200 hover:border-slate-300 hover:bg-gray-100'
                  }`}
                >
                  <div className={`flex-shrink-0 ${step.completed ? 'text-emerald-600' : 'text-gray-400'}`}>
                    {step.completed ? (
                      <CheckCircle2 className="w-6 h-6" />
                    ) : (
                      <Circle className="w-6 h-6" />
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <div className={step.completed ? 'text-emerald-600' : 'text-slate-700'}>
                        {step.icon}
                      </div>
                      <h4 className={`text-gray-900 ${step.completed ? 'line-through' : ''}`}>
                        {step.title}
                      </h4>
                    </div>
                    <p className="text-gray-600">{step.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Quick Stats */}
          <div className="bg-white rounded-2xl shadow-sm p-6">
            <h3 className="text-gray-900 mb-4">Szybkie statystyki</h3>
            <div className="space-y-4">
              <div className="flex items-center justify-between p-4 bg-emerald-50 rounded-xl border border-emerald-100">
                <div>
                  <p className="text-gray-600">Ukończone kroki</p>
                  <p className="text-emerald-700">{completedCount}</p>
                </div>
                <div className="bg-emerald-100 p-2 rounded-lg">
                  <BarChart3 className="w-6 h-6 text-emerald-700" />
                </div>
              </div>
              <div className="flex items-center justify-between p-4 bg-slate-50 rounded-xl border border-slate-100">
                <div>
                  <p className="text-gray-600">Pozostało</p>
                  <p className="text-slate-700">{steps.length - completedCount}</p>
                </div>
                <div className="bg-slate-100 p-2 rounded-lg">
                  <Circle className="w-6 h-6 text-slate-700" />
                </div>
              </div>
            </div>
          </div>

          {/* Tips Card */}
          <div className="bg-gradient-to-br from-amber-50 to-amber-100 rounded-2xl p-6 border border-amber-200">
            <h3 className="text-gray-900 mb-2">💡 Wskazówka</h3>
            <p className="text-gray-700">
              Kliknij na dowolny krok onboardingowy, aby oznaczyć go jako ukończony. Śledź swój postęp i odkryj wszystkie funkcje platformy!
            </p>
          </div>

          {/* Support Card */}
          <div className="bg-white rounded-2xl shadow-sm p-6">
            <h3 className="text-gray-900 mb-2">Potrzebujesz pomocy?</h3>
            <p className="text-gray-600 mb-4">
              Nasz zespół wsparcia jest zawsze gotowy do pomocy.
            </p>
            <button className="w-full bg-slate-900 text-white py-3 rounded-xl hover:bg-slate-800 transition-colors">
              Skontaktuj się z nami
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}