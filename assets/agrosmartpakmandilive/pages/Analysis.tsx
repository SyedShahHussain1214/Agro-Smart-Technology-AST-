import React from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from 'recharts';

// Mock historical data for visualization since we don't have a historical API
const data = [
  { name: 'Mon', potato: 60, onion: 120, tomato: 150 },
  { name: 'Tue', potato: 62, onion: 118, tomato: 145 },
  { name: 'Wed', potato: 65, onion: 125, tomato: 160 },
  { name: 'Thu', potato: 63, onion: 130, tomato: 155 },
  { name: 'Fri', potato: 60, onion: 128, tomato: 150 },
  { name: 'Sat', potato: 58, onion: 135, tomato: 140 },
  { name: 'Sun', potato: 60, onion: 140, tomato: 135 },
];

const Analysis: React.FC = () => {
  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Market Trends</h1>
        <p className="text-slate-500 mt-1">Weekly analysis of major vegetable prices</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Price Trend Chart */}
        <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
          <h3 className="text-lg font-bold text-slate-800 mb-6">Price Fluctuation (Last 7 Days)</h3>
          <div className="h-80 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={data}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0" />
                <XAxis dataKey="name" stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} tickFormatter={(value) => `Rs.${value}`} />
                <Tooltip 
                  contentStyle={{ backgroundColor: '#fff', borderRadius: '8px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                />
                <Line type="monotone" dataKey="potato" stroke="#ca8a04" strokeWidth={2} dot={{ r: 4 }} activeDot={{ r: 6 }} name="Potato" />
                <Line type="monotone" dataKey="onion" stroke="#be123c" strokeWidth={2} dot={{ r: 4 }} activeDot={{ r: 6 }} name="Onion" />
                <Line type="monotone" dataKey="tomato" stroke="#0ea5e9" strokeWidth={2} dot={{ r: 4 }} activeDot={{ r: 6 }} name="Tomato" />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Volume/Comparison Chart */}
        <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
          <h3 className="text-lg font-bold text-slate-800 mb-6">Average Price Comparison</h3>
          <div className="h-80 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={data}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0" />
                <XAxis dataKey="name" stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip 
                  cursor={{ fill: '#f1f5f9' }}
                  contentStyle={{ backgroundColor: '#fff', borderRadius: '8px', border: '1px solid #e2e8f0' }}
                />
                <Bar dataKey="potato" fill="#ca8a04" radius={[4, 4, 0, 0]} name="Potato" />
                <Bar dataKey="onion" fill="#be123c" radius={[4, 4, 0, 0]} name="Onion" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Analysis;