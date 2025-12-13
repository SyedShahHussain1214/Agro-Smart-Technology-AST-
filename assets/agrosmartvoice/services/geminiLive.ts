import { GoogleGenAI, LiveServerMessage, Modality, Type, FunctionDeclaration } from '@google/genai';
import { DashboardData, GroundingSource } from '../types';

// Tool Declarations
const updateDashboardTool: FunctionDeclaration = {
  name: 'update_dashboard',
  description: 'Update the user dashboard with structured weather and crop data. Call this when you have found new information.',
  parameters: {
    type: Type.OBJECT,
    properties: {
      weather: {
        type: Type.OBJECT,
        properties: {
          temp: { type: Type.STRING, description: "Temperature with unit (e.g. 72°F)" },
          condition: { type: Type.STRING, description: "Short condition (e.g. Sunny)" },
          humidity: { type: Type.STRING, description: "Humidity percentage" }
        }
      },
      crops: {
        type: Type.ARRAY,
        items: {
          type: Type.OBJECT,
          properties: {
            name: { type: Type.STRING },
            price: { type: Type.STRING, description: "Current market price" },
            trend: { type: Type.STRING, enum: ['up', 'down', 'stable'] }
          }
        }
      }
    }
  }
};

const fetchInfoTool: FunctionDeclaration = {
  name: 'fetch_info',
  description: 'Search the web for real-time information about weather or crop prices. Use this tool WHENEVER the user asks for factual data.',
  parameters: {
    type: Type.OBJECT,
    properties: {
      query: { type: Type.STRING, description: "The search query to find the information." }
    },
    required: ['query']
  }
};

export class GeminiLiveService {
  private client: GoogleGenAI;
  private session: any = null;
  private inputAudioContext: AudioContext | null = null;
  private outputAudioContext: AudioContext | null = null;
  private inputSource: MediaStreamAudioSourceNode | null = null;
  private processor: ScriptProcessorNode | null = null;
  private outputNode: GainNode | null = null;
  private nextStartTime = 0;
  private audioQueue: AudioBufferSourceNode[] = [];
  
  constructor(apiKey: string) {
    this.client = new GoogleGenAI({ apiKey });
  }

  async connect(
    coords: {lat: number, lng: number} | null,
    onAudioData: (vol: number) => void,
    onDashboardUpdate: (data: Partial<DashboardData>) => void,
    onSourcesUpdate: (sources: GroundingSource[]) => void,
    onError: (err: any) => void
  ) {
    try {
      this.inputAudioContext = new (window.AudioContext || (window as any).webkitAudioContext)({ sampleRate: 16000 });
      this.outputAudioContext = new (window.AudioContext || (window as any).webkitAudioContext)({ sampleRate: 24000 });
      this.outputNode = this.outputAudioContext.createGain();
      this.outputNode.connect(this.outputAudioContext.destination);

      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      
      const config = {
        model: 'gemini-2.5-flash-native-audio-preview-09-2025',
        systemInstruction: `You are AgriVoice, an expert agricultural assistant. 
        Your location context is: ${coords ? `Lat: ${coords.lat}, Lng: ${coords.lng}` : 'Unknown (ask user)'}.
        
        PROTOCOL:
        1. When asked for weather or prices, YOU MUST call 'fetch_info' with a search query.
        2. Once you receive the search results, parse them.
        3. If the results contain structured data (temps, prices), call 'update_dashboard' to visualize it.
        4. Speak a friendly summary to the user.
        
        Keep responses concise and spoken naturally.`,
        tools: [
          { functionDeclarations: [updateDashboardTool, fetchInfoTool] }
        ]
      };

      const sessionPromise = this.client.live.connect({
        model: config.model,
        config: {
          responseModalities: [Modality.AUDIO],
          speechConfig: {
            voiceConfig: { prebuiltVoiceConfig: { voiceName: 'Kore' } }
          },
          systemInstruction: config.systemInstruction,
          tools: config.tools
        },
        callbacks: {
          onopen: async () => {
            console.log('Gemini Live Connected');
            this.startAudioInput(stream, sessionPromise, onAudioData);
          },
          onmessage: async (msg: LiveServerMessage) => {
             this.handleMessage(msg, sessionPromise, onDashboardUpdate, onSourcesUpdate);
          },
          onclose: () => {
            console.log('Gemini Live Closed');
          },
          onerror: (e) => {
            console.error('Gemini Live Error', e);
            onError(e);
          }
        }
      });
      
      this.session = sessionPromise;
      return sessionPromise;

    } catch (e) {
      onError(e);
      throw e;
    }
  }

  private startAudioInput(stream: MediaStream, sessionPromise: Promise<any>, onAudioData: (vol: number) => void) {
    if (!this.inputAudioContext) return;

    this.inputSource = this.inputAudioContext.createMediaStreamSource(stream);
    this.processor = this.inputAudioContext.createScriptProcessor(4096, 1, 1);

    this.processor.onaudioprocess = (e) => {
      const inputData = e.inputBuffer.getChannelData(0);
      
      // Calculate volume for visualizer
      let sum = 0;
      for (let i = 0; i < inputData.length; i++) {
        sum += inputData[i] * inputData[i];
      }
      const vol = Math.sqrt(sum / inputData.length);
      onAudioData(vol);

      // Create blob and send
      const pcmBlob = this.createPcmBlob(inputData);
      sessionPromise.then(session => {
        session.sendRealtimeInput({ media: pcmBlob });
      });
    };

    this.inputSource.connect(this.processor);
    this.processor.connect(this.inputAudioContext.destination);
  }

