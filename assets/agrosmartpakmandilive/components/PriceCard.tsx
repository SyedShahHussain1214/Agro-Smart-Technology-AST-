import React from 'react';
import { MarketItem } from '../types';
import { TrendingUp, TrendingDown, Minus } from 'lucide-react';

interface PriceCardProps {
  item: MarketItem;
}

const PriceCard: React.FC<PriceCardProps> = ({ item }) => {
  const isUp = item.trend === 'up';
  const isDown = item.trend === 'down';

  return (
    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-5 hover:shadow-md transition-shadow">
      <div className="flex justify-between items-start mb-4">
        <div>
          <span className={`inline-block px-2 py-1 rounded-full text-xs font-medium mb-2 ${
            item.category === 'Vegetable' ? 'bg-green-100 text-green-700' :
            item.category === 'Fruit' ? 'bg-orange-100 text-orange-700' :
            'bg-blue-100 text-blue-700'
          }`}>
            {item.category}
          </span>
          <h3 className="font-bold text-slate-800 text-lg">{item.name}</h3>
          <p className="text-slate-500 text-sm">{item.city} Mandi</p>
        </div>
        <div className={`p-2 rounded-full ${
          isUp ? 'bg-red-50 text-red-500' : 
          isDown ? 'bg-green-50 text-green-500' : 
          'bg-slate-50 text-slate-400'
        }`}>
          {isUp ? <TrendingUp size={20} /> : isDown ? <TrendingDown size={20} /> : <Minus size={20} />}
        </div>
      </div>

      <div className="flex items-end justify-between">
        <div>
          <p className="text-sm text-slate-400 mb-1">Price per {item.unit}</p>
          <div className="flex items-baseline space-x-1">
            <span className="text-2xl font-bold text-slate-900">Rs. {item.maxPrice}</span>
            {item.minPrice !== item.maxPrice && (
                <span className="text-sm text-slate-500"> - {item.minPrice}</span>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PriceCard;