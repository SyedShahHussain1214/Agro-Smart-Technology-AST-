# Agro Smart Technology (AST) - Setup Guide

This guide will help you set up the project for development on your local machine.

## Prerequisites

Before you begin, make sure you have the following installed:

- **Git with Git LFS** (Large File Storage)
- **Flutter SDK** (for mobile app development)
- **Node.js** (v16 or higher, for website development)
- **npm** or **yarn** (comes with Node.js)

## Step 1: Clone the Repository

**Important:** You MUST have Git LFS installed before cloning!

```bash
# Install Git LFS (if not already installed)
git lfs install

# Clone the repository
git clone https://github.com/SyedShahHussain1214/Agro-Smart-Technology-AST-.git

# Navigate to the project directory
cd Agro-Smart-Technology-AST-
```

Git LFS will automatically download all large model files (54,000+ files, ~1.5GB).

## Step 2: Set Up API Keys

This project requires API keys from three services:

### 🔑 Required API Keys

1. **Google Gemini API** (Free tier available)
   - Visit: https://ai.google.dev/
   - Create a project and enable Gemini API
   - Copy your API key

2. **OpenWeatherMap API** (Free tier available)
   - Visit: https://openweathermap.org/api
   - Sign up and get your API key
   - Copy your API key

3. **OpenAI API** (Paid, optional for some features)
   - Visit: https://platform.openai.com/api-keys
   - Create an API key
   - Copy your API key

---

## Website Setup (React App)

### 1. Navigate to the website folder

```bash
cd ast-website
```

### 2. Install dependencies

```bash
npm install
```

### 3. Create environment file

```bash
# Copy the example file
cp .env.example .env

# Or on Windows PowerShell:
Copy-Item .env.example .env
```

### 4. Edit the .env file

Open the `.env` file and replace the placeholder values with your actual API keys:

```env
REACT_APP_GEMINI_API_KEY=your_actual_gemini_api_key_here
REACT_APP_OPENWEATHER_API_KEY=your_actual_openweather_api_key_here
REACT_APP_OPENAI_API_KEY=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
```

**⚠️ Important:** Never commit the `.env` file! It's already in `.gitignore`.

### 5. Start the development server

```bash
npm start
```

The website will open at http://localhost:3000

---

## Flutter App Setup

### 1. Navigate back to the root directory

```bash
cd ..  # if you're in ast-website folder
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Run the app with API keys

You need to pass API keys as build arguments:

```bash
flutter run \
  --dart-define=OPENWEATHER_API_KEY=your_openweather_api_key \
  --dart-define=GEMINI_API_KEY=your_gemini_api_key \
  --dart-define=OPENAI_API_KEY=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
```

**For Windows PowerShell (no backslashes):**

```powershell
flutter run --dart-define=OPENWEATHER_API_KEY=your_openweather_api_key --dart-define=GEMINI_API_KEY=your_gemini_api_key --dart-define=OPENAI_API_KEY=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
```

### 4. Create a launch configuration (Optional but recommended)

Create `.vscode/launch.json` in the root directory:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "AST - Debug",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=OPENWEATHER_API_KEY=your_openweather_api_key",
        "--dart-define=GEMINI_API_KEY=your_gemini_api_key",
        "--dart-define=OPENAI_API_KEY=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"
      ]
    }
  ]
}
```

Replace the placeholder keys with your actual keys. This file is also gitignored for security.

---

## Troubleshooting

### Git LFS Issues

If models are not downloading:

```bash
git lfs pull
```

### Website Not Loading

1. Make sure you're in the `ast-website` folder
2. Check if `.env` file exists and has valid API keys
3. Try deleting `node_modules` and running `npm install` again

### Flutter Build Errors

1. Run `flutter clean`
2. Run `flutter pub get`
3. Make sure you're passing all three API keys as `--dart-define` arguments

### API Key Errors

If you see errors like "API key missing" or "401 Unauthorized":

1. Double-check your API keys are correct
2. Ensure the API keys are not expired
3. Verify you've enabled the correct APIs in Google Cloud Console (for Gemini)
4. Check your API quotas haven't been exceeded

---

## Security Best Practices

✅ **DO:**
- Keep your `.env` files local (they're in `.gitignore`)
- Use environment variables for all API keys
- Regenerate API keys if they're accidentally committed
- Share API keys securely with team members (use password managers)

❌ **DON'T:**
- Commit `.env` files to Git
- Share API keys in public channels
- Hardcode API keys in source code
- Push `.vscode/launch.json` if it contains API keys

---

## Getting Help

If you encounter issues:

1. Check the error message carefully
2. Verify all API keys are set correctly
3. Make sure Git LFS is installed and working
4. Contact the team lead

---

## Project Structure

```
├── lib/                    # Flutter app source code
├── ast-website/            # React website
│   ├── src/
│   ├── .env.example       # API key template
│   └── .env               # Your API keys (not committed)
├── assets/                 # App assets and models
│   └── models/            # ML models (tracked with Git LFS)
├── android/               # Android build files
└── ios/                   # iOS build files
```

---

## Next Steps

Once everything is set up:

1. Test the website by visiting http://localhost:3000
2. Test the Flutter app on your device/emulator
3. Start developing! 🚀

Happy coding! 🌾
