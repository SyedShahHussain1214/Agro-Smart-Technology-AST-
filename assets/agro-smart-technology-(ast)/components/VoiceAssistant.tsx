import React, { useState, useEffect, useRef } from 'react';
import { chatWithGemini } from '../services/geminiService';
import { ChatMessage } from '../types';

const VoiceAssistant: React.FC = () => {
  const [isListening, setIsListening] = useState(false);
  const [messages, setMessages] = useState<ChatMessage[]>([
    { id: '0', role: 'model', text: 'Salam! I am your Agro Assistant. Ask me about your crops, weather, or pests.' }
  ]);
  const [inputText, setInputText] = useState('');
  const [processing, setProcessing] = useState(false);
  
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Text-to-Speech Helper
  const speak = (text: string) => {
    if ('speechSynthesis' in window) {
      window.speechSynthesis.cancel(); // Stop previous
      const utterance = new SpeechSynthesisUtterance(text);
      // Try to find a voice that supports local accents if possible, otherwise default
      // utterance.lang = 'ur-PK'; // Support varies widely
      utterance.rate = 1.0;
      utterance.pitch = 1.0;
      window.speechSynthesis.speak(utterance);
    }
  };

  // Handle User Input Processing
  const handleSend = async (text: string) => {
    if (!text.trim()) return;

    const userMsg: ChatMessage = { id: Date.now().toString(), role: 'user', text };
    setMessages(prev => [...prev, userMsg]);
    setInputText('');
    setProcessing(true);

    const responseText = await chatWithGemini(text);

    const botMsg: ChatMessage = { id: (Date.now() + 1).toString(), role: 'model', text: responseText };
    setMessages(prev => [...prev, botMsg]);
    setProcessing(false);
    
    speak(responseText);
  };

  // Speech Recognition Setup
  const toggleListening = () => {
    if (isListening) {
      setIsListening(false);
      return;
    }

    if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
      alert("Voice input is not supported in this browser. Please use Chrome.");
      return;
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const SpeechRecognition = (window as any).webkitSpeechRecognition || (window as any).SpeechRecognition;
    const recognition = new SpeechRecognition();

    recognition.continuous = false;
    recognition.interimResults = false;
    // recognition.lang = 'ur-PK'; // Urdu support depends on browser/OS
    recognition.lang = 'en-US'; // Fallback to English/Roman Urdu input

    recognition.onstart = () => {
      setIsListening(true);
    };

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    recognition.onresult = (event: any) => {
      const transcript = event.results[0][0].transcript;
      setInputText(transcript);
      handleSend(transcript);
    };

    recognition.onerror = () => {
      setIsListening(false);
    };

    recognition.onend = () => {
      setIsListening(false);
    };

    recognition.start();
  };

  return (
    <div className="flex flex-col h-full bg-gray-100 pb-20">
      {/* Header */}
      <div className="bg-white p-4 shadow-sm z-10 flex items-center justify-between">
        <h2 className="text-xl font-bold text-agro-800">Voice Assistant</h2>
        <div className="bg-agro-100 text-agro-800 px-3 py-1 rounded-full text-xs font-semibold">
           AST AI
        </div>
      </div>

      {/* Chat Area */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((msg) => (
          <div
            key={msg.id}
            className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[80%] p-4 rounded-2xl ${
                msg.role === 'user'
                  ? 'bg-agro-600 text-white rounded-br-none'
                  : 'bg-white text-gray-800 shadow-sm rounded-bl-none border border-gray-200'
              }`}
            >
              {msg.text}
            </div>
          </div>
        ))}
        {processing && (
           <div className="flex justify-start">
             <div className="bg-gray-200 text-gray-500 px-4 py-2 rounded-2xl rounded-bl-none text-sm animate-pulse">
               Thinking...
             </div>
           </div>
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Input Area */}
      <div className="p-4 bg-white border-t border-gray-200">
        <div className="flex items-center space-x-3">
            <button
              onClick={toggleListening}
              className={`h-14 w-14 rounded-full flex items-center justify-center shadow-lg transition-all ${
                isListening 
                  ? 'bg-red-500 animate-pulse text-white' 
                  : 'bg-agro-600 text-white hover:bg-agro-700'
              }`}
            >
              <i className={`fas ${isListening ? 'fa-stop' : 'fa-microphone'} text-xl`}></i>
            </button>

            <div className="flex-1 relative">
              <input 
                type="text" 
                value={inputText}
                onChange={(e) => setInputText(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleSend(inputText)}
                placeholder="Type or Speak..."
                className="w-full bg-gray-100 border-none rounded-full py-3 px-5 focus:ring-2 focus:ring-agro-500 outline-none"
              />
              <button 
                onClick={() => handleSend(inputText)}
                className="absolute right-2 top-1/2 -translate-y-1/2 w-10 h-10 bg-white rounded-full text-agro-600 shadow-sm flex items-center justify-center"
              >
                <i className="fas fa-paper-plane"></i>
              </button>
            </div>
        </div>
        <p className="text-center text-xs text-gray-400 mt-2">
            Try asking: "What is the price of wheat?" or "How to treat leaf curl?"
        </p>
      </div>
    </div>
  );
};

export default VoiceAssistant;
