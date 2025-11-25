import { useState } from 'react';
import { LogIn, Mail, Lock, AlertCircle } from 'lucide-react';

interface LoginProps {
  onLogin: (name: string) => void;
}

export function Login({ onLogin }: LoginProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState({ email: '', password: '' });

  const validateForm = () => {
    const newErrors = { email: '', password: '' };
    let isValid = true;

    if (!email) {
      newErrors.email = 'Email jest wymagany';
      isValid = false;
    } else if (!/\S+@\S+\.\S+/.test(email)) {
      newErrors.email = 'Wprowadź poprawny adres email';
      isValid = false;
    }

    if (!password) {
      newErrors.password = 'Hasło jest wymagane';
      isValid = false;
    } else if (password.length < 6) {
      newErrors.password = 'Hasło musi mieć co najmniej 6 znaków';
      isValid = false;
    }

    setErrors(newErrors);
    return isValid;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (validateForm()) {
      const name = email.split('@')[0];
      onLogin(name);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-md">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-slate-900 rounded-2xl mb-4">
            <LogIn className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-gray-900 mb-2">Witaj ponownie!</h1>
          <p className="text-gray-600">Zaloguj się, aby kontynuować</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label htmlFor="email" className="block text-gray-700 mb-2">
              Email
            </label>
            <div className="relative">
              <Mail className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${errors.email ? 'text-rose-500' : 'text-gray-400'}`} />
              <input
                type="email"
                id="email"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  if (errors.email) setErrors({ ...errors, email: '' });
                }}
                className={`w-full pl-11 pr-4 py-3 border rounded-xl focus:outline-none focus:ring-2 transition-all ${
                  errors.email 
                    ? 'border-rose-300 focus:ring-rose-500 focus:border-rose-500 bg-rose-50' 
                    : 'border-gray-300 focus:ring-slate-900 focus:border-slate-900'
                }`}
                placeholder="twoj@email.com"
              />
            </div>
            {errors.email && (
              <div className="flex items-center gap-1 mt-2 text-rose-600">
                <AlertCircle className="w-4 h-4" />
                <span className="text-sm">{errors.email}</span>
              </div>
            )}
          </div>

          <div>
            <label htmlFor="password" className="block text-gray-700 mb-2">
              Hasło
            </label>
            <div className="relative">
              <Lock className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${errors.password ? 'text-rose-500' : 'text-gray-400'}`} />
              <input
                type="password"
                id="password"
                value={password}
                onChange={(e) => {
                  setPassword(e.target.value);
                  if (errors.password) setErrors({ ...errors, password: '' });
                }}
                className={`w-full pl-11 pr-4 py-3 border rounded-xl focus:outline-none focus:ring-2 transition-all ${
                  errors.password 
                    ? 'border-rose-300 focus:ring-rose-500 focus:border-rose-500 bg-rose-50' 
                    : 'border-gray-300 focus:ring-slate-900 focus:border-slate-900'
                }`}
                placeholder="••••••••"
              />
            </div>
            {errors.password && (
              <div className="flex items-center gap-1 mt-2 text-rose-600">
                <AlertCircle className="w-4 h-4" />
                <span className="text-sm">{errors.password}</span>
              </div>
            )}
          </div>

          <div className="flex items-center justify-between">
            <label className="flex items-center">
              <input
                type="checkbox"
                className="w-4 h-4 text-slate-900 border-gray-300 rounded focus:ring-slate-900"
              />
              <span className="ml-2 text-gray-700">Zapamiętaj mnie</span>
            </label>
            <a href="#" className="text-slate-700 hover:text-slate-900">
              Zapomniałeś hasła?
            </a>
          </div>

          <button
            type="submit"
            className="w-full bg-slate-900 text-white py-3 rounded-xl hover:bg-slate-800 transition-colors flex items-center justify-center gap-2"
          >
            <LogIn className="w-5 h-5" />
            Zaloguj się
          </button>
        </form>

        <div className="mt-6 text-center">
          <p className="text-gray-600">
            Nie masz konta?{' '}
            <a href="#" className="text-slate-900 hover:text-slate-700">
              Zarejestruj się
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}