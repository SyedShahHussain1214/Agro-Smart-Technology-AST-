import React, { useState, useEffect, useRef } from 'react';
import { Box, Container, Typography, IconButton, Paper, Card, CardContent, LinearProgress, Chip } from '@mui/material';
import { Mic, MicOff, Cloud, TrendingUp, CheckCircle } from '@mui/icons-material';
import { integratedQuery, checkAPIConfiguration } from '../services/integratedAIService';
import { useThemeMode } from '../App';

const VoiceQA = () => {
  const { isDark } = useThemeMode();
  const [isListening, setIsListening] = useState(false);
  const [recognizedText, setRecognizedText] = useState('');
  const [chatHistory, setChatHistory] = useState([]);
  const [isProcessing, setIsProcessing] = useState(false);
  const [weatherData, setWeatherData] = useState({ temp: '--', condition: 'Waiting...', humidity: '--' });
  const [apiStatus, setApiStatus] = useState({ openai: false, gemini: false, openweather: false });
  const chatEndRef = useRef(null);
  const recognitionRef = useRef(null);
  const conversationHistoryRef = useRef([]);

  useEffect(() => {
    // Check API configuration on mount
    const status = checkAPIConfiguration();
    setApiStatus(status);
  }, []);

  const handleSendMessage = async (text) => {
    setIsProcessing(true);
    setChatHistory((prev) => [...prev, { role: 'user', text }]);

    try {
      // Use integrated AI service that combines all APIs
      const result = await integratedQuery(text, {
        conversationHistory: conversationHistoryRef.current,
        city: 'Lahore',
        preferGPT: true, // Prefer OpenAI for better responses
        includeWeather: true
      });

      const responseText = result.response;
      
      // Update conversation history
      conversationHistoryRef.current.push(
        { role: 'user', content: text },
        { role: 'assistant', content: responseText }
      );

      // Keep only last 10 messages to avoid token limits
      if (conversationHistoryRef.current.length > 20) {
        conversationHistoryRef.current = conversationHistoryRef.current.slice(-20);
      }

      setChatHistory((prev) => [...prev, { role: 'assistant', text: responseText }]);

      // Update weather data if available
      if (result.weatherData) {
        setWeatherData({
          temp: `${result.weatherData.temp}°C`,
          condition: result.weatherData.description,
          humidity: `${result.weatherData.humidity}%`
        });
      }

      // Speak the response in Urdu
      const utterance = new SpeechSynthesisUtterance(responseText);
      utterance.lang = 'ur-PK';
      window.speechSynthesis.speak(utterance);
    } catch (error) {
      console.error('Integrated AI error:', error);
      setChatHistory((prev) => [...prev, { role: 'assistant', text: 'معذرت، میں جواب نہیں دے سکتا۔ Please check API keys.' }]);
    }

    setIsProcessing(false);
  };

  useEffect(() => {
    // Initialize Web Speech API
    if ('webkitSpeechRecognition' in window) {
      const recognition = new window.webkitSpeechRecognition();
      recognition.continuous = false;
      recognition.interimResults = true;
      recognition.lang = 'ur-PK';

      recognition.onresult = (event) => {
        const transcript = Array.from(event.results)
          .map(result => result[0].transcript)
          .join('');
        setRecognizedText(transcript);

        if (event.results[0].isFinal) {
          handleSendMessage(transcript);
        }
      };

      recognition.onerror = (event) => {
        console.error('Speech recognition error:', event.error);
        setIsListening(false);
      };

      recognition.onend = () => {
        setIsListening(false);
      };

      recognitionRef.current = recognition;
    }

    return () => {
      if (recognitionRef.current) {
        recognitionRef.current.stop();
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [chatHistory]);

  const startListening = () => {
    if (recognitionRef.current && !isListening) {
      setRecognizedText('');
      recognitionRef.current.start();
      setIsListening(true);
    }
  };

  const stopListening = () => {
    if (recognitionRef.current && isListening) {
      recognitionRef.current.stop();
      setIsListening(false);
    }
  };

  return (
    <Box sx={{ 
      minHeight: '100vh', 
      bgcolor: 'transparent',
      color: isDark ? 'white' : '#000',
      py: 4,
      transition: 'all 0.3s ease'
    }}>
      <Container maxWidth="lg">
        {/* Header */}
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 4, flexWrap: 'wrap' }}>
          <Box sx={{ display: 'flex', alignItems: 'center', mb: { xs: 2, md: 0 } }}>
            <Box sx={{ 
              bgcolor: '#28a745', 
              borderRadius: 2, 
              p: 1, 
              mr: 2,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              boxShadow: '0 4px 12px rgba(40, 167, 69, 0.3)'
            }}>
              <Mic sx={{ fontSize: 28, color: 'white' }} />
            </Box>
            <Box>
              <Typography variant="h4" fontWeight="bold" color={isDark ? 'white' : '#000'}>
                AgriVoice AI
              </Typography>
              <Typography variant="body2" color={isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)'}>
                Powered by OpenAI + Gemini + OpenWeather
              </Typography>
            </Box>
          </Box>
          
          {/* API Status Indicators */}
          <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
            <Chip 
              icon={<CheckCircle />}
              label="OpenAI" 
              size="small"
              sx={{ 
                bgcolor: apiStatus.openai ? '#28a745' : (isDark ? '#374151' : '#e5e7eb'),
                color: apiStatus.openai ? 'white' : (isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)')
              }}
            />
            <Chip 
              icon={<CheckCircle />}
              label="Gemini" 
              size="small"
              sx={{ 
                bgcolor: apiStatus.gemini ? '#28a745' : (isDark ? '#374151' : '#e5e7eb'),
                color: apiStatus.gemini ? 'white' : (isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)')
              }}
            />
            <Chip 
              icon={<CheckCircle />}
              label="Weather" 
              size="small"
              sx={{ 
                bgcolor: apiStatus.openweather ? '#28a745' : (isDark ? '#374151' : '#e5e7eb'),
                color: apiStatus.openweather ? 'white' : (isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)')
              }}
            />
          </Box>
        </Box>

        {/* Dashboard Cards */}
        <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', md: '1fr 1fr' }, gap: 2, mb: 3 }}>
          <Card sx={{ 
            bgcolor: isDark ? '#1a1f35' : 'white',
            color: isDark ? 'white' : '#000',
            boxShadow: isDark ? '0 4px 12px rgba(0,0,0,0.5)' : '0 4px 12px rgba(0,0,0,0.1)',
            border: isDark ? '1px solid rgba(255,255,255,0.1)' : '1px solid rgba(0,0,0,0.05)'
          }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                <Cloud sx={{ color: '#28a745', mr: 1 }} />
                <Typography variant="subtitle2">Weather</Typography>
              </Box>
              <Typography variant="h5" fontWeight="bold">{weatherData.temp}</Typography>
              <Typography variant="body2" color={isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)'}>
                {weatherData.condition}
              </Typography>
            </CardContent>
          </Card>

          <Card sx={{ 
            bgcolor: isDark ? '#1a1f35' : 'white',
            color: isDark ? 'white' : '#000',
            boxShadow: isDark ? '0 4px 12px rgba(0,0,0,0.5)' : '0 4px 12px rgba(0,0,0,0.1)',
            border: isDark ? '1px solid rgba(255,255,255,0.1)' : '1px solid rgba(0,0,0,0.05)'
          }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                <TrendingUp sx={{ color: '#28a745', mr: 1 }} />
                <Typography variant="subtitle2">Market</Typography>
              </Box>
              <Typography variant="h5" fontWeight="bold">
                --
              </Typography>
              <Typography variant="body2" color={isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)'}>
                Ask for prices
              </Typography>
            </CardContent>
          </Card>
        </Box>

        {/* Chat Area */}
        <Paper sx={{ 
          bgcolor: isDark ? 'rgba(30, 41, 59, 0.5)' : 'rgba(255,255,255,0.8)', 
          minHeight: 400,
          maxHeight: 500, 
          overflow: 'auto',
          p: 2,
          mb: 3,
          border: isDark ? '1px solid rgba(255,255,255,0.1)' : '1px solid rgba(0,0,0,0.1)',
          borderRadius: 2,
          boxShadow: isDark ? '0 4px 12px rgba(0,0,0,0.5)' : '0 4px 12px rgba(0,0,0,0.1)'
        }}>
          {chatHistory.length === 0 ? (
            <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: 400 }}>
              <Mic sx={{ fontSize: 80, color: isDark ? 'rgba(255,255,255,0.2)' : 'rgba(0,0,0,0.1)', mb: 2 }} />
              <Typography variant="h6" color={isDark ? 'rgba(255,255,255,0.5)' : 'rgba(0,0,0,0.5)'}>
                Press the mic button to start
              </Typography>
              <Typography variant="body2" color={isDark ? 'rgba(255,255,255,0.5)' : 'rgba(0,0,0,0.5)'} sx={{ fontFamily: 'Noto Nastaliq Urdu' }}>
                مائیک دبائیں اور بات کریں
              </Typography>
            </Box>
          ) : (
            chatHistory.map((chat, index) => (
              <Box key={index} sx={{ 
                display: 'flex', 
                justifyContent: chat.role === 'user' ? 'flex-end' : 'flex-start',
                mb: 2
              }}>
                <Paper sx={{ 
                  p: 2, 
                  maxWidth: '75%',
                  background: chat.role === 'user' 
                    ? 'linear-gradient(135deg, #28a745 0%, #20c997 100%)'
                    : 'linear-gradient(135deg, #374151 0%, #4b5563 100%)',
                  borderRadius: chat.role === 'user' ? '16px 16px 4px 16px' : '16px 16px 16px 4px',
                  boxShadow: 3
                }}>
                  <Typography variant="body1">{chat.text}</Typography>
                </Paper>
              </Box>
            ))
          )}
          <div ref={chatEndRef} />
        </Paper>

        {isProcessing && <LinearProgress sx={{ mb: 2 }} />}

        {/* Mic Button */}
        <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
          <IconButton
            onClick={isListening ? stopListening : startListening}
            disabled={isProcessing}
            sx={{
              width: 90,
              height: 90,
              background: isListening 
                ? 'linear-gradient(135deg, #dc2626 0%, #ef4444 100%)'
                : 'linear-gradient(135deg, #28a745 0%, #20c997 100%)',
              '&:hover': {
                background: isListening 
                  ? 'linear-gradient(135deg, #b91c1c 0%, #dc2626 100%)'
                  : 'linear-gradient(135deg, #20c997 0%, #17a2b8 100%)',
              },
              boxShadow: isListening ? '0 0 30px rgba(220, 38, 38, 0.5)' : '0 0 20px rgba(40, 167, 69, 0.3)',
              animation: isListening ? 'pulse 1.5s infinite' : 'none',
              '@keyframes pulse': {
                '0%, 100%': { transform: 'scale(1)' },
                '50%': { transform: 'scale(1.05)' }
              }
            }}
          >
            {isListening ? <MicOff sx={{ fontSize: 40 }} /> : <Mic sx={{ fontSize: 40 }} />}
          </IconButton>

          <Typography variant="body2" sx={{ mt: 2, color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)' }}>
            {isListening ? 'Listening... | سن رہے ہیں...' : 'Tap to Speak | بولنے کے لیے دبائیں'}
          </Typography>

          {recognizedText && isListening && (
            <Paper sx={{ mt: 2, p: 2, bgcolor: isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.05)', maxWidth: 400 }}>
              <Typography variant="body2" align="center" color={isDark ? 'white' : '#000'}>{recognizedText}</Typography>
            </Paper>
          )}
        </Box>
      </Container>
    </Box>
  );
};

export default VoiceQA;
