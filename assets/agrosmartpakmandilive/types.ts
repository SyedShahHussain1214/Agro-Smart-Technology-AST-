export interface MarketItem {
  id: string;
  name: string;
  category: 'Vegetable' | 'Fruit' | 'Grain' | 'Other';
  city: string;
  minPrice: number;
  maxPrice: number;
  unit: string;
  trend: 'up' | 'down' | 'stable';
  lastUpdated: string;
}

export interface MarketResponse {
  items: MarketItem[];
  sources: string[];
}

export enum City {
  Lahore = 'Lahore',
  Karachi = 'Karachi',
  Islamabad = 'Islamabad',
  Multan = 'Multan',
  Faisalabad = 'Faisalabad',
  Peshawar = 'Peshawar'
}

export const CITIES = Object.values(City);

export interface FilterState {
  city: string;
  search: string;
}