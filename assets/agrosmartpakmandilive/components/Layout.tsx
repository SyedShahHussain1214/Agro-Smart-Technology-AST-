import React from 'react';
import { Leaf, BarChart3, Home, Info } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

const Layout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const location = useLocation();

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col md:flex-row">
      {/* Sidebar for Desktop / Bottom Nav for Mobile */}
      <nav className="bg-emerald-900 text-white md:w-64 flex-shrink-0 flex flex-col justify-between sticky top-0 md:h-screen z-20">
        <div>
          <div className="p-6 flex items-center space-x-3">
            <div className="bg-emerald-500 p-2 rounded-lg">
              <Leaf size={24} className="text-white" />
            </div>
            <span className="font-bold text-xl tracking-tight">PakMandi Live</span>
          </div>
          
          <div className="px-4 pb-4 md:py-4 space-y-1">
            <Link 
              to="/" 
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${isActive('/') ? 'bg-emerald-800 text-emerald-100' : 'hover:bg-emerald-800/50 text-slate-300'}`}
            >
              <Home size={20} />
              <span>Dashboard</span>
            </Link>
            <Link 
              to="/analytics" 
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${isActive('/analytics') ? 'bg-emerald-800 text-emerald-100' : 'hover:bg-emerald-800/50 text-slate-300'}`}
            >
              <BarChart3 size={20} />
              <span>Trends & Analysis</span>
            </Link>
            <Link 
              to="/about" 
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg transition-colors ${isActive('/about') ? 'bg-emerald-800 text-emerald-100' : 'hover:bg-emerald-800/50 text-slate-300'}`}
            >
              <Info size={20} />
              <span>About API</span>
            </Link>
          </div>
        </div>

        <div className="p-4 text-xs text-emerald-400/60 hidden md:block">
          <p>© 2024 PakMandi Live</p>
          <p>Powered by Google Gemini</p>
        </div>
      </nav>

      {/* Main Content */}
      <main className="flex-1 overflow-x-hidden overflow-y-auto">
        <header className="bg-white shadow-sm sticky top-0 z-10 px-6 py-4 flex justify-between items-center md:hidden">
             <div className="flex items-center space-x-2">
                <Leaf size={20} className="text-emerald-700" />
                <span className="font-bold text-emerald-900">PakMandi Live</span>
             </div>
        </header>
        <div className="container mx-auto px-4 py-8 md:p-8">
          {children}
        </div>
      </main>
    </div>
  );
};

export default Layout;