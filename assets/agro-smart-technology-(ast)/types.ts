export enum AppView {
  HOME = 'HOME',
  ASSISTANT = 'ASSISTANT',
  DETECT = 'DETECT',
  MARKET = 'MARKET',
  PRICES = 'PRICES'
}

export interface ChatMessage {
  id: string;
  role: 'user' | 'model';
  text: string;
  isAudio?: boolean;
}

export interface MarketItem {
  id: string;
  name: string;
  price: number;
  unit: string;
  seller: string;
  location: string;
  image: string;
  type: 'sell' | 'buy';
}

export interface CropPrice {
  crop: string;
  min: number;
  max: number;
  trend: 'up' | 'down' | 'stable';
}

export interface WeatherData {
  temp: number;
  condition: string;
  humidity: number;
  windSpeed: number;
  location: string;
}
