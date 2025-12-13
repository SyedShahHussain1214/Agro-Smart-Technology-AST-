import React from 'react';

interface InfoCardProps {
  title: string;
  icon: React.ReactNode;
  children: React.ReactNode;
  updated: boolean;
}

export const InfoCard: React.FC<InfoCardProps> = ({ title, icon, children, updated }) => {
  return (
    <div className={`relative p-6 rounded-2xl border transition-all duration-500 overflow-hidden
      ${updated 
        ? 'bg-white border-green-200 shadow-md shadow-green-100' 
        : 'bg-slate-50 border-slate-200 shadow-sm opacity-90'
      }`}>
      
      {/* Background decoration */}
      <div className="absolute -right-6 -top-6 w-24 h-24 bg-gradient-to-br from-transparent to-current opacity-5 rounded-full pointer-events-none" style={{ color: updated ? '#22c55e' : '#94a3b8' }}></div>

      <div className="flex items-center gap-3 mb-4">
        <div className={`p-2 rounded-xl ${updated ? 'bg-green-100' : 'bg-slate-200'}`}>
          {icon}
        </div>
        <h2 className="font-bold text-gray-700">{title}</h2>
        {updated && <span className="ml-auto text-[10px] font-bold text-green-600 bg-green-100 px-2 py-0.5 rounded-full">LIVE</span>}
      </div>
      
      <div className="relative z-10">
        {children}
      </div>
    </div>
  );
};
