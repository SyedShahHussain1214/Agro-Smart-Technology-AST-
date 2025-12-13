# 🚀 Quick Deploy to Vercel

## Option 1: Deploy via Dashboard (5 minutes)

1. **Go to:** https://vercel.com/new
2. **Import Git Repository:** Select `Agro-Smart-Technology-AST-`
3. **Root Directory:** `ast-website`
4. **Add Environment Variables:**
   ```
   REACT_APP_GEMINI_API_KEY = your_key_here
   REACT_APP_OPENWEATHER_API_KEY = your_key_here
   REACT_APP_OPENAI_API_KEY = your_key_here
   ```
5. **Click Deploy** ✅

## Option 2: Deploy via CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Navigate to website
cd ast-website

# Deploy
vercel

# Add environment variables
vercel env add REACT_APP_GEMINI_API_KEY production
vercel env add REACT_APP_OPENWEATHER_API_KEY production
vercel env add REACT_APP_OPENAI_API_KEY production

# Deploy to production
vercel --prod
```

---

## After Deployment

Your site will be live at: `https://your-project.vercel.app`

**Test these features:**
- ✅ Voice Q&A
- ✅ Disease Detection
- ✅ Weather Forecast
- ✅ Mandi Rates

---

**Need detailed instructions?** See [VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md)

**Get your API keys:**
- Gemini: https://ai.google.dev/
- OpenWeather: https://openweathermap.org/api
- OpenAI: https://platform.openai.com/api-keys
