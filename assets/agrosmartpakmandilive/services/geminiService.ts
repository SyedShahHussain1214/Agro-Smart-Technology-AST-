import { GoogleGenAI } from "@google/genai";
import { MarketItem, MarketResponse } from "../types";

const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });

// Helper to clean JSON string from Markdown code blocks
const cleanJsonString = (str: string): string => {
  return str.replace(/```json\n?|\n?```/g, "").trim();
};

export const fetchLiveMarketRates = async (city: string = 'Lahore'): Promise<MarketResponse> => {
  const currentDate = new Date().toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  const prompt = `
    Find the latest daily wholesale market prices (Mandi rates) for agricultural commodities in ${city}, Pakistan for today, ${currentDate}.
    
    Focus on these key items:
    1. Vegetables: Potato, Onion, Tomato, Garlic, Ginger, Green Chilli, Lemon.
    2. Grains/Staples: Wheat, Rice (Basmati), Sugar, Pulses (Daal Chana, Daal Masoor).
    
    Use Google Search to find the most recent official bulletins or reliable news sources (like market.punjab.gov.pk, urdupoint, hamariweb).
    
    Return a strictly formatted JSON object with the following structure:
    {
      "items": [
        {
          "name": "Item Name (e.g., Potato)",
          "category": "Vegetable" | "Grain" | "Fruit",
          "city": "${city}",
          "minPrice": number (price in PKR per Unit),
          "maxPrice": number (price in PKR per Unit),
          "unit": "kg" or "40kg",
          "trend": "up" | "down" | "stable" (guess based on recent news or set stable if unknown)
        }
      ]
    }
    
    IMPORTANT: 
    - Ensure the JSON is valid.
    - If exact today's data is missing, use the most recent available data from the last 2-3 days.
    - Convert all prices to numeric values.
  `;

  try {
    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: prompt,
      config: {
        tools: [{ googleSearch: {} }],
        // responseMimeType: "application/json" // NOT ALLOWED WITH SEARCH TOOL
      },
    });

    const textResponse = response.text || "";
    const groundingChunks = response.candidates?.[0]?.groundingMetadata?.groundingChunks || [];
    
    // Extract sources
    // Explicitly cast to ensure type safety for TypeScript
    const sources: string[] = groundingChunks
      .map((chunk: any) => chunk.web?.uri)
      .filter((uri: any): uri is string => typeof uri === 'string');

    // Parse JSON from text
    // The model often wraps JSON in markdown blocks even if we don't ask, or mixes text.
    // We try to find the JSON array/object.
    let jsonData: { items: any[] } = { items: [] };
    
    try {
      // Attempt to find the first '{' and last '}'
      const firstBrace = textResponse.indexOf('{');
      const lastBrace = textResponse.lastIndexOf('}');
      
      if (firstBrace !== -1 && lastBrace !== -1) {
        const jsonStr = textResponse.substring(firstBrace, lastBrace + 1);
        jsonData = JSON.parse(jsonStr);
      } else {
        throw new Error("No JSON found in response");
      }
    } catch (parseError) {
      console.error("Failed to parse JSON from Gemini response:", parseError);
      console.log("Raw response:", textResponse);
      // Fallback empty data if parsing fails completely
      return { items: [], sources: [] };
    }

    // Map to our strict type to ensure safety
    const items: MarketItem[] = jsonData.items.map((item: any, index: number) => ({
      id: `${item.name}-${index}-${Date.now()}`,
      name: item.name || "Unknown",
      category: item.category || "Other",
      city: item.city || city,
      minPrice: Number(item.minPrice) || 0,
      maxPrice: Number(item.maxPrice) || 0,
      unit: item.unit || "kg",
      trend: ['up', 'down', 'stable'].includes(item.trend) ? item.trend : 'stable',
      lastUpdated: new Date().toISOString()
    }));

    return {
      items,
      sources: [...new Set(sources)] // Unique sources
    };

  } catch (error) {
    console.error("Error fetching market rates:", error);
    throw error;
  }
};