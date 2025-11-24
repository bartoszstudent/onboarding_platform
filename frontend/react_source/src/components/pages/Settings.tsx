import { useState } from 'react';
import { User as UserIcon, Lock, Bell, Palette } from 'lucide-react';
import { User } from '../../App';

interface SettingsProps {
  user: User;
}

export function Settings({ user }: SettingsProps) {
  const [darkMode, setDarkMode] = useState(false);
  const [emailNotifications, setEmailNotifications] = useState(true);
  const [pushNotifications, setPushNotifications] = useState(false);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-[#0F172A] mb-2">Ustawienia</h2>
        <p className="text-[#475569]">Zarządzaj swoim profilem i preferencjami</p>
      </div>

      {/* Profile section */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <div className="flex items-center gap-3 mb-6">
          <UserIcon className="w-5 h-5 text-[#2563EB]" />
          <h3 className="text-[#0F172A]">Profil użytkownika</h3>
        </div>

        <div className="space-y-4">
          <div className="flex items-center gap-4 mb-6">
            <div className="w-20 h-20 bg-[#2563EB] rounded-xl flex items-center justify-center">
              <span className="text-white text-xl">{user.name.split(' ').map(n => n[0]).join('')}</span>
            </div>
            <button className="px-4 py-2 bg-[#F8FAFC] text-[#475569] rounded-xl hover:bg-[#F1F5F9] transition-colors border border-gray-300">
              Zmień zdjęcie
            </button>
          </div>

          <div>
            <label className="block text-[#0F172A] mb-2 text-sm">Imię i nazwisko</label>
            <input
              type="text"
              defaultValue={user.name}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
            />
          </div>

          <div>
            <label className="block text-[#0F172A] mb-2 text-sm">Email</label>
            <input
              type="email"
              defaultValue={user.email}
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
            />
          </div>

          <button className="px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors">
            Zapisz zmiany
          </button>
        </div>
      </div>

      {/* Password section */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <div className="flex items-center gap-3 mb-6">
          <Lock className="w-5 h-5 text-[#2563EB]" />
          <h3 className="text-[#0F172A]">Zmień hasło</h3>
        </div>

        <div className="space-y-4">
          <div>
            <label className="block text-[#0F172A] mb-2 text-sm">Aktualne hasło</label>
            <input
              type="password"
              placeholder="••••••••"
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
            />
          </div>

          <div>
            <label className="block text-[#0F172A] mb-2 text-sm">Nowe hasło</label>
            <input
              type="password"
              placeholder="••••••••"
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
            />
          </div>

          <div>
            <label className="block text-[#0F172A] mb-2 text-sm">Potwierdź nowe hasło</label>
            <input
              type="password"
              placeholder="••••••••"
              className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
            />
          </div>

          <button className="px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors">
            Zmień hasło
          </button>
        </div>
      </div>

      {/* Notifications section */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <div className="flex items-center gap-3 mb-6">
          <Bell className="w-5 h-5 text-[#2563EB]" />
          <h3 className="text-[#0F172A]">Powiadomienia</h3>
        </div>

        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-[#F8FAFC] rounded-xl">
            <div>
              <p className="text-[#0F172A] mb-1">Powiadomienia email</p>
              <p className="text-sm text-[#475569]">Otrzymuj powiadomienia o kursach na email</p>
            </div>
            <button
              onClick={() => setEmailNotifications(!emailNotifications)}
              className={`relative w-12 h-6 rounded-full transition-colors ${
                emailNotifications ? 'bg-[#2563EB]' : 'bg-gray-300'
              }`}
            >
              <div
                className={`absolute top-1 w-4 h-4 bg-white rounded-full transition-transform ${
                  emailNotifications ? 'translate-x-7' : 'translate-x-1'
                }`}
              />
            </button>
          </div>

          <div className="flex items-center justify-between p-4 bg-[#F8FAFC] rounded-xl">
            <div>
              <p className="text-[#0F172A] mb-1">Powiadomienia push</p>
              <p className="text-sm text-[#475569]">Otrzymuj powiadomienia w przeglądarce</p>
            </div>
            <button
              onClick={() => setPushNotifications(!pushNotifications)}
              className={`relative w-12 h-6 rounded-full transition-colors ${
                pushNotifications ? 'bg-[#2563EB]' : 'bg-gray-300'
              }`}
            >
              <div
                className={`absolute top-1 w-4 h-4 bg-white rounded-full transition-transform ${
                  pushNotifications ? 'translate-x-7' : 'translate-x-1'
                }`}
              />
            </button>
          </div>
        </div>
      </div>

      {/* Appearance section */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <div className="flex items-center gap-3 mb-6">
          <Palette className="w-5 h-5 text-[#2563EB]" />
          <h3 className="text-[#0F172A]">Wygląd</h3>
        </div>

        <div className="flex items-center justify-between p-4 bg-[#F8FAFC] rounded-xl">
          <div>
            <p className="text-[#0F172A] mb-1">Tryb ciemny</p>
            <p className="text-sm text-[#475569]">Przełącz na ciemny motyw interfejsu</p>
          </div>
          <button
            onClick={() => setDarkMode(!darkMode)}
            className={`relative w-12 h-6 rounded-full transition-colors ${
              darkMode ? 'bg-[#2563EB]' : 'bg-gray-300'
            }`}
          >
            <div
              className={`absolute top-1 w-4 h-4 bg-white rounded-full transition-transform ${
                darkMode ? 'translate-x-7' : 'translate-x-1'
              }`}
            />
          </button>
        </div>
      </div>
    </div>
  );
}
