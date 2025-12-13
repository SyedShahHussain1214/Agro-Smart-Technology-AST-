# Quick Reference - API Keys Setup

## For Website Developers

```bash
# 1. Navigate to website folder
cd ast-website

# 2. Copy the template
cp .env.example .env

# 3. Edit .env and add your keys:
REACT_APP_GEMINI_API_KEY=your_key_here
REACT_APP_OPENWEATHER_API_KEY=your_key_here
REACT_APP_OPENAI_API_KEY=your_key_here

# 4. Start development
npm install
npm start
```

## For Flutter App Developers

```bash
# Run with API keys
flutter run --dart-define=OPENWEATHER_API_KEY=your_key --dart-define=GEMINI_API_KEY=your_key --dart-define=OPENAI_API_KEY=your_key
```

## Get Your API Keys Here:

- **Gemini:** https://ai.google.dev/
- **OpenWeather:** https://openweathermap.org/api
- **OpenAI:** https://platform.openai.com/api-keys

---

**Need detailed instructions?** See [SETUP.md](SETUP.md)
