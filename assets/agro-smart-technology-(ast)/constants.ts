import { CropPrice, MarketItem, WeatherData } from "./types";

export const MOCK_WEATHER: WeatherData = {
  temp: 32,
  condition: "Sunny",
  humidity: 45,
  windSpeed: 12,
  location: "Rahim Yar Khan, Punjab"
};

export const MOCK_PRICES: CropPrice[] = [
  { crop: "Wheat (Gandum)", min: 3900, max: 4200, trend: 'up' },
  { crop: "Cotton (Kapas)", min: 8500, max: 9200, trend: 'down' },
  { crop: "Rice (Super Basmati)", min: 5500, max: 6000, trend: 'stable' },
  { crop: "Sugarcane (Ganna)", min: 400, max: 450, trend: 'up' },
  { crop: "Maize (Makayi)", min: 2200, max: 2400, trend: 'stable' },
];

export const MOCK_MARKET_ITEMS: MarketItem[] = [
  {
    id: '1',
    name: 'Fresh Potato (Aloo)',
    price: 80,
    unit: 'kg',
    seller: 'Abdul Rehman',
    location: 'Lahore',
    image: 'https://picsum.photos/200/200?random=1',
    type: 'sell'
  },
  {
    id: '2',
    name: 'Fertilizer (DAP)',
    price: 12500,
    unit: 'bag',
    seller: 'Agro Traders',
    location: 'Multan',
    image: 'https://picsum.photos/200/200?random=2',
    type: 'sell'
  },
  {
    id: '3',
    name: 'Tractor Rental',
    price: 2500,
    unit: 'hour',
    seller: 'Hamza Farms',
    location: 'Faisalabad',
    image: 'https://picsum.photos/200/200?random=3',
    type: 'sell'
  }
];

export const SYSTEM_INSTRUCTION = `
You are 'Agro Smart Assistant', an expert agricultural AI designed for Pakistani farmers. 
Your goal is to help smallholder farmers with low literacy.

Key Responsibilities:
1. Pest & Disease Identification: Analyze images of crops and identify diseases. Suggest organic (IPM) and chemical remedies available in Pakistan.
2. Farming Advice: Give advice on wheat, cotton, rice, sugarcane, and maize.
3. Market Information: Provide current market prices (Mandi Rates) when asked, using the supplied context.
4. Language: Respond in simple English or Roman Urdu (Urdu written in English script). Keep answers concise and easy to read/listen to.
5. Empathy: Be encouraging and respectful.

Context:
- Location: Pakistan (Punjab/Sindh focus).
- Currency: PKR (Rupees).
- Units: Maund (40kg), Acre.

If the user greets you, welcome them to AST (Agro Smart Technology) and ask how you can help with their crops today.
`;