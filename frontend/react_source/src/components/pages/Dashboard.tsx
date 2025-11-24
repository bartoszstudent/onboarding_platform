import { BookOpen, Users, Clock, TrendingUp, CheckCircle, Play, Target } from 'lucide-react';
import { User } from '../../App';
import { StatCard } from '../ui/StatCard';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

interface DashboardProps {
  user: User;
}

// Super Admin Dashboard - Global stats
function SuperAdminDashboard({ user }: DashboardProps) {
  const globalStats = [
    { name: 'Pn', companies: 12, users: 450 },
    { name: 'Wt', companies: 13, users: 478 },
    { name: 'Śr', companies: 15, users: 521 },
    { name: 'Cz', companies: 15, users: 534 },
    { name: 'Pt', companies: 17, users: 589 },
    { name: 'Sb', companies: 17, users: 592 },
    { name: 'Nd', companies: 17, users: 598 },
  ];

  const topCompanies = [
    { name: 'TechCorp Sp. z o.o.', employees: 156, courses: 24, activity: 'Wysoka' },
    { name: 'Digital Solutions', employees: 78, courses: 18, activity: 'Średnia' },
    { name: 'StartupHub', employees: 45, courses: 12, activity: 'Wysoka' },
    { name: 'Enterprise Inc.', employees: 234, courses: 32, activity: 'Niska' },
  ];

  return (
    <div className="space-y-8">
      {/* Welcome banner */}
      <div className="bg-gradient-to-r from-purple-600 to-purple-700 rounded-2xl p-8 text-white">
        <h1 className="mb-2">Panel Super Admina 🚀</h1>
        <p className="text-purple-100">
          Zarządzaj wszystkimi firmami w platformie Onboardly
        </p>
      </div>

      {/* Global Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard
          icon={<Users className="w-6 h-6" />}
          label="Wszystkie firmy"
          value="17"
          trend="+2 w tym miesiącu"
          color="purple"
        />
        <StatCard
          icon={<Users className="w-6 h-6" />}
          label="Wszyscy użytkownicy"
          value="598"
          trend="+43 w tym tygodniu"
          color="blue"
        />
        <StatCard
          icon={<BookOpen className="w-6 h-6" />}
          label="Wszystkie kursy"
          value="156"
          trend="+8 w tym miesiącu"
          color="green"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Growth chart */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 border border-gray-200">
          <div className="flex items-center gap-2 mb-6">
            <TrendingUp className="w-5 h-5 text-[#2563EB]" />
            <h3 className="text-[#0F172A]">Wzrost użytkowników platformy</h3>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={globalStats}>
              <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
              <XAxis dataKey="name" stroke="#475569" />
              <YAxis stroke="#475569" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: 'white', 
                  border: '1px solid #E2E8F0',
                  borderRadius: '12px'
                }}
              />
              <Bar dataKey="users" fill="#2563EB" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Quick actions */}
        <div className="bg-white rounded-2xl p-6 border border-gray-200">
          <h3 className="text-[#0F172A] mb-4">Szybkie akcje</h3>
          <div className="space-y-3">
            <button className="w-full text-left px-4 py-3 bg-purple-50 hover:bg-purple-100 text-purple-700 rounded-xl transition-colors">
              <p className="text-sm">Dodaj nową firmę</p>
            </button>
            <button className="w-full text-left px-4 py-3 bg-[#F8FAFC] hover:bg-[#F1F5F9] rounded-xl transition-colors">
              <p className="text-sm text-[#0F172A]">Generuj raport globalny</p>
            </button>
            <button className="w-full text-left px-4 py-3 bg-[#F8FAFC] hover:bg-[#F1F5F9] rounded-xl transition-colors">
              <p className="text-sm text-[#0F172A]">Ustawienia platformy</p>
            </button>
          </div>
        </div>
      </div>

      {/* Top companies table */}
      <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
        <div className="p-6 border-b border-gray-200">
          <h3 className="text-[#0F172A]">Top firmy - aktywność</h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-[#F8FAFC]">
              <tr>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Firma</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Pracownicy</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Kursy</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Aktywność</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Akcje</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {topCompanies.map((company, index) => (
                <tr key={index} className="hover:bg-[#F8FAFC] transition-colors">
                  <td className="px-6 py-4 text-sm text-[#0F172A]">{company.name}</td>
                  <td className="px-6 py-4 text-sm text-[#475569]">{company.employees}</td>
                  <td className="px-6 py-4 text-sm text-[#475569]">{company.courses}</td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex px-3 py-1 rounded-lg text-xs ${
                      company.activity === 'Wysoka'
                        ? 'bg-green-50 text-green-700'
                        : company.activity === 'Średnia'
                        ? 'bg-yellow-50 text-yellow-700'
                        : 'bg-red-50 text-red-700'
                    }`}>
                      {company.activity}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <button className="px-4 py-2 bg-[#F8FAFC] text-[#2563EB] rounded-lg hover:bg-[#F1F5F9] transition-colors text-sm">
                      Zarządzaj
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// Admin/HR Dashboard - Company stats
function AdminDashboard({ user }: DashboardProps) {
  const recentActivities = [
    { id: 1, user: 'Jan Kowalski', action: 'Ukończył kurs', course: 'Wprowadzenie do React', time: '2 godz. temu' },
    { id: 2, user: 'Anna Nowak', action: 'Rozpoczął kurs', course: 'TypeScript Podstawy', time: '5 godz. temu' },
    { id: 3, user: 'Piotr Wiśniewski', action: 'Ukończył kurs', course: 'Git i GitHub', time: '1 dzień temu' },
    { id: 4, user: 'Maria Lewandowska', action: 'Rozpoczął kurs', course: 'CSS Advanced', time: '2 dni temu' },
  ];

  const progressData = [
    { name: 'Pn', value: 45 },
    { name: 'Wt', value: 52 },
    { name: 'Śr', value: 61 },
    { name: 'Cz', value: 58 },
    { name: 'Pt', value: 70 },
    { name: 'Sb', value: 40 },
    { name: 'Nd', value: 35 },
  ];

  return (
    <div className="space-y-8">
      {/* Welcome banner */}
      <div className="bg-gradient-to-r from-[#2563EB] to-[#3B82F6] rounded-2xl p-8 text-white">
        <h1 className="mb-2">Witaj, {user.name}! 👋</h1>
        <p className="text-blue-100">
          Panel zarządzania firmą - przegląd aktywności i statystyk
        </p>
        <div className="mt-4 inline-flex items-center gap-2 px-4 py-2 bg-white/20 backdrop-blur-sm rounded-xl">
          <span className="text-sm">TechCorp Sp. z o.o.</span>
        </div>
      </div>

      {/* Stats cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard
          icon={<BookOpen className="w-6 h-6" />}
          label="Liczba kursów"
          value="24"
          trend="+3 w tym miesiącu"
          color="blue"
        />
        <StatCard
          icon={<Users className="w-6 h-6" />}
          label="Liczba pracowników"
          value="156"
          trend="+12 w tym miesiącu"
          color="green"
        />
        <StatCard
          icon={<Clock className="w-6 h-6" />}
          label="Średni czas ukończenia"
          value="4.5h"
          trend="-0.5h vs poprzedni"
          color="purple"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Progress chart */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 border border-gray-200">
          <div className="flex items-center gap-2 mb-6">
            <TrendingUp className="w-5 h-5 text-[#2563EB]" />
            <h3 className="text-[#0F172A]">Postęp pracowników w tym tygodniu</h3>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={progressData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#F1F5F9" />
              <XAxis dataKey="name" stroke="#475569" />
              <YAxis stroke="#475569" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: 'white', 
                  border: '1px solid #E2E8F0',
                  borderRadius: '12px'
                }}
              />
              <Bar dataKey="value" fill="#2563EB" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Quick actions */}
        <div className="bg-white rounded-2xl p-6 border border-gray-200">
          <h3 className="text-[#0F172A] mb-4">Szybkie akcje</h3>
          <div className="space-y-3">
            <button className="w-full text-left px-4 py-3 bg-[#F8FAFC] hover:bg-[#F1F5F9] rounded-xl transition-colors">
              <p className="text-sm text-[#0F172A]">Dodaj nowy kurs</p>
            </button>
            <button className="w-full text-left px-4 py-3 bg-[#F8FAFC] hover:bg-[#F1F5F9] rounded-xl transition-colors">
              <p className="text-sm text-[#0F172A]">Zapros pracownika</p>
            </button>
            <button className="w-full text-left px-4 py-3 bg-[#F8FAFC] hover:bg-[#F1F5F9] rounded-xl transition-colors">
              <p className="text-sm text-[#0F172A]">Generuj raport</p>
            </button>
          </div>
        </div>
      </div>

      {/* Recent activities table */}
      <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
        <div className="p-6 border-b border-gray-200">
          <h3 className="text-[#0F172A]">Ostatnie aktywności</h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-[#F8FAFC]">
              <tr>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Użytkownik</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Akcja</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Kurs</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Czas</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {recentActivities.map((activity) => (
                <tr key={activity.id} className="hover:bg-[#F8FAFC] transition-colors">
                  <td className="px-6 py-4 text-sm text-[#0F172A]">{activity.user}</td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center gap-1 px-3 py-1 rounded-lg text-xs ${
                      activity.action.includes('Ukończył')
                        ? 'bg-green-50 text-green-700'
                        : 'bg-blue-50 text-blue-700'
                    }`}>
                      {activity.action.includes('Ukończył') && <CheckCircle className="w-3 h-3" />}
                      {activity.action}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm text-[#475569]">{activity.course}</td>
                  <td className="px-6 py-4 text-sm text-[#475569]">{activity.time}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// Employee Dashboard - Personal progress
function EmployeeDashboard({ user }: DashboardProps) {
  const myCourses = [
    { id: '1', title: 'Wprowadzenie do React', progress: 75, nextLesson: 'Hooks - useState', dueDate: 'Za 2 dni' },
    { id: '2', title: 'TypeScript Podstawy', progress: 45, nextLesson: 'Typy zaawansowane', dueDate: 'Za 5 dni' },
    { id: '3', title: 'Git i GitHub', progress: 100, nextLesson: 'Ukończono', dueDate: 'Zakończone' },
  ];

  const upcomingTasks = [
    { id: '1', task: 'Ukończ sekcję "Hooks" w kursie React', priority: 'high', dueDate: 'Dzisiaj' },
    { id: '2', task: 'Wypełnij quiz z TypeScript', priority: 'medium', dueDate: 'Jutro' },
    { id: '3', task: 'Obejrzyj video o CSS Grid', priority: 'low', dueDate: 'Za 3 dni' },
  ];

  return (
    <div className="space-y-8">
      {/* Welcome banner */}
      <div className="bg-gradient-to-r from-emerald-600 to-teal-600 rounded-2xl p-8 text-white">
        <h1 className="mb-2">Witaj, {user.name}! 👋</h1>
        <p className="text-emerald-100">
          Kontynuuj naukę i rozwijaj swoje umiejętności
        </p>
        <div className="mt-6 grid grid-cols-3 gap-4">
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
            <p className="text-emerald-100 text-sm mb-1">Ukończone kursy</p>
            <p className="text-2xl">3</p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
            <p className="text-emerald-100 text-sm mb-1">W trakcie</p>
            <p className="text-2xl">2</p>
          </div>
          <div className="bg-white/20 backdrop-blur-sm rounded-xl p-4">
            <p className="text-emerald-100 text-sm mb-1">Godzin nauki</p>
            <p className="text-2xl">24h</p>
          </div>
        </div>
      </div>

      {/* My courses */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-[#0F172A]">Moje kursy</h3>
          <button className="text-[#2563EB] text-sm hover:text-[#3B82F6]">Zobacz wszystkie →</button>
        </div>
        <div className="grid grid-cols-1 gap-4">
          {myCourses.map((course) => (
            <div key={course.id} className="bg-white rounded-2xl border border-gray-200 p-6">
              <div className="flex items-start justify-between mb-4">
                <div className="flex-1">
                  <h4 className="text-[#0F172A] mb-2">{course.title}</h4>
                  <p className="text-sm text-[#475569] mb-3">
                    {course.progress === 100 ? '✓ ' : 'Następnie: '}
                    {course.nextLesson}
                  </p>
                  <div className="w-full bg-[#F1F5F9] rounded-full h-2 mb-2">
                    <div
                      className={`h-2 rounded-full transition-all ${
                        course.progress === 100 ? 'bg-green-500' : 'bg-[#2563EB]'
                      }`}
                      style={{ width: `${course.progress}%` }}
                    />
                  </div>
                  <p className="text-xs text-[#475569]">{course.progress}% ukończono</p>
                </div>
                <div className="ml-6 text-right">
                  <p className="text-xs text-[#475569] mb-3">{course.dueDate}</p>
                  <button className={`flex items-center gap-2 px-4 py-2 rounded-xl transition-colors ${
                    course.progress === 100
                      ? 'bg-green-50 text-green-700 hover:bg-green-100'
                      : 'bg-[#2563EB] text-white hover:bg-[#3B82F6]'
                  }`}>
                    {course.progress === 100 ? (
                      <>
                        <CheckCircle className="w-4 h-4" />
                        Przejrzyj
                      </>
                    ) : (
                      <>
                        <Play className="w-4 h-4" />
                        Kontynuuj
                      </>
                    )}
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Upcoming tasks */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 border border-gray-200">
          <div className="flex items-center gap-2 mb-6">
            <Target className="w-5 h-5 text-[#2563EB]" />
            <h3 className="text-[#0F172A]">Nadchodzące zadania</h3>
          </div>
          <div className="space-y-3">
            {upcomingTasks.map((task) => (
              <div key={task.id} className="flex items-start gap-4 p-4 bg-[#F8FAFC] rounded-xl">
                <input
                  type="checkbox"
                  className="mt-1 w-5 h-5 text-[#2563EB] border-gray-300 rounded focus:ring-[#2563EB]"
                />
                <div className="flex-1">
                  <p className="text-sm text-[#0F172A] mb-1">{task.task}</p>
                  <div className="flex items-center gap-2">
                    <span className={`inline-flex px-2 py-1 rounded text-xs ${
                      task.priority === 'high'
                        ? 'bg-red-50 text-red-700'
                        : task.priority === 'medium'
                        ? 'bg-yellow-50 text-yellow-700'
                        : 'bg-green-50 text-green-700'
                    }`}>
                      {task.priority === 'high' ? 'Wysoki' : task.priority === 'medium' ? 'Średni' : 'Niski'}
                    </span>
                    <span className="text-xs text-[#475569]">{task.dueDate}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Achievement & tips */}
        <div className="space-y-6">
          <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-2xl p-6 border border-amber-200">
            <h3 className="text-[#0F172A] mb-2">🏆 Osiągnięcie</h3>
            <p className="text-sm text-gray-700 mb-3">
              Ukończyłeś 3 kursy w tym miesiącu!
            </p>
            <div className="bg-white/50 rounded-xl p-3">
              <p className="text-xs text-gray-600">Kontynuuj w tym tempie, aby zdobyć odznakę "Mistrz nauki"</p>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-6 border border-gray-200">
            <h3 className="text-[#0F172A] mb-2">💡 Wskazówka dnia</h3>
            <p className="text-sm text-[#475569]">
              Regularność jest kluczem do sukcesu! Staraj się poświęcać 30 minut dziennie na naukę.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export function Dashboard({ user }: DashboardProps) {
  if (user.role === 'super-admin') {
    return <SuperAdminDashboard user={user} />;
  } else if (user.role === 'admin' || user.role === 'hr') {
    return <AdminDashboard user={user} />;
  } else {
    return <EmployeeDashboard user={user} />;
  }
}