import React, { useState } from 'react';
import { AppView } from './types';
import { MOCK_WEATHER } from './constants';
import VoiceAssistant from './components/VoiceAssistant';
import DiseaseDetector from './components/DiseaseDetector';
import Marketplace from './components/Marketplace';
import MarketPrices from './components/MarketPrices';

const App: React.FC = () => {
  const [currentView, setCurrentView] = useState<AppView>(AppView.HOME);

  const renderContent = () => {
    switch (currentView) {
      case AppView.ASSISTANT:
        return <VoiceAssistant />;
      case AppView.DETECT:
        return <DiseaseDetector />;
      case AppView.MARKET:
        return <Marketplace />;
      case AppView.PRICES:
        return <MarketPrices />;
      case AppView.HOME:
      default:
        return (
          <div className="flex flex-col h-full bg-gray-50 pb-20 overflow-y-auto no-scrollbar">
             {/* Hero Section */}
             <div className="bg-agro-600 p-6 text-white rounded-b-[40px] shadow-xl relative overflow-hidden">
                <div className="relative z-10">
                    <div className="flex justify-between items-start mb-6">
                        <div>
                            <h1 className="text-3xl font-bold">Agro Smart</h1>
                            <p className="opacity-90">Technology</p>
                        </div>
                        <div className="bg-white/20 p-2 rounded-full">
                            <i className="fas fa-user-circle text-2xl"></i>
                        </div>
                    </div>
                    
                    {/* Weather Widget */}
                    <div className="bg-white/10 backdrop-blur-md p-4 rounded-2xl border border-white/20 flex items-center justify-between">
                        <div>
                            <div className="text-3xl font-bold">{MOCK_WEATHER.temp}°C</div>
                            <div className="text-sm opacity-90">{MOCK_WEATHER.condition}</div>
                            <div className="text-xs mt-1"><i className="fas fa-map-marker-alt"></i> {MOCK_WEATHER.location}</div>
                        </div>
                        <i className="fas fa-sun text-4xl text-yellow-300"></i>
                    </div>
                </div>
                {/* Decorative Circles */}
                <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-10 -mt-10"></div>
                <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full -ml-10 -mb-10"></div>
             </div>

             {/* Quick Actions Grid */}
             <div className="p-6">
                <h3 className="font-bold text-gray-800 text-lg mb-4">Quick Services</h3>
                <div className="grid grid-cols-2 gap-4">
                    <button onClick={() => setCurrentView(AppView.DETECT)} className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 flex flex-col items-center hover:bg-gray-50 transition-colors">
                        <div className="w-12 h-12 rounded-full bg-red-100 text-red-600 flex items-center justify-center text-xl mb-3">
                            <i className="fas fa-camera"></i>
                        </div>
                        <span className="font-semibold text-gray-700">Detect Disease</span>
                    </button>

                    <button onClick={() => setCurrentView(AppView.ASSISTANT)} className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 flex flex-col items-center hover:bg-gray-50 transition-colors">
                        <div className="w-12 h-12 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-xl mb-3">
                            <i className="fas fa-microphone"></i>
                        </div>
                        <span className="font-semibold text-gray-700">Voice Help</span>
                    </button>

                    <button onClick={() => setCurrentView(AppView.MARKET)} className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 flex flex-col items-center hover:bg-gray-50 transition-colors">
                        <div className="w-12 h-12 rounded-full bg-green-100 text-green-600 flex items-center justify-center text-xl mb-3">
                            <i className="fas fa-shopping-basket"></i>
                        </div>
                        <span className="font-semibold text-gray-700">Marketplace</span>
                    </button>

                    <button onClick={() => setCurrentView(AppView.PRICES)} className="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 flex flex-col items-center hover:bg-gray-50 transition-colors">
                        <div className="w-12 h-12 rounded-full bg-yellow-100 text-yellow-600 flex items-center justify-center text-xl mb-3">
                            <i className="fas fa-chart-line"></i>
                        </div>
                        <span className="font-semibold text-gray-700">Mandi Rates</span>
                    </button>
                </div>
             </div>

             {/* Recent Tips */}
             <div className="px-6 pb-6">
                 <h3 className="font-bold text-gray-800 text-lg mb-4">Daily Farming Tip</h3>
                 <div className="bg-white p-4 rounded-xl shadow-sm border-l-4 border-agro-500">
                     <p className="text-gray-600 text-sm leading-relaxed">
                         "To prevent cotton leaf curl virus, remove weeds from around the field and use recommended resistant seed varieties."
                     </p>
                 </div>
             </div>
          </div>
        );
    }
  };

  return (
    <div className="h-screen w-full max-w-md mx-auto bg-white shadow-2xl overflow-hidden relative font-sans">
      {/* Main Content Area */}
      <div className="h-full">
        {renderContent()}
      </div>

      {/* Sticky Bottom Navigation */}
      <div className="absolute bottom-0 w-full bg-white border-t border-gray-200 px-6 py-3 flex justify-between items-center z-50">
        <NavButton 
            active={currentView === AppView.HOME} 
            icon="fa-home" 
            label="Home" 
            onClick={() => setCurrentView(AppView.HOME)} 
        />
        <NavButton 
            active={currentView === AppView.MARKET} 
            icon="fa-store" 
            label="Mandi" 
            onClick={() => setCurrentView(AppView.MARKET)} 
        />
        
        {/* Central Action Button */}
        <div className="relative -top-6">
            <button 
                onClick={() => setCurrentView(AppView.ASSISTANT)}
                className="w-14 h-14 bg-agro-600 rounded-full text-white shadow-lg flex items-center justify-center border-4 border-white transform hover:scale-105 transition-transform"
            >
                <i className="fas fa-microphone text-xl"></i>
            </button>
        </div>

        <NavButton 
            active={currentView === AppView.DETECT} 
            icon="fa-leaf" 
            label="Scan" 
            onClick={() => setCurrentView(AppView.DETECT)} 
        />
        <NavButton 
            active={currentView === AppView.PRICES} 
            icon="fa-tags" 
            label="Rates" 
            onClick={() => setCurrentView(AppView.PRICES)} 
        />
      </div>
    </div>
  );
};

const NavButton: React.FC<{ active: boolean; icon: string; label: string; onClick: () => void }> = ({ active, icon, label, onClick }) => (
    <button onClick={onClick} className={`flex flex-col items-center space-y-1 ${active ? 'text-agro-600' : 'text-gray-400'}`}>
        <i className={`fas ${icon} text-xl`}></i>
        <span className="text-[10px] font-medium">{label}</span>
    </button>
);

export default App;