  private async handleMessage(
    msg: LiveServerMessage, 
    sessionPromise: Promise<any>,
    onDashboardUpdate: (data: Partial<DashboardData>) => void,
    onSourcesUpdate: (sources: GroundingSource[]) => void
  ) {
    // 1. Handle Audio
    const audioData = msg.serverContent?.modelTurn?.parts?.[0]?.inlineData?.data;
    if (audioData) {
      this.playAudio(audioData);
    }

    // 2. Handle Tool Calls
    if (msg.toolCall) {
      for (const fc of msg.toolCall.functionCalls) {
        if (fc.name === 'update_dashboard') {
          console.log('Tool Call: update_dashboard', fc.args);
          onDashboardUpdate(fc.args as any);
          // Confirm update to model
          sessionPromise.then(session => {
            session.sendToolResponse({
              functionResponses: {
                id: fc.id,
                name: fc.name,
                response: { result: "Dashboard updated successfully." }
              }
            });
          });
        } 
        else if (fc.name === 'fetch_info') {
          console.log('Tool Call: fetch_info', fc.args);
          const query = (fc.args as any).query;
          const searchResult = await this.performGoogleSearch(query, onSourcesUpdate);
          
          sessionPromise.then(session => {
            session.sendToolResponse({
              functionResponses: {
                id: fc.id,
                name: fc.name,
                response: { result: searchResult }
              }
            });
          });
        }
      }
    }

    // 3. Handle Interruption
    if (msg.serverContent?.interrupted) {
      this.stopAudio();
    }
  }

  // Bridge to generateContent for Grounding
  private async performGoogleSearch(query: string, onSourcesUpdate: (sources: GroundingSource[]) => void): Promise<string> {
    try {
      const result = await this.client.models.generateContent({
        model: 'gemini-2.5-flash',
        contents: query,
        config: {
          tools: [{ googleSearch: {} }]
        }
      });

      // Extract grounding sources
      const chunks = result.candidates?.[0]?.groundingMetadata?.groundingChunks;
      if (chunks) {
        const sources: GroundingSource[] = chunks
          .filter((c: any) => c.web?.uri && c.web?.title)
          .map((c: any) => ({ title: c.web.title, uri: c.web.uri }));
        onSourcesUpdate(sources);
      }

      return result.text;
    } catch (e) {
      console.error("Search Bridge Error", e);
      return "Error fetching information.";
    }
  }

  private async playAudio(base64Data: string) {
    if (!this.outputAudioContext || !this.outputNode) return;
    
    // Manual decoding to avoid browser limitations with raw PCM
    const binaryString = atob(base64Data);
    const len = binaryString.length;
    const bytes = new Uint8Array(len);
    for (let i = 0; i < len; i++) {
      bytes[i] = binaryString.charCodeAt(i);
    }
    
    const dataInt16 = new Int16Array(bytes.buffer);
    const buffer = this.outputAudioContext.createBuffer(1, dataInt16.length, 24000);
    const channelData = buffer.getChannelData(0);
    for (let i = 0; i < dataInt16.length; i++) {
      channelData[i] = dataInt16[i] / 32768.0;
    }

    const source = this.outputAudioContext.createBufferSource();
    source.buffer = buffer;
    source.connect(this.outputNode);
    
    this.nextStartTime = Math.max(this.nextStartTime, this.outputAudioContext.currentTime);
    source.start(this.nextStartTime);
    this.nextStartTime += buffer.duration;
    
    this.audioQueue.push(source);
    source.onended = () => {
      this.audioQueue = this.audioQueue.filter(s => s !== source);
    };
  }

  private stopAudio() {
    this.audioQueue.forEach(source => source.stop());
    this.audioQueue = [];
    this.nextStartTime = 0;
  }

  private createPcmBlob(data: Float32Array): { data: string, mimeType: string } {
    const l = data.length;
    const int16 = new Int16Array(l);
    for (let i = 0; i < l; i++) {
      const s = Math.max(-1, Math.min(1, data[i]));
      int16[i] = s < 0 ? s * 0x8000 : s * 0x7FFF;
    }
    
    let binary = '';
    const bytes = new Uint8Array(int16.buffer);
    const len = bytes.byteLength;
    for (let i = 0; i < len; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    
    return {
      data: btoa(binary),
      mimeType: 'audio/pcm;rate=16000',
    };
  }

  disconnect() {
    // We can't really "disconnect" the session object cleanly in the current SDK without just letting it drop,
    // but we can close audio contexts.
    this.inputSource?.disconnect();
    this.processor?.disconnect();
    this.inputAudioContext?.close();
    this.outputAudioContext?.close();
    this.stopAudio();
    
    this.inputAudioContext = null;
    this.outputAudioContext = null;
    this.session = null;
  }
}
