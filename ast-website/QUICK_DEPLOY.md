# 🚀 Quick Deploy to Vercel (Easiest Method)

## Step-by-Step Instructions

### 1️⃣ Install Vercel CLI
Open PowerShell and run:
```powershell
npm install -g vercel
```

### 2️⃣ Login to Vercel
```powershell
vercel login
```
This will open your browser - sign up/login with GitHub

### 3️⃣ Deploy Your Website
```powershell
cd C:\Users\zam\OneDrive\Documents\GitHub\Agro-Smart-Technology-AST-\ast-website
vercel
```

Follow the prompts:
- Set up and deploy? **Y**
- Which scope? **Your account**
- Link to existing project? **N**
- What's your project's name? **agro-smart-technology**
- In which directory is your code located? **./  (press Enter)**
- Want to override settings? **N**

### 4️⃣ Add Environment Variables
After first deployment, add your API keys:

```powershell
vercel env add REACT_APP_GEMINI_API_KEY
```
Paste: `AIzaSyD97jvMjFON3nDE3E0JcZzC8Wgkqg0HGKA`

```powershell
vercel env add REACT_APP_OPENAI_API_KEY
```
Paste your OpenAI key

```powershell
vercel env add REACT_APP_OPENWEATHER_API_KEY
```
Paste your OpenWeather key

### 5️⃣ Deploy to Production
```powershell
vercel --prod
```

### ✅ Done! 
Your website is now live at: `https://agro-smart-technology.vercel.app`

---

## 📱 Test on Mobile

1. Open your phone's browser (Chrome/Safari)
2. Visit your live URL
3. Test features:
   - ✅ Hamburger menu works
   - ✅ All buttons are touch-friendly
   - ✅ Text is readable
   - ✅ Forms work properly
   - ✅ Footer displays correctly

---

## 🔗 Share Your Website

**For WhatsApp/SMS:**
```
🌾 Check out AST - Agro Smart Technology!

Our FYP project: AI-powered farming assistant for Pakistani farmers 

👉 https://agro-smart-technology.vercel.app

Works on all devices! 📱💻

- Syed Shah & Abdul Rehman
  UMT Lahore, FYP 2024-25
```

**For Email to Teacher:**
```
Subject: AST Website - FYP Deployment

Dear Miss Saima Safdar,

We are pleased to inform you that our Final Year Project website "Agro Smart Technology (AST)" is now live and accessible:

🌐 Live Website: https://agro-smart-technology.vercel.app

The website features:
✅ Voice Q&A in Urdu for farmers
✅ AI-powered crop disease detection
✅ Real-time Mandi rates with Gemini AI
✅ Weather forecasts
✅ Digital farmer marketplace
✅ Fully responsive (works on mobile & desktop)

Technology Stack:
- Frontend: React.js + Material-UI
- AI: Google Gemini 2.5 Flash, OpenAI GPT-4
- ML: TensorFlow.js for disease detection
- Backend: Node.js + Firebase

The website has been optimized for mobile devices and tested on various screen sizes. Please feel free to explore and provide your valuable feedback.

Best regards,
Syed Shah Hussain (S2024387008)
Malik Abdul Rehman (S2024387002)

The College of Art, Science & Technology
University of Management & Technology, Lahore
```

---

## 🎯 Alternative: One-Click Deploy

### Vercel Dashboard Method:

1. Go to https://vercel.com/new
2. Import from GitHub: Select "Agro-Smart-Technology-AST-"
3. Root Directory: `ast-website`
4. Framework Preset: Create React App (auto-detected)
5. Build Command: `npm run build`
6. Output Directory: `build`
7. Click "Deploy"

---

## 📊 Monitor Your Website

After deployment, you can:
- View analytics in Vercel dashboard
- See deployment logs
- Monitor performance
- Track visitor statistics

---

## 🔄 Update Your Website

Whenever you make changes:

```powershell
cd C:\Users\zam\OneDrive\Documents\GitHub\Agro-Smart-Technology-AST-\ast-website
git add .
git commit -m "Updated website"
git push origin main
```

Vercel will automatically redeploy! 🎉

---

## 🆘 Troubleshooting

**Issue: Command not found**
```powershell
npm install -g vercel --force
```

**Issue: Authentication failed**
```powershell
vercel logout
vercel login
```

**Issue: Build fails**
Check `.env` variables are set in Vercel dashboard

**Issue: 404 errors**
Already fixed with `vercel.json` configuration

---

## 📞 Need Help?

Contact:
- Syed Shah: syedshahh1214@gmail.com
- Abdul Rehman: malikabdulrehman964@gmail.com

Vercel Support: https://vercel.com/support
