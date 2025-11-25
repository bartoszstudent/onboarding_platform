import { ReactNode } from 'react';
import { Sidebar } from './Sidebar';
import { Topbar } from './Topbar';
import { User, Page } from '../../App';

interface MainLayoutProps {
  user: User;
  currentPage: Page;
  onNavigate: (page: Page) => void;
  onLogout: () => void;
  children: ReactNode;
}

export function MainLayout({ user, currentPage, onNavigate, onLogout, children }: MainLayoutProps) {
  return (
    <div className="flex h-screen bg-[#F8FAFC]">
      {/* Sidebar */}
      <Sidebar user={user} currentPage={currentPage} onNavigate={onNavigate} />

      {/* Main content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        <Topbar user={user} currentPage={currentPage} onLogout={onLogout} />
        <main className="flex-1 overflow-auto p-8">
          <div className="max-w-[1440px] mx-auto">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
