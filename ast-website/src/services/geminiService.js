// Gemini AI Service for Voice Q&A
const GEMINI_API_KEY = process.env.REACT_APP_GEMINI_API_KEY;
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=${GEMINI_API_KEY}`;

export const sendToGemini = async (query, conversationHistory = []) => {
  try {
    const systemPrompt = `You are AgriVoice AI, an expert agricultural assistant for Pakistani farmers.

Context: Pakistan, Urdu/English speaking farmers.
User Question: ${query}

Provide a concise, practical answer in simple Urdu/English. If asked about weather or crop prices, use real-time data and structure your response clearly.

Answer:`;

    const response = await fetch(GEMINI_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        contents: [
          {
            parts: [{ text: systemPrompt }]
          }
        ],
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 500,
        }
      }),
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }

    const data = await response.json();
    
    if (!data.candidates || data.candidates.length === 0) {
      throw new Error('No response from AI');
    }

    const answer = data.candidates[0].content.parts[0].text;
    return { success: true, answer };
  } catch (error) {
    console.error('Gemini API Error:', error);
    return { 
      success: false, 
      error: error.message,
      answer: 'Sorry, I encountered an error. Please try again.'
    };
  }
};

// Parse response for structured data (weather, crop prices)
export const parseResponseForDashboard = (response) => {
  const data = {
    weather: null,
    cropRates: []
  };

  // Extract temperature
  const tempMatch = response.match(/(\d+)°[CF]/);
  const humidityMatch = response.match(/(\d+)%\s*humidity/i);
  
  if (tempMatch || humidityMatch) {
    data.weather = {
      temp: tempMatch ? `${tempMatch[1]}°C` : '--',
      humidity: humidityMatch ? `${humidityMatch[1]}%` : '--',
      condition: 'Updated from AI'
    };
  }

  // Extract crop prices (e.g., "Wheat: Rs 3500")
  const priceMatches = response.matchAll(/(\w+):\s*Rs\s*(\d+)/gi);
  for (const match of priceMatches) {
    data.cropRates.push({
      name: match[1],
      price: `Rs ${match[2]}`,
      trend: 'stable'
    });
  }

  return data;
};
