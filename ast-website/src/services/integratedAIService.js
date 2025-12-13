// Integrated AI Service - Combines OpenAI, Gemini, and OpenWeather APIs
// All API keys are now loaded from environment variables

const OPENAI_API_KEY = process.env.REACT_APP_OPENAI_API_KEY;
const GEMINI_API_KEY = process.env.REACT_APP_GEMINI_API_KEY;
const OPENWEATHER_API_KEY = process.env.REACT_APP_OPENWEATHER_API_KEY;

// Check if all APIs are configured
export const checkAPIConfiguration = () => {
  return {
    openai: !!OPENAI_API_KEY && OPENAI_API_KEY !== 'your_openai_api_key_here',
    gemini: !!GEMINI_API_KEY && GEMINI_API_KEY !== 'your_gemini_api_key_here',
    openweather: !!OPENWEATHER_API_KEY && OPENWEATHER_API_KEY !== 'your_openweather_api_key_here'
  };
};

// Integrated query that uses the best available AI service
export const integratedQuery = async (query, options = {}) => {
  const {
    conversationHistory = [],
    city = 'Lahore',
    preferGPT = true,
    includeWeather = false
  } = options;

  try {
    // Get weather data if requested
    let weatherContext = '';
    if (includeWeather && OPENWEATHER_API_KEY) {
      try {
        const weatherResponse = await fetch(
          `https://api.openweathermap.org/data/2.5/weather?q=${city},pk&appid=${OPENWEATHER_API_KEY}&units=metric`
        );
        if (weatherResponse.ok) {
          const weatherData = await weatherResponse.json();
          weatherContext = `\n\nCurrent weather in ${city}: ${weatherData.main.temp}°C, ${weatherData.weather[0].description}, humidity: ${weatherData.main.humidity}%`;
        }
      } catch (error) {
        console.warn('Weather API unavailable:', error);
      }
    }

    // Build system prompt with weather context
    const systemPrompt = `You are an expert agricultural AI assistant for Pakistani farmers. You provide practical, actionable advice about:
- Crop cultivation (Cotton, Rice, Wheat, Sugarcane, Maize)
- Pest and disease management
- Fertilizer recommendations
- Irrigation practices
- Market trends
- Weather-based farming decisions

Respond in a mix of English and Urdu as appropriate. Be concise but thorough. Include practical tips that farmers can immediately apply.${weatherContext}`;

    // Try OpenAI GPT first if preferred and available
    if (preferGPT && OPENAI_API_KEY) {
      try {
        const messages = [
          { role: 'system', content: systemPrompt },
          ...conversationHistory,
          { role: 'user', content: query }
        ];

        const response = await fetch('https://api.openai.com/v1/chat/completions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${OPENAI_API_KEY}`
          },
          body: JSON.stringify({
            model: 'gpt-4o-mini',
            messages: messages,
            temperature: 0.7,
            max_tokens: 500
          })
        });

        if (response.ok) {
          const data = await response.json();
          return {
            response: data.choices[0].message.content,
            source: 'openai',
            weatherIncluded: includeWeather
          };
        }
      } catch (error) {
        console.warn('OpenAI API failed, falling back to Gemini:', error);
      }
    }

    // Fallback to Gemini if OpenAI unavailable or failed
    if (GEMINI_API_KEY) {
      try {
        const prompt = `${systemPrompt}\n\nUser: ${query}\n\nAssistant:`;
        
        const response = await fetch(
          `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=${GEMINI_API_KEY}`,
          {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              contents: [{
                parts: [{ text: prompt }]
              }]
            })
          }
        );

        if (response.ok) {
          const data = await response.json();
          return {
            response: data.candidates[0].content.parts[0].text,
            source: 'gemini',
            weatherIncluded: includeWeather
          };
        }
      } catch (error) {
        console.error('Gemini API failed:', error);
      }
    }

    // If all APIs fail, return error
    throw new Error('All AI services are unavailable. Please check your API keys and internet connection.');

  } catch (error) {
    console.error('Integrated query failed:', error);
    return {
      response: `Error: ${error.message}. Please ensure your API keys are configured correctly in the environment variables.`,
      source: 'error',
      weatherIncluded: false
    };
  }
};

export default { integratedQuery, checkAPIConfiguration };
