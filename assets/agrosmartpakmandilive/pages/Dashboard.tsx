import React, { useState, useEffect } from 'react';
import { Search, MapPin, RefreshCw, AlertCircle, ExternalLink } from 'lucide-react';
import { fetchLiveMarketRates } from '../services/geminiService';
import { MarketItem, City, CITIES } from '../types';
import PriceCard from '../components/PriceCard';

const Dashboard: React.FC = () => {
  const [selectedCity, setSelectedCity] = useState<string>(City.Lahore);
  const [items, setItems] = useState<MarketItem[]>([]);
  const [sources, setSources] = useState<string[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  const loadData = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await fetchLiveMarketRates(selectedCity);
      setItems(data.items);
      setSources(data.sources);
    } catch (err) {
      setError("Failed to fetch latest market rates. Please try again later.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, [selectedCity]);

  const filteredItems = items.filter(item => 
    item.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-8">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-slate-900">Daily Market Rates</h1>
          <p className="text-slate-500 mt-1">Real-time agricultural commodity prices from {selectedCity}</p>
        </div>
        
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative">
            <select 
              value={selectedCity}
              onChange={(e) => setSelectedCity(e.target.value)}
              className="appearance-none bg-white border border-slate-200 text-slate-700 py-2.5 pl-10 pr-8 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 w-full sm:w-48"
            >
              {CITIES.map(city => (
                <option key={city} value={city}>{city}</option>
              ))}
            </select>
            <MapPin size={18} className="absolute left-3 top-3 text-emerald-600" />
          </div>
          
          <button 
            onClick={loadData}
            disabled={loading}
            className="flex items-center justify-center space-x-2 bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2.5 rounded-lg transition-colors disabled:opacity-50"
          >
            <RefreshCw size={18} className={loading ? "animate-spin" : ""} />
            <span>{loading ? 'Updating...' : 'Refresh'}</span>
          </button>
        </div>
      </div>

      {/* Search Bar */}
      <div className="relative max-w-md">
        <input
          type="text"
          placeholder="Search crops, vegetables..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent shadow-sm"
        />
        <Search size={20} className="absolute left-3 top-3.5 text-slate-400" />
      </div>

      {/* Content Area */}
      {error ? (
        <div className="bg-red-50 border border-red-200 rounded-xl p-6 flex items-center space-x-4 text-red-700">
          <AlertCircle size={24} />
          <p>{error}</p>
        </div>
      ) : loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {[1, 2, 3, 4, 5, 6, 7, 8].map((n) => (
            <div key={n} className="bg-white rounded-xl h-48 animate-pulse border border-slate-100">
              <div className="h-full p-5 flex flex-col justify-between">
                <div className="space-y-3">
                  <div className="h-4 bg-slate-100 rounded w-1/3"></div>
                  <div className="h-6 bg-slate-200 rounded w-3/4"></div>
                </div>
                <div className="h-8 bg-slate-100 rounded w-1/2"></div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <>
          {filteredItems.length === 0 ? (
            <div className="text-center py-20 bg-white rounded-xl border border-slate-200 border-dashed">
              <p className="text-slate-500 text-lg">No items found matching "{searchTerm}"</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {filteredItems.map((item) => (
                <PriceCard key={item.id} item={item} />
              ))}
            </div>
          )}

          {/* Source Attribution */}
          {sources.length > 0 && (
            <div className="mt-8 bg-slate-100 rounded-lg p-4 text-sm text-slate-600">
              <h4 className="font-semibold mb-2 flex items-center gap-2">
                <ExternalLink size={14} /> 
                Data Sources (Verified by AI)
              </h4>
              <ul className="list-disc list-inside space-y-1 overflow-hidden">
                {sources.map((source, idx) => (
                  <li key={idx} className="truncate">
                    <a href={source} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                      {new URL(source).hostname}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </>
      )}
    </div>
  );
};

export default Dashboard;