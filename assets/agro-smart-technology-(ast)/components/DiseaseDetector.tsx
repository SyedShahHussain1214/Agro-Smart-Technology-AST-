import React, { useState, useRef } from 'react';
import { analyzeCropDisease } from '../services/geminiService';

const DiseaseDetector: React.FC = () => {
  const [image, setImage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<string | null>(null);
  
  // Refs for different input types
  const cameraInputRef = useRef<HTMLInputElement>(null);
  const galleryInputRef = useRef<HTMLInputElement>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        const base64String = reader.result as string;
        setImage(base64String);
        setResult(null); // Reset previous result
      };
      reader.readAsDataURL(file);
    }
    // Reset value so the same file can be selected again if needed
    e.target.value = '';
  };

  const handleAnalyze = async () => {
    if (!image) return;
    setLoading(true);
    setResult("Analyzing crop health... Please wait.");
    
    const analysis = await analyzeCropDisease(image);
    setResult(analysis);
    setLoading(false);
  };

  const clearImage = () => {
    setImage(null);
    setResult(null);
  };

  return (
    <div className="flex flex-col h-full bg-white pb-20 overflow-y-auto no-scrollbar">
      <div className="bg-agro-600 text-white p-6 rounded-b-3xl shadow-lg">
        <h2 className="text-2xl font-bold mb-2">Crop Doctor</h2>
        <p className="opacity-90">Take a photo of the affected leaf or plant.</p>
      </div>

      <div className="p-6 flex flex-col items-center space-y-6">
        
        {/* Hidden Inputs */}
        <input 
          type="file" 
          ref={cameraInputRef} 
          onChange={handleFileChange} 
          accept="image/*"
          capture="environment" // Forces camera on mobile
          className="hidden" 
        />
        <input 
          type="file" 
          ref={galleryInputRef} 
          onChange={handleFileChange} 
          accept="image/*" 
          className="hidden" 
        />

        {/* Image Preview / Selection Area */}
        <div className="w-full">
          {image ? (
            <div className="relative w-full h-64 rounded-2xl overflow-hidden border-4 border-gray-200 shadow-sm group bg-gray-900">
              <img src={image} alt="Crop preview" className="w-full h-full object-contain" />
              <button 
                onClick={clearImage}
                className="absolute top-2 right-2 bg-black/50 text-white w-8 h-8 flex items-center justify-center rounded-full hover:bg-black/70 transition-colors backdrop-blur-sm"
              >
                <i className="fas fa-times"></i>
              </button>
            </div>
          ) : (
            <div className="w-full h-64 border-4 border-dashed border-gray-300 rounded-2xl flex flex-col items-center justify-center bg-gray-50 space-y-4 p-4">
               <div className="text-center text-gray-400 mb-2">
                 <i className="fas fa-leaf text-5xl mb-2 opacity-50"></i>
                 <p className="text-sm">Select an option to diagnose</p>
               </div>
               
               <div className="flex space-x-4 w-full justify-center">
                 <button 
                   onClick={() => cameraInputRef.current?.click()}
                   className="flex flex-col items-center justify-center bg-agro-100 text-agro-700 p-4 rounded-xl hover:bg-agro-200 transition-colors w-32 shadow-sm border border-agro-200"
                 >
                   <i className="fas fa-camera text-2xl mb-1"></i>
                   <span className="font-bold text-sm">Camera</span>
                 </button>
                 
                 <button 
                   onClick={() => galleryInputRef.current?.click()}
                   className="flex flex-col items-center justify-center bg-gray-100 text-gray-600 p-4 rounded-xl hover:bg-gray-200 transition-colors w-32 shadow-sm border border-gray-200"
                 >
                   <i className="fas fa-images text-2xl mb-1"></i>
                   <span className="font-bold text-sm">Gallery</span>
                 </button>
               </div>
            </div>
          )}
        </div>

        {/* Analyze Button */}
        <button
          onClick={handleAnalyze}
          disabled={!image || loading}
          className={`w-full py-4 rounded-xl font-bold text-lg shadow-md transition-transform active:scale-95 flex items-center justify-center space-x-2 ${
            !image || loading 
              ? 'bg-gray-300 text-gray-500 cursor-not-allowed' 
              : 'bg-agro-600 text-white hover:bg-agro-700'
          }`}
        >
          {loading ? (
             <><i className="fas fa-spinner fa-spin"></i> <span>Analyzing...</span></>
          ) : (
             <><i className="fas fa-stethoscope"></i> <span>Diagnose Disease</span></>
          )}
        </button>

        {/* Result Area */}
        {result && (
          <div className="w-full bg-agro-50 border border-agro-100 p-5 rounded-xl shadow-sm animate-fade-in">
            <h3 className="text-agro-800 font-bold text-lg mb-2 flex items-center">
                <i className="fas fa-file-medical-alt mr-2"></i> Diagnosis Report
            </h3>
            <div className="prose prose-sm max-w-none text-gray-800 whitespace-pre-wrap leading-relaxed">
              {result}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default DiseaseDetector;