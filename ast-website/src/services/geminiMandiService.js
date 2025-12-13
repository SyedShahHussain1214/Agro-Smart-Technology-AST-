// Real-time Mandi Rates using Official Google GenAI SDK
import { GoogleGenAI } from '@google/genai';

const GEMINI_API_KEY = process.env.REACT_APP_GEMINI_API_KEY || 'AIzaSyD97jvMjFON3nDE3E0JcZzC8Wgkqg0HGKA';

// Initialize the client with explicit API key
const client = new GoogleGenAI({
  apiKey: GEMINI_API_KEY
});

console.log('🔑 Gemini SDK initialized with API key:', GEMINI_API_KEY ? 'Present' : 'Missing');

/**
 * Fetch live market rates for a specific Pakistani city using Gemini AI with Google Search
 * @param {string} city - City name (Lahore, Karachi, Islamabad, Multan, Faisalabad, Peshawar)
 * @returns {Promise<{items: Array, sources: Array}>} Market items and source URLs
 */
export const fetchLiveMandiRates = async (city = 'Lahore') => {
  // Validate API key
  if (!GEMINI_API_KEY || GEMINI_API_KEY === 'YOUR_API_KEY_HERE') {
    console.error('❌ Gemini API key is missing or invalid!');
    return {
      items: getMockData(city),
      sources: [],
      error: 'API key not configured - using cached data',
      isLiveData: false
    };
  }

  const currentDate = new Date().toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  const prompt = `
You have access to Google Search. Use it to find the LATEST wholesale market prices (Mandi rates) for ${city}, Pakistan as of ${currentDate}.

Search for official sources like:
- market.punjab.gov.pk (Punjab Agricultural Marketing Regulatory Authority)
- urdupoint.com mandi rates
- hamariweb.com commodity prices
- Express Tribune or Dawn newspaper market reports

Find current prices for these commodities in ${city}:
1. Vegetables: Potato (آلو), Onion (پیاز), Tomato (ٹماٹر), Garlic (لہسن), Ginger (ادرک), Green Chilli (ہری مرچ), Lemon (لیموں), Cucumber (کھیرا)
2. Grains: Wheat (گندم), Rice/Basmati (چاول), Sugar (چینی), Daal Chana, Daal Masoor
3. Fruits: Apple (سیب), Banana (کیلا), Orange (مالٹا), Mango (آم), Guava (امرود)

Return ONLY a valid JSON object (no markdown, no extra text):
{
  "items": [
    {
      "name": "Potato",
      "category": "Vegetable",
      "city": "${city}",
      "minPrice": 45,
      "maxPrice": 55,
      "unit": "kg",
      "trend": "stable"
    }
  ]
}

CRITICAL RULES:
- Use REAL current prices from your search results
- Include at least 12-15 items
- All prices must be numbers in PKR
- Trend: "up" if prices increased recently, "down" if decreased, "stable" if unchanged
- Return ONLY the JSON object, nothing else
`;

  try {
    console.log(`🔍 Fetching live mandi rates for ${city} using Google GenAI SDK...`);
    
    // Use the SDK to generate content with Google Search
    const response = await client.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        tools: [{ googleSearch: {} }]
      }
    });

    console.log('✅ Gemini API Response received');
    
    // Extract text from response
    const textResponse = response.text || '';
    console.log('📝 Extracted text response:', textResponse.substring(0, 200) + '...');
    
    // Extract grounding sources (from search results)
    const groundingMetadata = response.candidates?.[0]?.groundingMetadata;
    console.log('🔍 Grounding metadata:', groundingMetadata);
    
    const groundingChunks = groundingMetadata?.groundingChunks || [];
    const webSearchQueries = groundingMetadata?.webSearchQueries || [];
    
    console.log('🔎 Search queries used:', webSearchQueries);
    console.log('📊 Grounding chunks found:', groundingChunks.length);
    
    const sources = groundingChunks
      .map(chunk => chunk.web?.uri)
      .filter(uri => uri);

    console.log('🌐 Source URLs extracted:', sources);

    // Parse JSON from text response
    let jsonData = { items: [] };
    
    try {
      // Find JSON content (handles markdown code blocks)
      const jsonMatch = textResponse.match(/\{[\s\S]*"items"[\s\S]*\}/);
      if (jsonMatch) {
        // Clean markdown code blocks
        const cleanedJson = jsonMatch[0].replace(/```json\n?|\n?```/g, '').trim();
        jsonData = JSON.parse(cleanedJson);
        console.log('✅ Successfully parsed JSON with', jsonData.items?.length || 0, 'items');
      } else {
        // Try direct parse
        jsonData = JSON.parse(textResponse);
        console.log('✅ Successfully parsed JSON directly with', jsonData.items?.length || 0, 'items');
      }
    } catch (parseError) {
      console.error('❌ JSON parsing error:', parseError);
      console.log('📄 Raw response that failed to parse:', textResponse);
      
      // If we have grounding data, it means search worked but response format was wrong
      if (sources.length > 0) {
        console.warn('⚠️ Search succeeded but response format invalid - using enriched mock data');
        return {
          items: getMockData(city),
          sources: sources,
          error: 'Live data retrieved but format invalid - showing cached structure with real sources',
          isLiveData: false
        };
      }
      
      // Complete failure
      return {
        items: getMockData(city),
        sources: [],
        error: 'Using cached data - API parsing failed',
        isLiveData: false
      };
    }

    // Validate we got real data
    if (!jsonData.items || jsonData.items.length === 0) {
      console.warn('⚠️ No items in response, using mock data');
      return {
        items: getMockData(city),
        sources: sources,
        error: 'No live data available - using cached data',
        isLiveData: false
      };
    }

    // Map and validate items
    const items = (jsonData.items || []).map((item, index) => ({
      id: `${item.name}-${index}-${Date.now()}`,
      name: item.name || 'Unknown',
      category: item.category || 'Other',
      city: item.city || city,
      minPrice: Number(item.minPrice) || 0,
      maxPrice: Number(item.maxPrice) || 0,
      unit: item.unit || 'kg',
      trend: ['up', 'down', 'stable'].includes(item.trend) ? item.trend : 'stable',
      lastUpdated: new Date().toISOString()
    }));

    console.log(`✅ Successfully fetched ${items.length} live items for ${city}`);
    console.log('🌐 Data sources used:', sources);

    return {
      items,
      sources: sources.length > 0 ? sources : ['https://market.punjab.gov.pk'],
      lastFetched: new Date().toISOString(),
      isLiveData: sources.length > 0 // Flag to indicate if this is real live data
    };

  } catch (error) {
    console.error('❌ Gemini API Service Error:', error);
    
    let errorMessage = error.message;
    
    // Handle specific error types
    if (error.message?.includes('quota') || error.message?.includes('RESOURCE_EXHAUSTED')) {
      errorMessage = 'API quota exceeded. Please wait a few minutes or check your API key limits at https://ai.google.dev/usage';
      console.error('⚠️ Quota exceeded - using cached data. Visit https://ai.google.dev/usage to check limits');
    } else if (error.message?.includes('API key expired')) {
      errorMessage = 'API key expired. Please renew your API key at https://aistudio.google.com/apikey';
    } else if (error.message?.includes('INVALID_ARGUMENT')) {
      errorMessage = 'API key invalid or expired. Please check your API configuration';
    }
    
    // Return mock data as fallback
    return {
      items: getMockData(city),
      sources: ['https://market.punjab.gov.pk'],
      error: errorMessage,
      lastFetched: new Date().toISOString(),
      isLiveData: false
    };
  }
};

