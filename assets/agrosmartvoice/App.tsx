import React, { useState, useEffect, useRef } from 'react';
import { Mic, MicOff, MapPin, Leaf, TrendingUp, CloudSun } from 'lucide-react';
import { useGeminiLive } from './hooks/useGeminiLive';
import { AudioVisualizer } from './components/AudioVisualizer';
import { InfoCard } from './components/InfoCard';
import { DashboardData } from './types';

const App: React.FC = () => {
  const [location, setLocation] = useState<string>("Locating...");
  const [coords, setCoords] = useState<{lat: number, lng: number} | null>(null);
  
  // Dashboard state managed by the AI via tool calls
  const [dashboardData, setDashboardData] = useState<DashboardData>({
    weather: { temp: "--", condition: "Waiting for update...", humidity: "--" },
    crops: []
  });

  const { 
    isConnected, 
    isSpeaking, 
    connect, 
    disconnect, 
    volumeLevel,
    sources
  } = useGeminiLive({
    coords,
    onDashboardUpdate: (data) => {
      setDashboardData(prev => ({
        ...prev,
        ...data
      }));
    }
  });

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setCoords({
            lat: position.coords.latitude,
            lng: position.coords.longitude
          });
          setLocation(`${position.coords.latitude.toFixed(2)}, ${position.coords.longitude.toFixed(2)}`);
        },
        (error) => {
          console.error("Error getting location", error);
          setLocation("Unknown Location");
        }
      );
    }
  }, []);

  const handleToggle = () => {
    if (isConnected) {
      disconnect();
    } else {
      connect();
    }
  };

  return (
    <div className="min-h-screen flex flex-col items-center p-4 md:p-8 max-w-5xl mx-auto">
      
      {/* Header */}
      <header className="w-full flex justify-between items-center mb-8 bg-white/60 backdrop-blur-md p-4 rounded-2xl shadow-sm border border-green-100">
        <div className="flex items-center gap-3">
          <div className="bg-green-600 p-2 rounded-lg text-white">
            <Leaf size={24} />
          </div>
          <div>
            <h1 className="text-xl font-bold text-gray-800">AgriVoice AI</h1>
            <p className="text-xs text-green-700 font-medium">Dynamic Farm Assistant</p>
          </div>
        </div>
        <div className="flex items-center gap-2 text-sm text-gray-600 bg-white px-3 py-1.5 rounded-full border border-gray-200 shadow-sm">
          <MapPin size={16} className="text-red-500" />
          <span>{location}</span>
        </div>
      </header>

      {/* Main Visualizer Area */}
      <div className="relative w-full aspect-video max-h-[400px] bg-gradient-to-b from-slate-900 to-slate-800 rounded-3xl overflow-hidden shadow-2xl flex flex-col items-center justify-center mb-8 border border-slate-700">
        
        {/* Connection Status Overlay */}
        <div className={`absolute top-4 right-4 px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-2 transition-colors ${isConnected ? 'bg-green-500/20 text-green-400 border border-green-500/30' : 'bg-gray-700/50 text-gray-400 border border-gray-600'}`}>
          <div className={`w-2 h-2 rounded-full ${isConnected ? 'bg-green-400 animate-pulse' : 'bg-gray-400'}`}></div>
          {isConnected ? (isSpeaking ? 'AI Speaking...' : 'Listening...') : 'Disconnected'}
        </div>

        {/* Visualizer */}
        <div className="w-full h-full flex items-center justify-center opacity-80">
           <AudioVisualizer isConnected={isConnected} volume={volumeLevel} />
        </div>

        {/* Floating Mic Button */}
        <button 
          onClick={handleToggle}
          className={`absolute bottom-8 transform hover:scale-105 transition-all duration-300 shadow-lg flex items-center gap-3 px-8 py-4 rounded-full font-bold text-lg
            ${isConnected 
              ? 'bg-red-500 hover:bg-red-600 text-white ring-4 ring-red-500/20' 
              : 'bg-green-600 hover:bg-green-700 text-white ring-4 ring-green-600/20'}`}
        >
          {isConnected ? <MicOff size={24} /> : <Mic size={24} />}
          {isConnected ? 'End Session' : 'Start Assistant'}
        </button>
      </div>

      {/* Info Dashboard */}
      <div className="w-full grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* Weather Card */}
        <InfoCard 
          title="Live Weather" 
          icon={<CloudSun size={20} className="text-blue-500" />}
          updated={dashboardData.weather.condition !== "Waiting for update..."}
        >
          <div className="flex items-center justify-between mt-2">
            <div>
              <div className="text-4xl font-bold text-gray-800">{dashboardData.weather.temp}</div>
              <div className="text-gray-500 font-medium">{dashboardData.weather.condition}</div>
            </div>
            <div className="text-right">
               <div className="text-sm text-gray-400">Humidity</div>
               <div className="font-semibold text-gray-700">{dashboardData.weather.humidity}</div>
            </div>
          </div>
        </InfoCard>

        {/* Crop Rates Card */}
        <InfoCard 
          title="Market Rates" 
          icon={<TrendingUp size={20} className="text-green-600" />}
          updated={dashboardData.crops.length > 0}
        >
          <div className="space-y-3 mt-2">
            {dashboardData.crops.length === 0 ? (
              <div className="text-center text-gray-400 py-4 italic text-sm">
                Ask about crop prices to see data here...
              </div>
            ) : (
              dashboardData.crops.map((crop, idx) => (
                <div key={idx} className="flex justify-between items-center p-2 hover:bg-green-50 rounded-lg transition-colors border border-transparent hover:border-green-100">
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 rounded-full bg-green-500"></div>
                    <span className="font-medium text-gray-700 capitalize">{crop.name}</span>
                  </div>
                  <div className="flex flex-col items-end">
                    <span className="font-bold text-gray-800">{crop.price}</span>
                    <span className={`text-xs ${crop.trend === 'up' ? 'text-green-600' : crop.trend === 'down' ? 'text-red-500' : 'text-gray-400'}`}>
                      {crop.trend === 'up' ? '▲ Trending Up' : crop.trend === 'down' ? '▼ Trending Down' : '• Stable'}
                    </span>
                  </div>
                </div>
              ))
            )}
          </div>
        </InfoCard>
      </div>

      {/* Grounding Sources */}
      {sources.length > 0 && (
        <div className="w-full mt-8 p-4 bg-white rounded-xl shadow-sm border border-gray-200">
           <h3 className="text-sm font-semibold text-gray-500 mb-3 uppercase tracking-wider">Sources</h3>
           <div className="flex flex-wrap gap-2">
             {sources.map((src, i) => (
               <a 
                key={i} 
                href={src.uri} 
                target="_blank" 
                rel="noreferrer"
                className="text-xs bg-slate-100 hover:bg-slate-200 text-slate-700 px-3 py-1.5 rounded-md transition-colors truncate max-w-[200px]"
               >
                 {src.title || new URL(src.uri).hostname}
               </a>
             ))}
           </div>
        </div>
      )}

    </div>
  );
};

export default App;