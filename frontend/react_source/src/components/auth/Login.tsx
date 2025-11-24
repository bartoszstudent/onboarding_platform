import { useState } from 'react';
import { AlertCircle } from 'lucide-react';
import { UserRole } from '../../App';

interface LoginProps {
  onLogin: (email: string, role: UserRole) => void;
}

export function Login({ onLogin }: LoginProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!email || !password) {
      setError('Wypełnij wszystkie pola');
      return;
    }

    if (!/\S+@\S+\.\S+/.test(email)) {
      setError('Wprowadź poprawny adres email');
      return;
    }

    if (password.length < 6) {
      setError('Hasło musi mieć co najmniej 6 znaków');
      return;
    }

    // Demo login - różne role w zależności od emaila
    let role: UserRole = 'employee';
    if (email.includes('superadmin')) role = 'super-admin';
    else if (email.includes('admin')) role = 'admin';
    else if (email.includes('hr')) role = 'hr';

    onLogin(email, role);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4">
      <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-8 w-full max-w-[400px]">
        {/* Logo */}
        <div className="text-center mb-8">
          <h1 className="text-[#2563EB] mb-2">Onboardly</h1>
          <p className="text-[#475569]">Zaloguj się do platformy</p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label htmlFor="email" className="block text-[#0F172A] mb-2">
              Email
            </label>
            <input
              type="email"
              id="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB] focus:border-transparent"
              placeholder="twoj@email.com"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-[#0F172A] mb-2">
              Hasło
            </label>
            <input
              type="password"
              id="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB] focus:border-transparent"
              placeholder="••••••••"
            />
          </div>

          {error && (
            <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-200 rounded-xl text-red-700">
              <AlertCircle className="w-4 h-4 flex-shrink-0" />
              <span className="text-sm">{error}</span>
            </div>
          )}

          <button
            type="submit"
            className="w-full bg-[#2563EB] text-white py-3 rounded-xl hover:bg-[#3B82F6] transition-colors"
          >
            Zaloguj się
          </button>
        </form>

        {/* Demo info */}
        <div className="mt-6 p-4 bg-[#F8FAFC] rounded-xl border border-gray-200">
          <p className="text-xs text-[#475569] mb-2">Demo login (dowolne hasło 6+ znaków):</p>
          <p className="text-xs text-[#475569]">• superadmin@test.com - Super Admin</p>
          <p className="text-xs text-[#475569]">• admin@test.com - Admin</p>
          <p className="text-xs text-[#475569]">• hr@test.com - HR</p>
          <p className="text-xs text-[#475569]">• employee@test.com - Employee</p>
        </div>
      </div>
    </div>
  );
}
