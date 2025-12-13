export interface ApiConfig {
  openaiKey: string;
  geminiKey: string;
  openWeatherKey: string;
}

export interface WeatherData {
  temp: number;
  humidity: number;
  description: string;
  city: string;
  icon: string;
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant' | 'system';
  content: string;
  timestamp: number;
  source?: 'OpenAI' | 'Gemini' | 'OpenWeather';
}

export interface AnalysisResult {
  diseaseName: string;
  confidence: string;
  symptoms: string[];
  treatment: string[];
}

export type AppView = 'chat' | 'disease' | 'settings';

export type Language = 'en' | 'ur';
