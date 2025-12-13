import React from 'react';
import { MOCK_PRICES } from '../constants';

const MarketPrices: React.FC = () => {
  return (
    <div className="flex flex-col h-full bg-white pb-20 overflow-y-auto no-scrollbar">
      <div className="bg-blue-600 text-white p-6 rounded-b-3xl shadow-lg mb-4">
        <h2 className="text-2xl font-bold mb-1">Mandi Rates</h2>
        <p className="opacity-90 text-sm">Daily updated prices from Punjab Markets</p>
        <p className="text-xs opacity-75 mt-2"><i className="fas fa-clock"></i> Updated: Today, 8:00 AM</p>
      </div>

      <div className="px-4 space-y-3">
        {MOCK_PRICES.map((item, idx) => (
            <div key={idx} className="bg-white border border-gray-100 rounded-xl p-4 shadow-sm flex items-center justify-between">
                <div>
                    <h3 className="font-bold text-gray-800 text-lg">{item.crop}</h3>
                    <p className="text-gray-500 text-sm">Per 40kg (Maund)</p>
                </div>
                <div className="text-right">
                    <div className="font-bold text-xl text-blue-600">
                        {item.min} - {item.max}
                    </div>
                    <div className={`text-xs font-medium flex items-center justify-end ${
                        item.trend === 'up' ? 'text-green-500' : item.trend === 'down' ? 'text-red-500' : 'text-gray-400'
                    }`}>
                        {item.trend === 'up' && <i className="fas fa-arrow-up mr-1"></i>}
                        {item.trend === 'down' && <i className="fas fa-arrow-down mr-1"></i>}
                        {item.trend === 'stable' && <i className="fas fa-minus mr-1"></i>}
                        {item.trend.toUpperCase()}
                    </div>
                </div>
            </div>
        ))}
      </div>

      <div className="mt-6 mx-4 p-4 bg-yellow-50 rounded-xl border border-yellow-200">
        <div className="flex items-start">
            <i className="fas fa-lightbulb text-yellow-500 mt-1 mr-3"></i>
            <p className="text-sm text-yellow-800">
                <strong>Tip:</strong> Wheat prices are expected to rise next week due to high export demand. Hold your stock if possible.
            </p>
        </div>
      </div>
    </div>
  );
};

export default MarketPrices;
