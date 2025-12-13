import React from 'react';
import { ApiConfig } from '../types';
import { checkApiStatus } from '../services/integratedAIService';
import { Cloud, Zap, Brain } from 'lucide-react';

interface Props {
  config: ApiConfig;
  onOpenSettings: () => void;
}

const StatusBar: React.FC<Props> = ({ config, onOpenSettings }) => {
  const status = checkApiStatus(config);

  const StatusChip = ({ active, label, icon: Icon }: { active: boolean, label: string, icon: any }) => (
    <div 
      className={`flex items-center gap-1.5 px-3 py-1 rounded-full border text-xs font-medium transition-colors ${
        active 
          ? 'bg-green-100 text-green-800 border-green-200' 
          : 'bg-gray-100 text-gray-500 border-gray-200 grayscale'
      }`}
    >
      <div className={`w-2 h-2 rounded-full ${active ? 'bg-green-500 animate-pulse' : 'bg-gray-400'}`} />
      <Icon size={12} />
      <span>{label}</span>
    </div>
  );

  return (
    <div className="flex flex-wrap gap-2 items-center cursor-pointer hover:opacity-80 transition-opacity" onClick={onOpenSettings}>
      <StatusChip active={status.openai} label="OpenAI" icon={Zap} />
      <StatusChip active={status.gemini} label="Gemini" icon={Brain} />
      <StatusChip active={status.weather} label="Weather" icon={Cloud} />
    </div>
  );
};

export default StatusBar;