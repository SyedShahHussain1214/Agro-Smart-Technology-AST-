import React from 'react';
import { MOCK_MARKET_ITEMS } from '../constants';
import { MarketItem } from '../types';

const Marketplace: React.FC = () => {
  return (
    <div className="flex flex-col h-full bg-gray-50 pb-20 overflow-y-auto no-scrollbar">
      {/* Header */}
      <div className="bg-soil-500 text-white p-6 rounded-b-3xl shadow-lg sticky top-0 z-10">
        <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Agro Market</h2>
            <button className="bg-white/20 p-2 rounded-full backdrop-blur-sm">
                <i className="fas fa-plus text-white"></i>
            </button>
        </div>
        <div className="relative">
            <i className="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-300"></i>
            <input 
                type="text" 
                placeholder="Search crops, seeds, machinery..." 
                className="w-full bg-white/10 border border-white/30 rounded-xl py-3 pl-10 pr-4 text-white placeholder-gray-200 focus:outline-none focus:bg-white/20"
            />
        </div>
      </div>

      {/* Categories */}
      <div className="flex space-x-4 p-4 overflow-x-auto no-scrollbar">
         {['All', 'Vegetables', 'Fruits', 'Machinery', 'Seeds', 'Fertilizer'].map((cat, idx) => (
             <button key={idx} className={`px-5 py-2 rounded-full text-sm font-medium whitespace-nowrap ${idx === 0 ? 'bg-soil-500 text-white' : 'bg-white text-gray-600 border border-gray-200'}`}>
                 {cat}
             </button>
         ))}
      </div>

      {/* Listings */}
      <div className="px-4 grid grid-cols-2 gap-4">
        {MOCK_MARKET_ITEMS.map((item: MarketItem) => (
            <div key={item.id} className="bg-white p-3 rounded-xl shadow-sm border border-gray-100 flex flex-col">
                <div className="h-32 rounded-lg overflow-hidden mb-3 relative bg-gray-100">
                    <img src={item.image} alt={item.name} className="w-full h-full object-cover" />
                    <span className={`absolute top-2 left-2 text-xs font-bold px-2 py-1 rounded text-white ${item.type === 'sell' ? 'bg-green-500' : 'bg-blue-500'}`}>
                        {item.type.toUpperCase()}
                    </span>
                </div>
                <h3 className="font-bold text-gray-800 line-clamp-1">{item.name}</h3>
                <div className="flex justify-between items-end mt-2">
                    <div>
                        <p className="text-soil-500 font-bold">Rs. {item.price}</p>
                        <p className="text-xs text-gray-400">/{item.unit}</p>
                    </div>
                </div>
                <div className="mt-3 pt-3 border-t border-gray-100 flex justify-between items-center">
                    <div className="flex items-center text-xs text-gray-500">
                        <i className="fas fa-map-marker-alt mr-1"></i> {item.location}
                    </div>
                    <button className="bg-green-100 text-green-700 w-8 h-8 rounded-full flex items-center justify-center">
                        <i className="fas fa-phone"></i>
                    </button>
                </div>
            </div>
        ))}
      </div>
    </div>
  );
};

export default Marketplace;