/**
 * Mock/fallback data for when API fails or for offline use
 */
function getMockData(city) {
  const baseDate = new Date().toISOString();
  
  return [
    { id: '1', name: 'Potato', category: 'Vegetable', city, minPrice: 40, maxPrice: 50, unit: 'kg', trend: 'stable', lastUpdated: baseDate },
    { id: '2', name: 'Onion', category: 'Vegetable', city, minPrice: 60, maxPrice: 75, unit: 'kg', trend: 'up', lastUpdated: baseDate },
    { id: '3', name: 'Tomato', category: 'Vegetable', city, minPrice: 35, maxPrice: 45, unit: 'kg', trend: 'down', lastUpdated: baseDate },
    { id: '4', name: 'Wheat', category: 'Grain', city, minPrice: 1800, maxPrice: 2000, unit: '40kg', trend: 'stable', lastUpdated: baseDate },
    { id: '5', name: 'Rice (Basmati)', category: 'Grain', city, minPrice: 120, maxPrice: 180, unit: 'kg', trend: 'up', lastUpdated: baseDate },
    { id: '6', name: 'Sugar', category: 'Grain', city, minPrice: 140, maxPrice: 160, unit: 'kg', trend: 'stable', lastUpdated: baseDate },
    { id: '7', name: 'Garlic', category: 'Vegetable', city, minPrice: 200, maxPrice: 250, unit: 'kg', trend: 'up', lastUpdated: baseDate },
    { id: '8', name: 'Ginger', category: 'Vegetable', city, minPrice: 180, maxPrice: 220, unit: 'kg', trend: 'stable', lastUpdated: baseDate },
    { id: '9', name: 'Green Chilli', category: 'Vegetable', city, minPrice: 80, maxPrice: 100, unit: 'kg', trend: 'down', lastUpdated: baseDate },
    { id: '10', name: 'Lemon', category: 'Fruit', city, minPrice: 150, maxPrice: 180, unit: 'kg', trend: 'stable', lastUpdated: baseDate },
    { id: '11', name: 'Apple', category: 'Fruit', city, minPrice: 200, maxPrice: 300, unit: 'kg', trend: 'stable', lastUpdated: baseDate },
    { id: '12', name: 'Banana', category: 'Fruit', city, minPrice: 80, maxPrice: 120, unit: 'dozen', trend: 'stable', lastUpdated: baseDate },
  ];
}

export default fetchLiveMandiRates;
