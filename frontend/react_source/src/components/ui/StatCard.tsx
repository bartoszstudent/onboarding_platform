interface StatCardProps {
  icon: React.ReactNode;
  label: string;
  value: string;
  trend: string;
  color: 'blue' | 'green' | 'purple';
}

const colorClasses = {
  blue: 'bg-blue-50 text-[#2563EB]',
  green: 'bg-green-50 text-green-600',
  purple: 'bg-purple-50 text-purple-600',
};

export function StatCard({ icon, label, value, trend, color }: StatCardProps) {
  return (
    <div className="bg-white rounded-2xl p-6 border border-gray-200">
      <div className="flex items-center justify-between mb-4">
        <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${colorClasses[color]}`}>
          {icon}
        </div>
      </div>
      <p className="text-sm text-[#475569] mb-1">{label}</p>
      <p className="text-[#0F172A] mb-2">{value}</p>
      <p className="text-xs text-[#475569]">{trend}</p>
    </div>
  );
}
