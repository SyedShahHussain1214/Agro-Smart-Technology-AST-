// Disease Detection Service - Gemini AI Vision Integration

const GEMINI_API_KEY = 'AIzaSyCMiwIbXChxDow0QyVzAbyoSFUSi8q5pC8';
const GEMINI_VISION_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';

// Convert image file to base64
const fileToBase64 = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => {
      // Remove data URL prefix to get just base64
      const base64 = reader.result.split(',')[1];
      resolve(base64);
    };
    reader.onerror = error => reject(error);
  });
};

export const detectDisease = async (imageFile) => {
  try {
    console.log('Starting disease detection...', imageFile.name);
    
    // Convert image to base64
    const base64Image = await fileToBase64(imageFile);
    console.log('Image converted to base64, length:', base64Image.length);
    
    // Prepare the request for Gemini Vision API
    const requestBody = {
      contents: [{
        parts: [
          {
            text: `You are an expert agricultural AI assistant specialized in crop disease detection for Pakistani farmers. Analyze this crop image carefully and provide:

1. **Crop Type**: Identify the specific crop (Cotton, Rice, Wheat, Sugarcane, Maize, Potato, Onion, Tomato, etc.)
2. **Disease Name**: If any disease is visible, provide the English name
3. **Disease Name (Urdu)**: Provide the Urdu translation
4. **Severity**: Rate as High, Medium, or Low
5. **Confidence**: Your confidence level (0-100%)
6. **Symptoms**: List visible symptoms in the image
7. **Treatment**: Provide practical treatment recommendations for Pakistani farmers
8. **Prevention**: Suggest preventive measures

Format your response EXACTLY as JSON:
{
  "crop": "crop name",
  "diseaseDetected": true/false,
  "diseaseName": "disease name in English",
  "diseaseNameUrdu": "بیماری کا نام اردو میں",
  "severity": "High/Medium/Low",
  "confidence": 85,
  "symptoms": "detailed symptoms",
  "treatment": "treatment recommendations",
  "prevention": "preventive measures"
}

If the image is healthy, set diseaseDetected to false and provide general crop health information.`
          },
          {
            inline_data: {
              mime_type: imageFile.type,
              data: base64Image
            }
          }
        ]
      }],
      generationConfig: {
        temperature: 0.4,
        maxOutputTokens: 1024
      }
    };

    console.log('Calling Gemini Vision API...');
    
    // Call Gemini Vision API
    const response = await fetch(`${GEMINI_VISION_URL}?key=${GEMINI_API_KEY}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestBody)
    });

    console.log('API Response status:', response.status);

    if (!response.ok) {
      const errorData = await response.text();
      console.error('API Error:', response.status, errorData);
      throw new Error(`API Error: ${response.status} - ${errorData}`);
    }

    const data = await response.json();
    console.log('API Response received:', data);
    
    const aiResponse = data.candidates[0].content.parts[0].text;
    console.log('AI Response text:', aiResponse);
    
    // Parse JSON response from AI
    const jsonMatch = aiResponse.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      console.error('No JSON found in response');
      throw new Error('Could not parse AI response');
    }
    
    const analysis = JSON.parse(jsonMatch[0]);
    console.log('Parsed analysis:', analysis);

    // Validate required fields
    if (!analysis.crop) {
      throw new Error('AI response missing crop information');
    }

    return {
      success: true,
      detection: {
        crop: analysis.crop || 'Unknown Crop',
        disease: {
          name: analysis.diseaseDetected ? (analysis.diseaseName || 'Unknown Disease') : 'Healthy Crop',
          nameUrdu: analysis.diseaseDetected ? (analysis.diseaseNameUrdu || 'نامعلوم بیماری') : 'صحت مند فصل',
          severity: analysis.severity || 'Low',
          symptoms: analysis.symptoms || 'No visible symptoms',
          treatment: analysis.treatment || 'Maintain regular crop care'
        },
        confidence: analysis.confidence || 80,
        imageUrl: URL.createObjectURL(imageFile),
        timestamp: new Date().toISOString(),
        healthy: !analysis.diseaseDetected,
        prevention: analysis.prevention || 'Follow standard agricultural practices'
      }
    };
  } catch (error) {
    console.error('Disease Detection Error:', error);
    return {
      success: false,
      error: 'Failed to analyze image. Please try again with a clear crop photo.'
    };
  }
};
