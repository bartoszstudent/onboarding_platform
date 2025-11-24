import { Bell, LogOut, User as UserIcon } from 'lucide-react';
import { User, Page } from '../../App';

interface TopbarProps {
  user: User;
  currentPage: Page;
  onLogout: () => void;
}

const pageLabels: Record<Page, string> = {
  'dashboard': 'Dashboard',
  'courses': 'Kursy',
  'create-course': 'Tworzenie kursu',
  'course-player': 'Przeglądanie kursu',
  'users': 'Zarządzanie użytkownikami',
  'companies': 'Zarządzanie firmami',
  'settings': 'Ustawienia',
};

export function Topbar({ user, currentPage, onLogout }: TopbarProps) {
  return (
    <div className="h-[72px] bg-white border-b border-gray-200 flex items-center justify-between px-8">
      {/* Page title */}
      <h2 className="text-[#0F172A]">{pageLabels[currentPage]}</h2>

      {/* Right section */}
      <div className="flex items-center gap-4">
        {/* Notifications */}
        <button className="relative p-2 hover:bg-[#F1F5F9] rounded-xl transition-colors">
          <Bell className="w-5 h-5 text-[#475569]" />
          <span className="absolute top-1 right-1 w-2 h-2 bg-[#2563EB] rounded-full"></span>
        </button>

        {/* User menu */}
        <div className="flex items-center gap-3 pl-4 border-l border-gray-200">
          <div className="text-right">
            <p className="text-sm text-[#0F172A]">{user.name}</p>
            <p className="text-xs text-[#475569]">{user.email}</p>
          </div>
          <div className="w-10 h-10 bg-[#2563EB] rounded-xl flex items-center justify-center">
            <UserIcon className="w-5 h-5 text-white" />
          </div>
          <button
            onClick={onLogout}
            className="p-2 hover:bg-[#F1F5F9] rounded-xl transition-colors"
            title="Wyloguj"
          >
            <LogOut className="w-5 h-5 text-[#475569]" />
          </button>
        </div>
      </div>
    </div>
  );
}
