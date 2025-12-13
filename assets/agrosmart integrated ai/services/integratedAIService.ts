import { GoogleGenAI } from "@google/genai";
import { ApiConfig, WeatherData, Language } from "../types";

// Helper to check if keys are configured
export const checkApiStatus = (config: ApiConfig) => {
  return {
    openai: !!config.openaiKey && config.openaiKey.startsWith('sk-'),
    gemini: !!config.geminiKey, // Gemini keys vary, just check existence
    weather: !!config.openWeatherKey,
  };
};

// 1. OpenWeather Service
export const fetchWeather = async (city: string, apiKey: string): Promise<WeatherData | null> => {
  if (!apiKey) return null;
  try {
    const response = await fetch(
      `https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${apiKey}`
    );
    if (!response.ok) throw new Error('Weather API failed');
    const data = await response.json();
    return {
      temp: data.main.temp,
      humidity: data.main.humidity,
      description: data.weather[0].description,
      city: data.name,
      icon: data.weather[0].icon,
    };
  } catch (error) {
    console.warn("Weather fetch failed:", error);
    return null;
  }
};

// 2. Gemini Service (using @google/genai)
export const queryGemini = async (prompt: string, apiKey: string, modelName: string = 'gemini-2.5-flash'): Promise<string> => {
  if (!apiKey) throw new Error("Gemini Key missing");
  
  const ai = new GoogleGenAI({ apiKey });
  
  try {
    const response = await ai.models.generateContent({
      model: modelName,
      contents: prompt,
    });
    return response.text || "No response from Gemini.";
  } catch (error) {
    console.error("Gemini Error:", error);
    throw error;
  }
};

export const analyzeImageWithGemini = async (
  base64Image: string, 
  apiKey: string,
  language: Language = 'en'
): Promise<string> => {
  if (!apiKey) throw new Error("Gemini Key missing");

  const ai = new GoogleGenAI({ apiKey });
  
  const promptEn = `
    Analyze this crop leaf image. Identify:
    1. The crop name.
    2. Any disease present (or verify if healthy).
    3. List 3 key symptoms observed.
    4. Recommend 3 treatment steps or preventative measures.
    Format the output as a clear Markdown list.
  `;

  const promptUr = `
    اس فصل کے پتے کی تصویر کا تجزیہ کریں۔ شناخت کریں:
    1. فصل کا نام۔
    2. کوئی بیماری موجود ہے (یا تصدیق کریں کہ صحت مند ہے)۔
    3. دیکھی گئی 3 اہم علامات کی فہرست بنائیں۔
    4. 3 علاج کے اقدامات یا حفاظتی تدابیر تجویز کریں۔
    آؤٹ پٹ کو واضح مارک ڈاؤن لسٹ کے طور پر فارمیٹ کریں۔ جواب اردو میں دیں۔
  `;

  const prompt = language === 'ur' ? promptUr : promptEn;

  try {
    // Remove header if present in base64 string
    const cleanBase64 = base64Image.split(',')[1] || base64Image;

    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash-image', // Specialized model for vision
      contents: {
        parts: [
          {
            inlineData: {
              mimeType: 'image/jpeg', // Assuming jpeg for simplicity, or detect from input
              data: cleanBase64
            }
          },
          { text: prompt }
        ]
      }
    });

    return response.text || "Could not analyze image.";
  } catch (error) {
    console.error("Gemini Vision Error:", error);
    throw new Error("Failed to analyze image with Gemini.");
  }
};

// 3. OpenAI Service (using fetch to keep it lightweight)
export const queryOpenAI = async (messages: any[], apiKey: string): Promise<string> => {
  if (!apiKey) throw new Error("OpenAI Key missing");

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`
    },
    body: JSON.stringify({
      model: 'gpt-4', // As requested in doc
      messages: messages,
      temperature: 0.7
    })
  });

  if (!response.ok) {
    const err = await response.json();
    throw new Error(err.error?.message || "OpenAI API failed");
  }

  const data = await response.json();
  return data.choices[0].message.content;
};

// 4. Integrated Service (The "Brain")
export const integratedQuery = async (
  userQuery: string,
  history: any[],
  config: ApiConfig,
  location: string = 'Lahore',
  language: Language = 'en'
): Promise<{ text: string; source: 'OpenAI' | 'Gemini' | 'OpenWeather' }> => {
  
  let weatherContext = "";
  
  // Step 1: Try to fetch weather if configured
  if (config.openWeatherKey) {
    const weather = await fetchWeather(location, config.openWeatherKey);
    if (weather) {
      weatherContext = `Current weather in ${location}: ${weather.temp}°C, ${weather.description}, Humidity ${weather.humidity}%. Use this for agricultural advice.`;
    }
  }

  const langInstruction = language === 'ur' 
    ? "You must reply strictly in Urdu language (اردو). Use simple, rural Urdu terms suitable for Pakistani farmers." 
    : "Reply in English.";

  const systemPrompt = `You are an expert agricultural assistant named AgroSmart. 
  ${weatherContext}
  Provide concise, practical farming advice. If the user asks about crops, use the weather context to be specific.
  ${langInstruction}`;

  const messages = [
    { role: 'system', content: systemPrompt },
    ...history,
    { role: 'user', content: userQuery }
  ];

  // Step 2: Try OpenAI (Primary)
  if (config.openaiKey) {
    try {
      const response = await queryOpenAI(messages, config.openaiKey);
      return { text: response, source: 'OpenAI' };
    } catch (openaiError) {
      console.warn("OpenAI failed, falling back to Gemini...", openaiError);
    }
  }

  // Step 3: Fallback to Gemini
  if (config.geminiKey) {
    try {
      // Combine messages for Gemini (simple prompt construction)
      const fullPrompt = `${systemPrompt}\n\nUser Question: ${userQuery}`;
      const response = await queryGemini(fullPrompt, config.geminiKey);
      return { text: response, source: 'Gemini' };
    } catch (geminiError) {
      console.error("Gemini also failed", geminiError);
      throw new Error("Both AI services are unavailable. Please check your API keys.");
    }
  }

  throw new Error("No AI API keys configured. Please add keys in Settings.");
};
