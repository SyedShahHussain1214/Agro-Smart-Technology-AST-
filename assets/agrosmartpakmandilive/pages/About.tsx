import React from 'react';
import { Database, Search, Cpu } from 'lucide-react';

const About: React.FC = () => {
  return (
    <div className="max-w-4xl mx-auto space-y-12">
      <div className="text-center space-y-4">
        <h1 className="text-4xl font-bold text-slate-900">About PakMandi API</h1>
        <p className="text-xl text-slate-600 max-w-2xl mx-auto">
          How we provide real-time market data without a direct government API subscription.
        </p>
      </div>

      <div className="grid md:grid-cols-3 gap-8">
        <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm text-center">
          <div className="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-4">
            <Search size={24} />
          </div>
          <h3 className="text-lg font-bold text-slate-900 mb-2">Live Web Search</h3>
          <p className="text-slate-500">
            We use AI-powered grounding to scan reliable news sources, government bulletins, and digital mandi portals in real-time.
          </p>
        </div>

        <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm text-center">
          <div className="w-12 h-12 bg-purple-100 text-purple-600 rounded-full flex items-center justify-center mx-auto mb-4">
            <Cpu size={24} />
          </div>
          <h3 className="text-lg font-bold text-slate-900 mb-2">AI Extraction</h3>
          <p className="text-slate-500">
            Gemini 2.5 Flash processes unstructured text from the web and converts it into the clean JSON format you see on the dashboard.
          </p>
        </div>

        <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm text-center">
          <div className="w-12 h-12 bg-emerald-100 text-emerald-600 rounded-full flex items-center justify-center mx-auto mb-4">
            <Database size={24} />
          </div>
          <h3 className="text-lg font-bold text-slate-900 mb-2">Data Normalization</h3>
          <p className="text-slate-500">
            We standardize units (kg vs 40kg) and currency formats to ensure consistent analytics across all cities and crops.
          </p>
        </div>
      </div>

      <div className="bg-slate-900 text-white rounded-2xl p-8 md:p-12">
        <h2 className="text-2xl font-bold mb-4">For Developers</h2>
        <p className="text-slate-300 mb-6">
          You asked for an API. While there isn't a single free public API for Pakistan Mandi rates, 
          you can build your own using this exact architecture:
        </p>
        <div className="bg-black/30 rounded-lg p-6 font-mono text-sm text-emerald-400 overflow-x-auto">
          <p className="mb-2">// Example Architecture</p>
          <p>1. Frontend sends request: <span className="text-white">GET /rates?city=Lahore</span></p>
          <p>2. Backend/Edge Function calls Gemini API with <span className="text-white">googleSearch</span> tool.</p>
          <p>3. Prompt: <span className="text-yellow-300">"Get today's onion price in Lahore..."</span></p>
          <p>4. Gemini returns formatted JSON.</p>
          <p>5. Frontend renders data.</p>
        </div>
      </div>
    </div>
  );
};

export default About;