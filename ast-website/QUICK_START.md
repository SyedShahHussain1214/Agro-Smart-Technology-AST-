# Quick Start Guide - AST Website

## 🚀 Get Started in 5 Minutes

### Step 1: Open Terminal
```bash
cd c:\Users\zam\OneDrive\Documents\GitHub\Agro-Smart-Technology-AST-\ast-website
```

### Step 2: Install Dependencies (if not done)
```bash
npm install
```

### Step 3: Start Development Server
```bash
npm start
```

The website will automatically open at **http://localhost:3000**

## 🎯 Test All Features

### 1. Homepage
- ✅ Scroll through sections
- ✅ Click feature cards to navigate
- ✅ Test contact form

### 2. Voice Q&A (`/voice-qa`)
- ✅ Click mic button
- ✅ Speak in Urdu or English
- ✅ Watch AI respond
- ✅ Check dashboard updates
- **Requirements:** Microphone permission

### 3. Disease Detection (`/disease-detection`)
- ✅ Upload a leaf image
- ✅ View disease identification
- ✅ Read treatment recommendations

### 4. Weather Forecast (`/weather`)
- ✅ Select city (Lahore/Faisalabad/Multan)
- ✅ View current weather
- ✅ Check 5-day forecast
- **Note:** Add API key for real data

### 5. Mandi Rates (`/mandi-rates`)
- ✅ Browse crop prices
- ✅ Filter by city
- ✅ Search crops
- ✅ View price trends

### 6. Marketplace (`/marketplace`)
- ✅ Browse listings
- ✅ Filter (All/Selling/Buying)
- ✅ Create new listing
- ✅ Contact sellers

## 🔑 Add API Keys (Optional)

### Create `.env` file:
```bash
REACT_APP_GEMINI_API_KEY=AIzaSyCMiwIbXChxDow0QyVzAbyoSFUSi8q5pC8
REACT_APP_WEATHER_API_KEY=your-openweathermap-key
```

### Get Weather API Key:
1. Go to https://openweathermap.org/api
2. Sign up free
3. Copy API key
4. Add to `.env`

## 📱 Features Comparison

| Feature | Status | Notes |
|---------|--------|-------|
| Voice Q&A | ✅ Working | Using Gemini AI |
| Disease Detection | 🟡 Demo | Mock data, ready for model |
| Weather | ✅ Working | Add API key for real data |
| Mandi Rates | 🟡 Demo | Mock data |
| Marketplace | 🟡 Demo | Mock data |

Legend:
- ✅ Fully functional
- 🟡 Demo with mock data
- ❌ Not available

## 🎨 What's New vs Original Website

### Enhanced:
1. **Hero Section**
   - Animated gradient text
   - Pulsing background
   - Stats cards
   - Better CTAs

2. **Features**
   - Clickable navigation
   - Hover animations
   - Icon effects
   - Live pages

3. **Functionality**
   - Real AI integration
   - Voice recognition
   - Image upload
   - Search/filter

4. **Structure**
   - Components folder
   - Services folder
   - Routing system
   - API integration

## 🐛 Troubleshooting

### Website not starting?
```bash
# Clear cache
rm -rf node_modules
npm install
npm start
```

### Voice Q&A not working?
- Allow microphone permission
- Use Chrome/Edge browser
- Check API key in `.env`

### Weather not showing real data?
- Add OpenWeatherMap API key
- Check internet connection

## 📦 Build for Production

```bash
npm run build
```

Output will be in `build/` folder - ready to deploy!

## 🌐 Deploy

### Vercel (Recommended):
```bash
npm i -g vercel
vercel
```

### Netlify:
```bash
npm i -g netlify-cli
netlify deploy --prod
```

## 🎯 Quick Navigation

- **Homepage:** http://localhost:3000
- **Voice Q&A:** http://localhost:3000/voice-qa
- **Disease Detection:** http://localhost:3000/disease-detection
- **Weather:** http://localhost:3000/weather
- **Mandi Rates:** http://localhost:3000/mandi-rates
- **Marketplace:** http://localhost:3000/marketplace

## 💡 Tips

1. **Use Chrome/Edge** for best Web Speech API support
2. **Allow microphone** for Voice Q&A
3. **Upload clear images** for disease detection
4. **Test all cities** in weather and mandi rates
5. **Try search** in both English and Urdu

## 🆘 Need Help?

Check these files:
- `README_WEBSITE.md` - Full documentation
- `IMPLEMENTATION_COMPLETE.md` - Technical details
- `.env.example` - API key template

---

**Enjoy the fully functional Agro Smart Technology website! 🌾**
