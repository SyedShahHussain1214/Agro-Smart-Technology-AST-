# Agro Smart Technology - Website

A fully functional web application for Pakistani farmers featuring AI-powered agricultural assistance, real-time market rates, weather forecasts, and more.

## 🚀 Features

### 1. **Voice Q&A in Urdu** (`/voice-qa`)
- Real-time voice recognition in Urdu
- AI-powered responses using Gemini API
- Text-to-speech in Urdu
- Conversation history
- Dashboard with weather and crop price updates

### 2. **AI Crop Disease Detection** (`/disease-detection`)
- Upload crop photos for instant disease identification
- Support for Cotton, Rice, Wheat, and Sugarcane
- Detailed disease information with symptoms and treatment
- Confidence scoring and severity levels

### 3. **Real-Time Mandi Rates** (`/mandi-rates`)
- Live market prices from Lahore, Faisalabad, and Multan
- Price trends (up/down/stable)
- City-wise filtering
- Search functionality in English and Urdu

### 4. **Weather Forecast** (`/weather`)
- Current weather conditions
- 5-day forecast
- City selection (Lahore, Faisalabad, Multan)
- Farming tips based on weather

### 5. **Digital Farmer Marketplace** (`/marketplace`)
- Direct buyer-seller connections
- Create listings for selling or buying crops
- Contact sellers/buyers directly
- Search and filter functionality

## 📁 Project Structure

```
ast-website/
├── public/
│   ├── images/                 # Feature images
│   └── index.html
├── src/
│   ├── components/             # React components
│   │   ├── VoiceQA.js
│   │   ├── DiseaseDetection.js
│   │   ├── Weather.js
│   │   ├── MandiRates.js
│   │   └── Marketplace.js
│   ├── services/               # API services
│   │   ├── geminiService.js    # Gemini AI integration
│   │   ├── weatherService.js   # OpenWeatherMap API
│   │   ├── mandiService.js     # Market rates
│   │   ├── diseaseDetectionService.js
│   │   └── marketplaceService.js
│   ├── App.js                  # Main app with routing
│   ├── App.css
│   └── index.js
├── .env.example                # Environment variables template
├── package.json
└── README.md
```

## 🛠️ Installation & Setup

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Steps

1. **Clone the repository**
   ```bash
   cd ast-website
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure API Keys**
   
   Create a `.env` file in the root directory:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your API keys:
   ```env
   REACT_APP_GEMINI_API_KEY=your-gemini-api-key
   REACT_APP_WEATHER_API_KEY=your-openweathermap-key
   ```

   **Get API Keys:**
   - Gemini AI: https://aistudio.google.com/apikey
   - OpenWeatherMap: https://openweathermap.org/api

4. **Start the development server**
   ```bash
   npm start
   ```
   
   The website will open at http://localhost:3000

## 🎨 Technologies Used

- **Frontend Framework:** React 19.2.0
- **UI Library:** Material-UI (MUI) 7.3.5
- **Routing:** React Router DOM 7.x
- **AI Integration:** Google Gemini API
- **Weather API:** OpenWeatherMap
- **Speech Recognition:** Web Speech API
- **Styling:** MUI System + Custom CSS

## 🌐 Available Routes

| Route | Component | Description |
|-------|-----------|-------------|
| `/` | HomePage | Landing page with all features |
| `/voice-qa` | VoiceQA | AI voice assistant |
| `/disease-detection` | DiseaseDetection | Crop disease identification |
| `/weather` | Weather | Weather forecast |
| `/mandi-rates` | MandiRates | Market price rates |
| `/marketplace` | Marketplace | Buy/sell marketplace |

## 📱 Features Implementation

### Voice Q&A
- Uses Web Speech API for speech recognition
- Gemini API for AI responses
- Web Speech Synthesis for text-to-speech
- Real-time conversation updates

### Disease Detection
- Image upload and preview
- Mock TensorFlow.js integration (ready for model)
- Disease database with treatments
- Severity indicators

### Weather Forecast
- OpenWeatherMap API integration
- 5-day forecast
- Multiple city support
- Farming recommendations

### Mandi Rates
- Mock data (ready for real API)
- Real-time price updates
- Trend indicators
- Multi-city support

### Marketplace
- Create listings
- Search and filter
- Direct contact functionality
- Image support

## 🔧 Customization

### Adding New Features
1. Create component in `src/components/`
2. Create service in `src/services/`
3. Add route in `App.js`
4. Add to features list on homepage

### Styling
- Modify `App.css` for global styles
- Use MUI's `sx` prop for component-specific styles
- Primary color: `#28a745` (green)

## 📦 Building for Production

```bash
npm run build
```

This creates an optimized production build in the `build/` folder.

## 🚀 Deployment

### Vercel
```bash
npm install -g vercel
vercel
```

### Netlify
```bash
npm install -g netlify-cli
netlify deploy --prod
```

### Manual Deployment
1. Run `npm run build`
2. Upload `build/` folder to your web server
3. Configure server to serve `index.html` for all routes

## 🔐 Security Notes

- Never commit `.env` file with real API keys
- Keep API keys in environment variables
- Use backend proxy for sensitive API calls in production
- Implement rate limiting for API requests

## 📝 API Integration Status

| Feature | Status | API/Service |
|---------|--------|-------------|
| Voice Q&A | ✅ Active | Gemini AI |
| Disease Detection | 🔄 Mock Data | Ready for TensorFlow.js |
| Weather | ✅ Active | OpenWeatherMap |
| Mandi Rates | 🔄 Mock Data | Ready for real API |
| Marketplace | 🔄 Mock Data | Ready for Firebase/Backend |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is developed for Agro Smart Technology by:
- Syed Shah Hussain
- Malik Abdul Rehman
- University of Management & Technology, Lahore

## 🆘 Support

For issues and questions:
- Open an issue on GitHub
- Contact: [Add contact information]

## 🎯 Roadmap

- [ ] Integrate real TensorFlow.js model for disease detection
- [ ] Connect to real mandi rates API
- [ ] Add Firebase authentication
- [ ] Implement real-time marketplace with Firebase
- [ ] Add push notifications
- [ ] Mobile app synchronization
- [ ] Multi-language support (expand beyond Urdu/English)
- [ ] Offline functionality with service workers

---

**Note:** The Gemini API key included is for demo purposes. Replace with your own key for production use.
