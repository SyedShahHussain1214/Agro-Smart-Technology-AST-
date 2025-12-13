import React, { useState, useEffect } from 'react';
import { ApiConfig } from '../types';
import { Key, ShieldCheck, X } from 'lucide-react';

interface Props {
  isOpen: boolean;
  onClose: () => void;
  config: ApiConfig;
  onSave: (config: ApiConfig) => void;
}

const ApiKeyModal: React.FC<Props> = ({ isOpen, onClose, config, onSave }) => {
  const [localConfig, setLocalConfig] = useState<ApiConfig>(config);

  useEffect(() => {
    setLocalConfig(config);
  }, [config]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in duration-200">
        <div className="bg-green-700 px-6 py-4 flex justify-between items-center">
          <h2 className="text-white text-xl font-semibold flex items-center gap-2">
            <ShieldCheck size={24} /> API Configuration
          </h2>
          <button onClick={onClose} className="text-white/80 hover:text-white transition-colors">
            <X size={24} />
          </button>
        </div>
        
        <div className="p-6 space-y-4">
          <p className="text-sm text-gray-600 bg-blue-50 p-3 rounded-lg border border-blue-100">
            Keys are stored locally in your browser. Refer to the <strong>API Configuration Guide</strong> for how to get these keys.
          </p>

          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">OpenAI API Key (GPT-4)</label>
            <div className="relative">
              <Key className="absolute left-3 top-2.5 text-gray-400" size={16} />
              <input
                type="password"
                value={localConfig.openaiKey}
                onChange={(e) => setLocalConfig({...localConfig, openaiKey: e.target.value})}
                placeholder="sk-proj-..."
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">Gemini API Key (Vision & Fallback)</label>
            <div className="relative">
              <Key className="absolute left-3 top-2.5 text-gray-400" size={16} />
              <input
                type="password"
                value={localConfig.geminiKey}
                onChange={(e) => setLocalConfig({...localConfig, geminiKey: e.target.value})}
                placeholder="AIza..."
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">OpenWeather API Key</label>
            <div className="relative">
              <Key className="absolute left-3 top-2.5 text-gray-400" size={16} />
              <input
                type="password"
                value={localConfig.openWeatherKey}
                onChange={(e) => setLocalConfig({...localConfig, openWeatherKey: e.target.value})}
                placeholder="32 chars hex..."
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
              />
            </div>
          </div>
        </div>

        <div className="px-6 py-4 bg-gray-50 flex justify-end gap-3">
          <button 
            onClick={onClose}
            className="px-4 py-2 text-gray-700 hover:bg-gray-200 rounded-lg transition-colors font-medium"
          >
            Cancel
          </button>
          <button 
            onClick={() => {
              onSave(localConfig);
              onClose();
            }}
            className="px-6 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg shadow-md transition-all transform active:scale-95 font-medium"
          >
            Save Configuration
          </button>
        </div>
      </div>
    </div>
  );
};

export default ApiKeyModal;