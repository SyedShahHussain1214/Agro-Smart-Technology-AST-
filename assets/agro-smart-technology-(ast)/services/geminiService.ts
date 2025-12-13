import { GoogleGenAI, GenerateContentResponse } from "@google/genai";
import { SYSTEM_INSTRUCTION, MOCK_PRICES } from "../constants";

// Initialize the API client
// Ensure process.env.API_KEY is available in the environment
const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });

// Helper to format prices for the AI context
const getMarketPriceContext = (): string => {
  const pricesList = MOCK_PRICES.map(p => 
    `- ${p.crop}: Rs. ${p.min} - ${p.max} per 40kg (Trend: ${p.trend})`
  ).join('\n');
  
  return `\n\n[REAL-TIME DATA - DO NOT HALLUCINATE]\nCurrent Mandi Rates (Prices per 40kg):\n${pricesList}\n\nUse this data to answer questions about prices.`;
};

/**
 * Sends a text message to the Gemini model (Text-only chat).
 */
export const chatWithGemini = async (message: string): Promise<string> => {
  try {
    const enhancedSystemInstruction = SYSTEM_INSTRUCTION + getMarketPriceContext();
    
    const response: GenerateContentResponse = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: message,
      config: {
        systemInstruction: enhancedSystemInstruction,
      }
    });
    return response.text || "Sorry, I could not understand that.";
  } catch (error) {
    console.error("Gemini Chat Error:", error);
    return "Network error. Please try again.";
  }
};

/**
 * Analyzes an image for crop disease detection.
 */
export const analyzeCropDisease = async (base64Image: string): Promise<string> => {
  try {
    // Remove header if present (e.g., "data:image/jpeg;base64,")
    const cleanBase64 = base64Image.split(',')[1] || base64Image;

    const response: GenerateContentResponse = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: {
        parts: [
          {
            text: "Analyze this image. If it is a plant, identify the crop, diagnose any disease or pest, and recommend a treatment plan suitable for a Pakistani farmer in Roman Urdu and English. If it is not a plant, say so."
          },
          {
            inlineData: {
              mimeType: 'image/jpeg',
              data: cleanBase64
            }
          }
        ]
      },
      config: {
        systemInstruction: SYSTEM_INSTRUCTION + getMarketPriceContext(),
      }
    });

    return response.text || "Could not analyze the image.";
  } catch (error) {
    console.error("Gemini Vision Error:", error);
    return "Error analyzing the image. Please check your internet connection.";
  }
};