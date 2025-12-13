import React, { useEffect, useState } from 'react';
import { WeatherData, ApiConfig } from '../types';
import { fetchWeather } from '../services/integratedAIService';
import { CloudRain, Droplets, MapPin, Thermometer } from 'lucide-react';

interface Props {
  config: ApiConfig;
}

const WeatherWidget: React.FC<Props> = ({ config }) => {
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (config.openWeatherKey) {
      setLoading(true);
      fetchWeather('Lahore', config.openWeatherKey)
        .then(setWeather)
        .finally(() => setLoading(false));
    }
  }, [config.openWeatherKey]);

  if (!config.openWeatherKey) {
    return (
      <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white shadow-lg">
        <h3 className="text-lg font-semibold flex items-center gap-2 mb-2">
          <CloudRain className="opacity-80" /> Weather Unavailable
        </h3>
        <p className="text-blue-100 text-sm opacity-90">
          Add your OpenWeather API key in settings to unlock real-time farming conditions.
        </p>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white shadow-lg animate-pulse h-40 flex items-center justify-center">
        <p>Loading Weather...</p>
      </div>
    );
  }

  if (!weather) return null;

  return (
    <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white shadow-lg transform transition-all hover:scale-[1.02]">
      <div className="flex justify-between items-start">
        <div>
          <h2 className="text-3xl font-bold">{Math.round(weather.temp)}°C</h2>
          <p className="text-blue-100 capitalize flex items-center gap-1 mt-1">
            <MapPin size={14} /> {weather.city}
          </p>
        </div>
        <img 
          src={`https://openweathermap.org/img/wn/${weather.icon}@2x.png`} 
          alt={weather.description} 
          className="w-16 h-16 -mt-2 drop-shadow-md"
        />
      </div>
      
      <div className="mt-6 flex justify-between text-sm text-blue-50">
        <div className="flex items-center gap-2 bg-white/10 px-3 py-1.5 rounded-lg backdrop-blur-sm">
          <Droplets size={16} />
          <span>Humidity: {weather.humidity}%</span>
        </div>
        <div className="flex items-center gap-2 bg-white/10 px-3 py-1.5 rounded-lg backdrop-blur-sm">
          <Thermometer size={16} />
          <span>{weather.description}</span>
        </div>
      </div>
    </div>
  );
};

export default WeatherWidget;