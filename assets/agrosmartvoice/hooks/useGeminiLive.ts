import { useState, useRef, useCallback, useEffect } from 'react';
import { GeminiLiveService } from '../services/geminiLive';
import { DashboardData, GroundingSource } from '../types';

interface UseGeminiLiveProps {
  coords: {lat: number, lng: number} | null;
  onDashboardUpdate: (data: Partial<DashboardData>) => void;
}

export const useGeminiLive = ({ coords, onDashboardUpdate }: UseGeminiLiveProps) => {
  const [isConnected, setIsConnected] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [volumeLevel, setVolumeLevel] = useState(0);
  const [sources, setSources] = useState<GroundingSource[]>([]);
  
  const serviceRef = useRef<GeminiLiveService | null>(null);

  useEffect(() => {
    // Initialize service
    if (process.env.API_KEY) {
      serviceRef.current = new GeminiLiveService(process.env.API_KEY);
    }
    return () => {
      serviceRef.current?.disconnect();
    };
  }, []);

  const connect = useCallback(async () => {
    if (!serviceRef.current || !process.env.API_KEY) {
      alert("API Key not found or service not initialized.");
      return;
    }

    try {
      setIsConnected(true);
      setSources([]);
      await serviceRef.current.connect(
        coords,
        (vol) => {
           setVolumeLevel(vol);
           // Simple heuristic for "speaking" state based on output queue would be better,
           // but for now we track connection state.
           // Ideally, we'd hook into the audioQueue length in the service.
        },
        onDashboardUpdate,
        (newSources) => setSources(prev => [...newSources, ...prev]), // Append sources
        (err) => {
          console.error(err);
          setIsConnected(false);
        }
      );
    } catch (e) {
      console.error("Failed to connect", e);
      setIsConnected(false);
    }
  }, [coords, onDashboardUpdate]);

  const disconnect = useCallback(() => {
    if (serviceRef.current) {
      serviceRef.current.disconnect();
      setIsConnected(false);
      setVolumeLevel(0);
    }
  }, []);

  return {
    isConnected,
    isSpeaking: volumeLevel > 0.01, // Rough approximation if user is speaking
    volumeLevel,
    connect,
    disconnect,
    sources
  };
};
