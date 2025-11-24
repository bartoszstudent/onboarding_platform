import { useState } from 'react';
import { Plus, Search, MoreVertical, Mail, Shield } from 'lucide-react';
import { User } from '../../App';

interface UserManagementProps {
  user: User;
}

const mockUsers = [
  { id: '1', name: 'Jan Kowalski', email: 'jan.kowalski@firma.pl', role: 'employee', courses: 3 },
  { id: '2', name: 'Anna Nowak', email: 'anna.nowak@firma.pl', role: 'employee', courses: 5 },
  { id: '3', name: 'Piotr Wiśniewski', email: 'piotr.wisniewski@firma.pl', role: 'hr', courses: 8 },
  { id: '4', name: 'Maria Lewandowska', email: 'maria.lewandowska@firma.pl', role: 'admin', courses: 12 },
  { id: '5', name: 'Tomasz Dąbrowski', email: 'tomasz.dabrowski@firma.pl', role: 'employee', courses: 2 },
];

const roleLabels: Record<string, string> = {
  'super-admin': 'Super Admin',
  'admin': 'Administrator',
  'hr': 'HR',
  'employee': 'Pracownik',
};

const roleColors: Record<string, string> = {
  'super-admin': 'bg-purple-100 text-purple-700',
  'admin': 'bg-blue-100 text-blue-700',
  'hr': 'bg-green-100 text-green-700',
  'employee': 'bg-gray-100 text-gray-700',
};

export function UserManagement({ user }: UserManagementProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [showAddModal, setShowAddModal] = useState(false);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-[#0F172A] mb-2">Zarządzanie użytkownikami</h2>
          <p className="text-[#475569]">Dodawaj i zarządzaj użytkownikami platformy</p>
        </div>
        <button
          onClick={() => setShowAddModal(true)}
          className="flex items-center gap-2 px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors"
        >
          <Plus className="w-5 h-5" />
          Dodaj użytkownika
        </button>
      </div>

      {/* Search and filters */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <div className="flex items-center gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#475569]" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Szukaj użytkowników..."
              className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
            />
          </div>
          <select className="px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]">
            <option value="">Wszystkie role</option>
            <option value="admin">Administrator</option>
            <option value="hr">HR</option>
            <option value="employee">Pracownik</option>
          </select>
        </div>
      </div>

      {/* Users table */}
      <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-[#F8FAFC] border-b border-gray-200">
              <tr>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Użytkownik</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Email</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Rola</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Przypisane kursy</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Akcje</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {mockUsers.map((userData) => (
                <tr key={userData.id} className="hover:bg-[#F8FAFC] transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-[#2563EB] rounded-xl flex items-center justify-center">
                        <span className="text-white text-sm">
                          {userData.name.split(' ').map(n => n[0]).join('')}
                        </span>
                      </div>
                      <span className="text-sm text-[#0F172A]">{userData.name}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2 text-sm text-[#475569]">
                      <Mail className="w-4 h-4" />
                      {userData.email}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center gap-1 px-3 py-1 rounded-lg text-xs ${roleColors[userData.role]}`}>
                      <Shield className="w-3 h-3" />
                      {roleLabels[userData.role]}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <span className="text-sm text-[#0F172A]">{userData.courses} kursów</span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <button className="px-4 py-2 bg-[#F8FAFC] text-[#2563EB] rounded-lg hover:bg-[#F1F5F9] transition-colors text-sm">
                        Edytuj
                      </button>
                      <button className="px-4 py-2 bg-[#F8FAFC] text-[#475569] rounded-lg hover:bg-[#F1F5F9] transition-colors text-sm">
                        Przypisz kursy
                      </button>
                      <button className="p-2 hover:bg-[#F1F5F9] rounded-lg transition-colors">
                        <MoreVertical className="w-5 h-5 text-[#475569]" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add User Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl p-8 w-full max-w-md">
            <h3 className="text-[#0F172A] mb-6">Dodaj nowego użytkownika</h3>
            
            <div className="space-y-4 mb-6">
              <div>
                <label className="block text-[#0F172A] mb-2 text-sm">Imię i nazwisko</label>
                <input
                  type="text"
                  placeholder="Jan Kowalski"
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                />
              </div>
              
              <div>
                <label className="block text-[#0F172A] mb-2 text-sm">Email</label>
                <input
                  type="email"
                  placeholder="jan.kowalski@firma.pl"
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                />
              </div>
              
              <div>
                <label className="block text-[#0F172A] mb-2 text-sm">Rola</label>
                <select className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]">
                  <option value="employee">Pracownik</option>
                  <option value="hr">HR</option>
                  <option value="admin">Administrator</option>
                </select>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <button
                onClick={() => setShowAddModal(false)}
                className="flex-1 px-4 py-3 bg-[#F8FAFC] text-[#475569] rounded-xl hover:bg-[#F1F5F9] transition-colors"
              >
                Anuluj
              </button>
              <button className="flex-1 px-4 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors">
                Dodaj użytkownika
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
