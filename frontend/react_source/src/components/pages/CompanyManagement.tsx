import { useState } from 'react';
import { Plus, Search, Building2, Users, BookOpen, MoreVertical, Mail, Globe } from 'lucide-react';

const mockCompanies = [
  { id: '1', name: 'TechCorp Sp. z o.o.', domain: 'techcorp', subdomain: 'techcorp.onboardly.app', employees: 45, courses: 12, logo: '', admin: 'admin@techcorp.pl' },
  { id: '2', name: 'Digital Solutions', domain: 'digitalsolutions', subdomain: 'digitalsolutions.onboardly.app', employees: 78, courses: 18, logo: '', admin: 'hr@digitalsolutions.com' },
  { id: '3', name: 'StartupHub', domain: 'startuphub', subdomain: 'startuphub.onboardly.app', employees: 23, courses: 8, logo: '', admin: 'admin@startuphub.io' },
  { id: '4', name: 'Enterprise Inc.', domain: 'enterprise', subdomain: 'enterprise.onboardly.app', employees: 156, courses: 24, logo: '', admin: 'contact@enterprise.com' },
];

export function CompanyManagement() {
  const [searchQuery, setSearchQuery] = useState('');
  const [showAddModal, setShowAddModal] = useState(false);
  const [newCompany, setNewCompany] = useState({
    name: '',
    subdomain: '',
    adminEmail: '',
    adminName: '',
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-[#0F172A] mb-2">Zarządzanie firmami</h2>
          <p className="text-[#475569]">Panel Super Admina - zarządzaj wszystkimi firmami w platformie multi-tenant</p>
        </div>
        <button
          onClick={() => setShowAddModal(true)}
          className="flex items-center gap-2 px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors"
        >
          <Plus className="w-5 h-5" />
          Dodaj firmę
        </button>
      </div>

      {/* Search */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6">
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#475569]" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Szukaj firm..."
            className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
          />
        </div>
      </div>

      {/* Companies table */}
      <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-[#F8FAFC] border-b border-gray-200">
              <tr>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Firma</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Subdomena</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Administrator</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Pracownicy</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Kursy</th>
                <th className="px-6 py-4 text-left text-sm text-[#475569]">Akcje</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {mockCompanies.map((company) => (
                <tr key={company.id} className="hover:bg-[#F8FAFC] transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-[#2563EB] rounded-xl flex items-center justify-center">
                        <Building2 className="w-5 h-5 text-white" />
                      </div>
                      <span className="text-sm text-[#0F172A]">{company.name}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2 text-sm text-[#475569]">
                      <Globe className="w-4 h-4" />
                      {company.subdomain}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2 text-sm text-[#475569]">
                      <Mail className="w-4 h-4" />
                      {company.admin}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1 text-sm text-[#0F172A]">
                      <Users className="w-4 h-4 text-[#475569]" />
                      {company.employees}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1 text-sm text-[#0F172A]">
                      <BookOpen className="w-4 h-4 text-[#475569]" />
                      {company.courses}
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <button className="px-4 py-2 bg-[#2563EB] text-white rounded-lg hover:bg-[#3B82F6] transition-colors text-sm">
                        Zarządzaj
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

      {/* Add Company Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl p-8 w-full max-w-lg">
            <h3 className="text-[#0F172A] mb-2">Dodaj nową firmę</h3>
            <p className="text-sm text-[#475569] mb-6">Każda firma otrzyma własną subdomenę i administratora</p>
            
            <div className="space-y-4 mb-6">
              <div>
                <label className="block text-[#0F172A] mb-2 text-sm">Nazwa firmy</label>
                <input
                  type="text"
                  value={newCompany.name}
                  onChange={(e) => setNewCompany({ ...newCompany, name: e.target.value })}
                  placeholder="TechCorp Sp. z o.o."
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                />
              </div>
              
              <div>
                <label className="block text-[#0F172A] mb-2 text-sm">Subdomena</label>
                <div className="flex items-center gap-2">
                  <input
                    type="text"
                    value={newCompany.subdomain}
                    onChange={(e) => setNewCompany({ ...newCompany, subdomain: e.target.value })}
                    placeholder="techcorp"
                    className="flex-1 px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                  />
                  <span className="text-sm text-[#475569]">.onboardly.app</span>
                </div>
                <p className="text-xs text-[#475569] mt-1">URL dostępu do platformy dla firmy</p>
              </div>

              <div className="pt-4 border-t border-gray-200">
                <h4 className="text-[#0F172A] mb-4 text-sm">Administrator firmy</h4>
                
                <div className="space-y-4">
                  <div>
                    <label className="block text-[#0F172A] mb-2 text-sm">Imię i nazwisko administratora</label>
                    <input
                      type="text"
                      value={newCompany.adminName}
                      onChange={(e) => setNewCompany({ ...newCompany, adminName: e.target.value })}
                      placeholder="Jan Kowalski"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                    />
                  </div>

                  <div>
                    <label className="block text-[#0F172A] mb-2 text-sm">Email administratora</label>
                    <input
                      type="email"
                      value={newCompany.adminEmail}
                      onChange={(e) => setNewCompany({ ...newCompany, adminEmail: e.target.value })}
                      placeholder="admin@techcorp.pl"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                    />
                    <p className="text-xs text-[#475569] mt-1">Administrator otrzyma email z linkiem aktywacyjnym</p>
                  </div>
                </div>
              </div>
              
              <div>
                <label className="block text-[#0F172A] mb-2 text-sm">Logo firmy (opcjonalne)</label>
                <div className="flex items-center gap-4">
                  <div className="w-20 h-20 bg-[#F1F5F9] rounded-xl flex items-center justify-center border border-gray-300">
                    <Building2 className="w-8 h-8 text-[#475569]" />
                  </div>
                  <button className="px-4 py-2 bg-[#F8FAFC] text-[#475569] rounded-xl hover:bg-[#F1F5F9] transition-colors border border-gray-300 text-sm">
                    Prześlij logo
                  </button>
                </div>
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
                Utwórz firmę
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}