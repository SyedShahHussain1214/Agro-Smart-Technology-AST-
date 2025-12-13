export interface WeatherData {
  temp: string;
  condition: string;
  humidity: string;
}

export interface CropData {
  name: string;
  price: string;
  trend: 'up' | 'down' | 'stable';
}

export interface DashboardData {
  weather: WeatherData;
  crops: CropData[];
}

export interface GroundingSource {
  title: string;
  uri: string;
}

export interface ToolCallResponse {
  tool: string;
  result: any;
}
