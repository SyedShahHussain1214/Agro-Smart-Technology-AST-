import React, { useState, useEffect, useRef } from 'react';
import { ApiConfig, ChatMessage, AppView, Language } from './types';
import { integratedQuery, analyzeImageWithGemini } from './services/integratedAIService';
import ApiKeyModal from './components/ApiKeyModal';
import StatusBar from './components/StatusBar';
import WeatherWidget from './components/WeatherWidget';
import { 
  Bot, 
  Send, 
  Image as ImageIcon, 
  Settings, 
  Leaf, 
  Loader2, 
  AlertCircle,
  Mic,
  MicOff,
  Volume2,
  Languages
} from 'lucide-react';
import ReactMarkdown from 'react-markdown';

// Define translations
const translations = {
  en: {
    title: "AgroSmart",
    subtitle: "Integrated AI Assistant",
    navChat: "Voice Q&A",
    navDisease: "Disease Detection",
    welcome: "Hello! I am AgroSmart. I can help you with farming advice, weather-based planning, and crop disease detection.",
    thinking: "AgroSmart is thinking...",
    inputPlaceholder: "Ask about weather, crops, or farming...",
    uploadTitle: "Crop Disease Detector",
    uploadDesc: "Upload a photo of a leaf to identify diseases and get treatment advice.",
    clickUpload: "Click to upload leaf photo",
    analyzing: "Analyzing...",
    analyzeBtn: "Analyze Image",
    analysisResult: "Analysis Result",
    voiceError: "Voice recognition not supported in this browser.",
    micAccess: "Please allow microphone access.",
  },
  ur: {
    title: "ایگرو سمارٹ",
    subtitle: "زرعی مصنوعی ذہانت",
    navChat: "صوتی سوال و جواب",
    navDisease: "بیماری کی تشخیص",
    welcome: "السلام علیکم! میں ایگرو سمارٹ ہوں۔ میں آپ کی فصلوں، موسم اور کاشتکاری کے مسائل میں مدد کر سکتا ہوں۔",
    thinking: "ایگرو سمارٹ سوچ رہا ہے...",
    inputPlaceholder: "موسم، فصلوں یا کاشتکاری کے بارے میں پوچھیں...",
    uploadTitle: "فصل کی بیماری کی تشخیص",
    uploadDesc: "بیماری کی شناخت اور علاج کے لیے پتے کی تصویر اپ لوڈ کریں۔",
    clickUpload: "پتے کی تصویر اپ لوڈ کریں",
    analyzing: "تجزیہ ہو رہا ہے...",
    analyzeBtn: "تصویر کا تجزیہ کریں",
    analysisResult: "تجزیہ کا نتیجہ",
    voiceError: "اس براؤزر میں آواز کی شناخت کی سہولت موجود نہیں ہے۔",
    micAccess: "براہ کرم مائکروفون تک رسائی کی اجازت دیں۔",
  }
};

