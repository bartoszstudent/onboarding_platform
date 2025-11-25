import { LayoutDashboard, BookOpen, Users, Building2, Settings } from 'lucide-react';
import { User, Page } from '../../App';

interface SidebarProps {
  user: User;
  currentPage: Page;
  onNavigate: (page: Page) => void;
}

interface NavItem {
  id: Page;
  label: string;
  icon: React.ReactNode;
  roles?: string[];
}

export function Sidebar({ user, currentPage, onNavigate }: SidebarProps) {
  const navItems: NavItem[] = [
    { id: 'dashboard', label: 'Dashboard', icon: <LayoutDashboard className="w-5 h-5" /> },
    { 
      id: 'companies', 
      label: 'Firmy', 
      icon: <Building2 className="w-5 h-5" />, 
      roles: ['super-admin'] 
    },
    { 
      id: 'courses', 
      label: 'Kursy', 
      icon: <BookOpen className="w-5 h-5" />,
      roles: ['admin', 'hr', 'employee']
    },
    { 
      id: 'users', 
      label: 'Użytkownicy', 
      icon: <Users className="w-5 h-5" />, 
      roles: ['admin', 'hr'] 
    },
    { id: 'settings', label: 'Ustawienia', icon: <Settings className="w-5 h-5" /> },
  ];

  const filteredNavItems = navItems.filter(item => 
    !item.roles || item.roles.includes(user.role)
  );

  return (
    <div className="w-[240px] bg-white border-r border-gray-200 flex flex-col">
      {/* Logo */}
      <div className="p-6 border-b border-gray-200">
        <h2 className="text-[#2563EB]">Onboardly</h2>
        {user.role !== 'super-admin' && (
          <p className="text-xs text-[#475569] mt-1">TechCorp Sp. z o.o.</p>
        )}
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-1">
        {filteredNavItems.map((item) => {
          const isActive = currentPage === item.id;
          return (
            <button
              key={item.id}
              onClick={() => onNavigate(item.id)}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-colors text-left ${
                isActive
                  ? 'bg-[#2563EB] text-white'
                  : 'text-[#475569] hover:bg-[#F1F5F9]'
              }`}
            >
              {item.icon}
              <span>{item.label}</span>
            </button>
          );
        })}
      </nav>

      {/* User role badge */}
      <div className="p-4 border-t border-gray-200">
        <div className="px-4 py-2 bg-[#F1F5F9] rounded-xl text-center">
          <p className="text-xs text-[#475569]">Rola</p>
          <p className="text-sm text-[#0F172A] capitalize">
            {user.role === 'super-admin' ? 'Super Admin' : 
             user.role === 'admin' ? 'Administrator' : 
             user.role === 'hr' ? 'HR' : 'Pracownik'}
          </p>
        </div>
      </div>
    </div>
  );
}