const App: React.FC = () => {
  // --- State ---
  const [config, setConfig] = useState<ApiConfig>(() => {
    const saved = localStorage.getItem('agro_api_config');
    return saved ? JSON.parse(saved) : { openaiKey: '', geminiKey: '', openWeatherKey: '' };
  });

  const [view, setView] = useState<AppView>('chat');
  const [language, setLanguage] = useState<Language>('en');
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const t = translations[language];
  
  // Chat State
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Voice State
  const [isListening, setIsListening] = useState(false);

  // Disease Detection State
  const [selectedImage, setSelectedImage] = useState<string | null>(null);
  const [analyzing, setAnalyzing] = useState(false);
  const [analysisResult, setAnalysisResult] = useState<string | null>(null);

  // --- Effects ---
  useEffect(() => {
    localStorage.setItem('agro_api_config', JSON.stringify(config));
  }, [config]);

  // Set initial welcome message when language changes, only if chat is empty or reset
  useEffect(() => {
    if (messages.length === 0) {
      setMessages([{
        id: 'welcome',
        role: 'assistant',
        content: t.welcome,
        timestamp: Date.now()
      }]);
    }
  }, [language, t.welcome, messages.length]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // --- Voice Helpers ---
  const handleVoiceInput = () => {
    // @ts-ignore - SpeechRecognition types are not standard in all envs
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

    if (!SpeechRecognition) {
      alert(t.voiceError);
      return;
    }

    const recognition = new SpeechRecognition();
    recognition.lang = language === 'ur' ? 'ur-PK' : 'en-US';
    recognition.interimResults = false;
    recognition.maxAlternatives = 1;

    recognition.onstart = () => setIsListening(true);
    
    recognition.onresult = (event: any) => {
      const transcript = event.results[0][0].transcript;
      setInput(transcript);
      // Optional: Auto-send could be added here
    };

    recognition.onerror = (event: any) => {
      console.error("Speech recognition error", event.error);
      setIsListening(false);
    };

    recognition.onend = () => setIsListening(false);

    recognition.start();
  };

  const speakText = (text: string) => {
    if (!window.speechSynthesis) return;

    window.speechSynthesis.cancel(); // Stop any current speech
    
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = language === 'ur' ? 'ur-PK' : 'en-US';
    utterance.rate = 1;
    utterance.pitch = 1;
    
    window.speechSynthesis.speak(utterance);
  };

  // --- Handlers ---
  const handleSendMessage = async () => {
    if (!input.trim() || isTyping) return;

    const userMsg: ChatMessage = {
      id: Date.now().toString(),
      role: 'user',
      content: input,
      timestamp: Date.now()
    };

    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setIsTyping(true);

    try {
      // Format history for OpenAI
      const history = messages.map(m => ({ role: m.role, content: m.content }));
      
      const result = await integratedQuery(
        userMsg.content,
        history,
        config,
        'Lahore', // Location could be dynamic later
        language
      );

      const aiMsg: ChatMessage = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: result.text,
        timestamp: Date.now(),
        source: result.source
      };

      setMessages(prev => [...prev, aiMsg]);
      
      // Auto-speak the response if using voice mode (UX decision: usually better to let user click, but user asked for "speaking AI")
      // Let's make it manual to avoid annoyance, or maybe only if input was voice. 
      // For now, I'll add a prominent speak button to the bubble.
    } catch (error: any) {
      setMessages(prev => [...prev, {
        id: Date.now().toString(),
        role: 'system',
        content: `Error: ${error.message}`,
        timestamp: Date.now()
      }]);
    } finally {
      setIsTyping(false);
    }
  };

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setSelectedImage(reader.result as string);
        setAnalysisResult(null); // Reset previous result
      };
      reader.readAsDataURL(file);
    }
  };

  const handleAnalyzeImage = async () => {
    if (!selectedImage || analyzing) return;
    
    setAnalyzing(true);
    try {
      const result = await analyzeImageWithGemini(selectedImage, config.geminiKey, language);
      setAnalysisResult(result);
    } catch (error: any) {
      setAnalysisResult(`Error: ${error.message}. Please check your Gemini API key.`);
    } finally {
      setAnalyzing(false);
    }
  };

  const toggleLanguage = () => {
    const newLang = language === 'en' ? 'ur' : 'en';
    setLanguage(newLang);
    // Clear chat on language switch to avoid context confusion or just let it flow
    // let's keep chat for continuity but update UI
  };

  // --- Render Helpers ---
  const renderNav = () => (
    <nav className="flex items-center gap-1 bg-white p-1 rounded-xl shadow-sm border border-gray-100 mb-6">
      <button 
        onClick={() => setView('chat')}
        className={`flex-1 py-2 px-4 rounded-lg text-sm font-medium transition-all ${view === 'chat' ? 'bg-green-100 text-green-700 shadow-sm' : 'text-gray-500 hover:bg-gray-50'}`}
      >
        {t.navChat}
      </button>
      <button 
        onClick={() => setView('disease')}
        className={`flex-1 py-2 px-4 rounded-lg text-sm font-medium transition-all ${view === 'disease' ? 'bg-green-100 text-green-700 shadow-sm' : 'text-gray-500 hover:bg-gray-50'}`}
      >
        {t.navDisease}
      </button>
    </nav>
  );

  return (
    <div className={`min-h-screen bg-slate-50 flex flex-col items-center py-6 px-4 md:px-0 font-sans ${language === 'ur' ? 'font-[System-ui]' : ''}`} dir={language === 'ur' ? 'rtl' : 'ltr'}>
      
      {/* Header */}
      <header className="w-full max-w-2xl flex justify-between items-center mb-6">
        <div className="flex items-center gap-3">
          <div className="bg-green-600 p-2.5 rounded-xl shadow-lg shadow-green-600/20">
            <Leaf className="text-white" size={24} />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900 tracking-tight">{t.title}</h1>
            <p className="text-xs text-gray-500 font-medium">{t.subtitle}</p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <button 
            onClick={toggleLanguage}
            className="flex items-center gap-1.5 bg-white border border-gray-200 px-3 py-1.5 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors shadow-sm"
          >
            <Languages size={16} />
            {language === 'en' ? 'English' : 'اردو'}
          </button>
          <StatusBar config={config} onOpenSettings={() => setIsSettingsOpen(true)} />
        </div>
      </header>

      {/* Main Content Area */}
      <main className="w-full max-w-2xl flex-1 flex flex-col gap-4">
        
        <WeatherWidget config={config} />
        
        {renderNav()}

        {view === 'chat' && (
          <div className="bg-white rounded-2xl shadow-xl shadow-gray-200/50 border border-gray-100 flex-1 flex flex-col overflow-hidden min-h-[500px]">
            {/* Messages Area */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4 scrollbar-hide">
              {messages.map((msg) => (
                <div 
                  key={msg.id} 
                  className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}
                >
                  <div className={`flex flex-col gap-1 max-w-[85%] ${msg.role === 'user' ? 'items-end' : 'items-start'}`}>
                    <div className={`
                      px-5 py-3.5 text-sm leading-relaxed shadow-sm relative group
                      ${msg.role === 'user' 
                        ? 'bg-green-600 text-white rounded-2xl rounded-br-none' 
                        : msg.role === 'system'
                          ? 'bg-red-50 text-red-600 border border-red-100 w-full text-center rounded-2xl'
                          : 'bg-gray-100 text-gray-800 rounded-2xl rounded-bl-none'
                      }
                    `}>
                      {msg.source && (
                        <div className="text-[10px] uppercase tracking-wider opacity-70 mb-1 font-bold">
                          Via {msg.source}
                        </div>
                      )}
                      <div className="whitespace-pre-wrap">{msg.content}</div>
                      
                      {/* Speak Button for Assistant Messages */}
                      {msg.role === 'assistant' && (
                        <button 
                          onClick={() => speakText(msg.content)}
                          className="absolute -bottom-8 left-0 p-1.5 text-gray-400 hover:text-green-600 transition-colors opacity-0 group-hover:opacity-100"
                          title="Speak"
                        >
                          <Volume2 size={16} />
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              ))}
              {isTyping && (
                <div className="flex justify-start">
                  <div className="bg-gray-100 rounded-2xl rounded-bl-none px-4 py-3 flex items-center gap-2">
                    <Loader2 className="animate-spin text-green-600" size={16} />
                    <span className="text-xs text-gray-500 font-medium">{t.thinking}</span>
                  </div>
                </div>
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Input Area */}
            <div className="p-4 border-t border-gray-100 bg-gray-50">
              <div className="flex gap-2">
                <button 
                  onClick={handleVoiceInput}
                  className={`p-3 rounded-xl border transition-all ${
                    isListening 
                      ? 'bg-red-50 border-red-200 text-red-600 animate-pulse' 
                      : 'bg-white border-gray-200 text-gray-500 hover:bg-gray-100 hover:text-green-600'
                  }`}
                  title={isListening ? "Listening..." : "Voice Input"}
                >
                  {isListening ? <MicOff size={20} /> : <Mic size={20} />}
                </button>
                <input
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
                  placeholder={t.inputPlaceholder}
                  dir={language === 'ur' ? 'rtl' : 'ltr'}
                  className="flex-1 bg-white border border-gray-200 rounded-xl px-4 focus:outline-none focus:ring-2 focus:ring-green-500/50 focus:border-green-500 transition-all text-sm"
                />
                <button 
                  onClick={handleSendMessage}
                  disabled={!input.trim() || isTyping}
                  className="p-3 bg-green-600 text-white rounded-xl shadow-lg shadow-green-600/20 hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all active:scale-95"
                >
                  <Send size={20} className={language === 'ur' ? 'rotate-180' : ''} />
                </button>
              </div>
            </div>
          </div>
        )}

        {view === 'disease' && (
          <div className="bg-white rounded-2xl shadow-xl shadow-gray-200/50 border border-gray-100 p-6 flex flex-col min-h-[500px]">
            <div className="text-center mb-8">
              <div className="w-16 h-16 bg-blue-50 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <ImageIcon size={32} />
              </div>
              <h2 className="text-xl font-bold text-gray-900">{t.uploadTitle}</h2>
              <p className="text-gray-500 text-sm mt-1">{t.uploadDesc}</p>
            </div>

            <div className="flex-1 flex flex-col items-center justify-center">
              {!selectedImage ? (
                <label className="w-full h-64 border-2 border-dashed border-gray-300 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-green-500 hover:bg-green-50/50 transition-all group">
                  <div className="p-4 bg-gray-100 rounded-full mb-3 group-hover:scale-110 transition-transform">
                    <Leaf className="text-gray-400 group-hover:text-green-600" size={32} />
                  </div>
                  <span className="text-sm font-medium text-gray-600 group-hover:text-green-700">{t.clickUpload}</span>
                  <input type="file" accept="image/*" className="hidden" onChange={handleImageUpload} />
                </label>
              ) : (
                <div className="w-full space-y-6">
                  <div className="relative rounded-2xl overflow-hidden border border-gray-200 shadow-sm max-h-64 mx-auto w-fit">
                    <img src={selectedImage} alt="Upload" className="max-h-64 object-contain" />
                    <button 
                      onClick={() => { setSelectedImage(null); setAnalysisResult(null); }}
                      className="absolute top-2 right-2 p-1.5 bg-black/50 text-white rounded-full hover:bg-red-500 transition-colors"
                    >
                      <AlertCircle size={16} />
                    </button>
                  </div>

                  {!analysisResult && (
                    <button 
                      onClick={handleAnalyzeImage}
                      disabled={analyzing}
                      className="w-full py-3 bg-blue-600 text-white rounded-xl font-semibold shadow-lg shadow-blue-600/20 hover:bg-blue-700 disabled:opacity-70 transition-all flex items-center justify-center gap-2"
                    >
                      {analyzing ? <Loader2 className="animate-spin" /> : <Bot />}
                      {analyzing ? t.analyzing : t.analyzeBtn}
                    </button>
                  )}
                </div>
              )}

              {analysisResult && (
                <div className="w-full mt-6 bg-green-50 rounded-xl p-5 border border-green-100 animate-in fade-in slide-in-from-bottom-4 duration-500">
                  <div className="flex justify-between items-center mb-3">
                    <h3 className="text-green-800 font-bold flex items-center gap-2">
                      <Bot size={18} /> {t.analysisResult}
                    </h3>
                    <button 
                      onClick={() => speakText(analysisResult)}
                      className="p-1.5 bg-green-100 text-green-700 rounded-lg hover:bg-green-200 transition-colors"
                    >
                      <Volume2 size={16} />
                    </button>
                  </div>
                  <div className="prose prose-sm text-gray-700 max-w-none">
                     <pre className="whitespace-pre-wrap font-sans">{analysisResult}</pre>
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

      </main>

      <ApiKeyModal 
        isOpen={isSettingsOpen} 
        onClose={() => setIsSettingsOpen(false)} 
        config={config} 
        onSave={(newConfig) => setConfig(newConfig)} 
      />
    </div>
  );
};

export default App;