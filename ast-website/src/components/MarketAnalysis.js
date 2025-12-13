import React, { useState, useEffect } from 'react';
import {
  Box,
  Container,
  Typography,
  Card,
  CardContent,
  Grid,
  Paper,
  Chip,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Alert
} from '@mui/material';
import { useThemeMode } from '../App';
import {
  TrendingUp,
  ShowChart,
  Assessment
} from '@mui/icons-material';
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend
} from 'recharts';

// Mock historical data - in production, this would come from an API
const generateHistoricalData = (city) => {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const baseData = {
    Lahore: { potato: 45, onion: 70, tomato: 40, wheat: 1900, rice: 150 },
    Karachi: { potato: 50, onion: 75, tomato: 45, wheat: 1950, rice: 160 },
    Islamabad: { potato: 48, onion: 72, tomato: 42, wheat: 1920, rice: 155 },
    Multan: { potato: 42, onion: 68, tomato: 38, wheat: 1880, rice: 145 },
    Faisalabad: { potato: 44, onion: 69, tomato: 39, wheat: 1890, rice: 148 },
    Peshawar: { potato: 46, onion: 71, tomato: 41, wheat: 1910, rice: 152 }
  };

  const base = baseData[city] || baseData.Lahore;
  
  return days.map((day, index) => {
    const variance = (Math.random() - 0.5) * 10;
    return {
      name: day,
      potato: Math.round(base.potato + variance + (index * 0.5)),
      onion: Math.round(base.onion + variance + (index * 0.8)),
      tomato: Math.round(base.tomato + variance - (index * 0.3)),
      wheat: Math.round(base.wheat + (variance * 2)),
      rice: Math.round(base.rice + variance + (index * 0.5))
    };
  });
};

const CITIES = ['Lahore', 'Karachi', 'Islamabad', 'Multan', 'Faisalabad', 'Peshawar'];

const MarketAnalysis = () => {
  const { isDark } = useThemeMode();
  const [selectedCity, setSelectedCity] = useState('Lahore');
  const [chartData, setChartData] = useState([]);
  const [insights, setInsights] = useState([]);

  useEffect(() => {
    const data = generateHistoricalData(selectedCity);
    setChartData(data);
    
    // Calculate insights
    const lastDay = data[data.length - 1];
    const firstDay = data[0];
    
    const calculateChange = (current, previous) => {
      const change = ((current - previous) / previous * 100).toFixed(1);
      return { change, trend: change > 0 ? 'up' : change < 0 ? 'down' : 'stable' };
    };

    setInsights([
      {
        item: 'Potato',
        ...calculateChange(lastDay.potato, firstDay.potato),
        current: lastDay.potato
      },
      {
        item: 'Onion',
        ...calculateChange(lastDay.onion, firstDay.onion),
        current: lastDay.onion
      },
      {
        item: 'Tomato',
        ...calculateChange(lastDay.tomato, firstDay.tomato),
        current: lastDay.tomato
      },
      {
        item: 'Wheat (40kg)',
        ...calculateChange(lastDay.wheat, firstDay.wheat),
        current: lastDay.wheat
      },
      {
        item: 'Rice',
        ...calculateChange(lastDay.rice, firstDay.rice),
        current: lastDay.rice
      }
    ]);
  }, [selectedCity]);

  const getTrendColor = (trend) => {
    switch (trend) {
      case 'up': return '#ef4444';
      case 'down': return '#10b981';
      default: return '#6b7280';
    }
  };

  const getTrendLabel = (change, trend) => {
    if (trend === 'stable') return 'No change';
    return `${Math.abs(change)}% ${trend === 'up' ? 'increase' : 'decrease'}`;
  };

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'transparent', py: 4 }}>
      <Container maxWidth="lg">
        {/* Header */}
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <Assessment sx={{ 
            fontSize: 60, 
            color: isDark ? '#4ade80' : '#28a745', 
            mb: 2,
            filter: isDark ? 'drop-shadow(0 2px 8px rgba(74, 222, 128, 0.5))' : 'none'
          }} />
          <Typography 
            variant="h3" 
            fontWeight="bold" 
            gutterBottom
            sx={{ 
              color: isDark ? '#4ade80' : '#28a745',
              textShadow: isDark ? '0 2px 8px rgba(74, 222, 128, 0.5)' : '0 2px 4px rgba(0,0,0,0.1)'
            }}
          >
            Market Trends Analysis
          </Typography>
          <Typography 
            variant="h5" 
            sx={{ 
              fontFamily: 'Noto Nastaliq Urdu', 
              color: isDark ? '#4ade80' : '#28a745', 
              mb: 2,
              textShadow: isDark ? '0 2px 8px rgba(74, 222, 128, 0.5)' : '0 2px 4px rgba(0,0,0,0.1)'
            }}
          >
            منڈی کے رجحانات کا تجزیہ
          </Typography>
          <Typography 
            variant="body1" 
            sx={{ color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)' }}
          >
            7-Day Price Fluctuation Analysis — ہفتے بھر کی قیمتوں کا تجزیہ
          </Typography>
        </Box>

        {/* City Selector */}
        <Paper elevation={2} sx={{ 
          p: 3, 
          mb: 4, 
          borderRadius: 2,
          bgcolor: isDark ? 'rgba(26, 31, 53, 0.85)' : 'rgba(255, 255, 255, 0.85)',
          backdropFilter: 'blur(12px) saturate(180%)',
          WebkitBackdropFilter: 'blur(12px) saturate(180%)',
          border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
          boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
        }}>
          <FormControl fullWidth>
            <InputLabel sx={{ color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)' }}>
              Select City for Analysis — تجزیہ کے لیے شہر منتخب کریں
            </InputLabel>
            <Select
              value={selectedCity}
              label="Select City for Analysis — تجزیہ کے لیے شہر منتخب کریں"
              onChange={(e) => setSelectedCity(e.target.value)}
              sx={{
                color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)',
                '& .MuiOutlinedInput-notchedOutline': {
                  borderColor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(40, 167, 69, 0.2)'
                },
                '&:hover .MuiOutlinedInput-notchedOutline': {
                  borderColor: isDark ? 'rgba(74, 222, 128, 0.4)' : 'rgba(40, 167, 69, 0.4)'
                },
                '& .MuiSvgIcon-root': {
                  color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.54)'
                }
              }}
            >
              {CITIES.map(city => (
                <MenuItem key={city} value={city}>
                  {city}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Paper>

        {/* Info Alert */}
        <Alert 
          severity="info" 
          sx={{ 
            mb: 4,
            bgcolor: isDark ? 'rgba(59, 130, 246, 0.15)' : 'rgba(219, 234, 254, 0.9)',
            color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)',
            backdropFilter: 'blur(12px)',
            border: isDark ? '1px solid rgba(59, 130, 246, 0.2)' : '1px solid rgba(59, 130, 246, 0.1)',
            '& .MuiAlert-icon': {
              color: isDark ? '#60a5fa' : '#3b82f6'
            }
          }}
        >
          <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)' }}>
            <strong>Note:</strong> This analysis shows historical trends based on recent market data. 
            Actual prices may vary. For current rates, check the Real-Time Mandi Rates page.
          </Typography>
        </Alert>

        {/* Charts Section */}
        <Grid container spacing={4} sx={{ mb: 4 }}>
          {/* Line Chart - Price Fluctuation */}
          <Grid item xs={12} lg={6}>
            <Card elevation={3} sx={{ 
              height: '100%', 
              borderRadius: 2,
              bgcolor: isDark ? 'rgba(26, 31, 53, 0.90)' : 'rgba(255, 255, 255, 0.90)',
              backdropFilter: 'blur(12px) saturate(180%)',
              WebkitBackdropFilter: 'blur(12px) saturate(180%)',
              border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
              boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
            }}>
              <CardContent>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                  <ShowChart sx={{ 
                    fontSize: 30, 
                    color: isDark ? '#4ade80' : '#28a745', 
                    mr: 1 
                  }} />
                  <Typography variant="h6" fontWeight="bold" sx={{ 
                    color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
                  }}>
                    Price Fluctuation (Last 7 Days)
                  </Typography>
                </Box>
                <Typography variant="body2" sx={{ 
                  mb: 3,
                  color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
                }}>
                  Track daily price changes for major commodities
                </Typography>
                <Box sx={{ height: 400 }}>
                  <ResponsiveContainer width="100%" height="100%">
                    <LineChart data={chartData}>
                      <CartesianGrid 
                        strokeDasharray="3 3" 
                        stroke={isDark ? 'rgba(255,255,255,0.1)' : '#e5e7eb'} 
                      />
                      <XAxis 
                        dataKey="name" 
                        stroke={isDark ? 'rgba(255,255,255,0.7)' : '#6b7280'} 
                        style={{ fontSize: '12px' }}
                      />
                      <YAxis 
                        stroke={isDark ? 'rgba(255,255,255,0.7)' : '#6b7280'} 
                        style={{ fontSize: '12px' }}
                        tickFormatter={(value) => `Rs.${value}`}
                      />
                      <Tooltip 
                        contentStyle={{ 
                          backgroundColor: isDark ? 'rgba(26, 31, 53, 0.95)' : '#fff', 
                          borderRadius: '8px', 
                          border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid #e5e7eb',
                          boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)',
                          color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)'
                        }}
                        labelStyle={{ color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' }}
                        formatter={(value) => [`Rs.${value}`, '']}
                      />
                      <Legend />
                      <Line 
                        type="monotone" 
                        dataKey="potato" 
                        stroke="#ca8a04" 
                        strokeWidth={2} 
                        dot={{ r: 4 }} 
                        activeDot={{ r: 6 }}
                        name="Potato"
                      />
                      <Line 
                        type="monotone" 
                        dataKey="onion" 
                        stroke="#be123c" 
                        strokeWidth={2} 
                        dot={{ r: 4 }} 
                        activeDot={{ r: 6 }}
                        name="Onion"
                      />
                      <Line 
                        type="monotone" 
                        dataKey="tomato" 
                        stroke="#0ea5e9" 
                        strokeWidth={2} 
                        dot={{ r: 4 }} 
                        activeDot={{ r: 6 }}
                        name="Tomato"
                      />
                    </LineChart>
                  </ResponsiveContainer>
                </Box>
              </CardContent>
            </Card>
          </Grid>

          {/* Bar Chart - Average Price Comparison */}
          <Grid item xs={12} lg={6}>
            <Card elevation={3} sx={{ 
              height: '100%', 
              borderRadius: 2,
              bgcolor: isDark ? 'rgba(26, 31, 53, 0.90)' : 'rgba(255, 255, 255, 0.90)',
              backdropFilter: 'blur(12px) saturate(180%)',
              WebkitBackdropFilter: 'blur(12px) saturate(180%)',
              border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
              boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
            }}>
              <CardContent>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                  <TrendingUp sx={{ 
                    fontSize: 30, 
                    color: isDark ? '#4ade80' : '#28a745', 
                    mr: 1 
                  }} />
                  <Typography variant="h6" fontWeight="bold" sx={{ 
                    color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
                  }}>
                    Average Price Comparison
                  </Typography>
                </Box>
                <Typography variant="body2" sx={{ 
                  mb: 3,
                  color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
                }}>
                  Weekly average prices across different days
                </Typography>
                <Box sx={{ height: 400 }}>
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={chartData}>
                      <CartesianGrid 
                        strokeDasharray="3 3" 
                        stroke={isDark ? 'rgba(255,255,255,0.1)' : '#e5e7eb'} 
                      />
                      <XAxis 
                        dataKey="name" 
                        stroke={isDark ? 'rgba(255,255,255,0.7)' : '#6b7280'}
                        style={{ fontSize: '12px' }}
                      />
                      <YAxis 
                        stroke={isDark ? 'rgba(255,255,255,0.7)' : '#6b7280'}
                        style={{ fontSize: '12px' }}
                      />
                      <Tooltip 
                        cursor={{ fill: isDark ? 'rgba(74, 222, 128, 0.1)' : '#f9fafb' }}
                        contentStyle={{ 
                          backgroundColor: isDark ? 'rgba(26, 31, 53, 0.95)' : '#fff', 
                          borderRadius: '8px',
                          border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid #e5e7eb',
                          color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)'
                        }}
                        labelStyle={{ color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' }}
                        formatter={(value) => [`Rs.${value}`, '']}
                      />
                      <Legend />
                      <Bar 
                        dataKey="potato" 
                        fill="#ca8a04" 
                        radius={[4, 4, 0, 0]}
                        name="Potato"
                      />
                      <Bar 
                        dataKey="onion" 
                        fill="#be123c" 
                        radius={[4, 4, 0, 0]}
                        name="Onion"
                      />
                    </BarChart>
                  </ResponsiveContainer>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        </Grid>

        {/* Weekly Insights */}
        <Card elevation={3} sx={{ 
          borderRadius: 2,
          bgcolor: isDark ? 'rgba(26, 31, 53, 0.90)' : 'rgba(255, 255, 255, 0.90)',
          backdropFilter: 'blur(12px) saturate(180%)',
          WebkitBackdropFilter: 'blur(12px) saturate(180%)',
          border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
          boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
        }}>
          <CardContent>
            <Typography variant="h6" fontWeight="bold" gutterBottom sx={{ 
              color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
            }}>
              Weekly Price Changes — ہفتہ وار قیمتوں میں تبدیلی
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 3,
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              Comparing Sunday's prices with Monday's opening prices
            </Typography>
            <Grid container spacing={2}>
              {insights.map((insight, index) => (
                <Grid item xs={12} sm={6} md={4} key={index}>
                  <Paper 
                    elevation={1} 
                    sx={{ 
                      p: 2, 
                      borderLeft: `4px solid ${getTrendColor(insight.trend)}`,
                      bgcolor: isDark ? 'rgba(26, 31, 53, 0.5)' : 'rgba(255, 255, 255, 0.8)',
                      backdropFilter: 'blur(8px)',
                      border: isDark ? '1px solid rgba(74, 222, 128, 0.1)' : '1px solid rgba(40, 167, 69, 0.05)',
                      transition: 'all 0.3s ease',
                      '&:hover': {
                        transform: 'translateX(4px)',
                        boxShadow: isDark ? 4 : 3,
                        borderLeftWidth: '6px'
                      }
                    }}
                  >
                    <Typography variant="subtitle2" fontWeight="bold" gutterBottom sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
                    }}>
                      {insight.item}
                    </Typography>
                    <Typography variant="h5" fontWeight="bold" color={getTrendColor(insight.trend)}>
                      Rs.{insight.current}
                    </Typography>
                    <Chip
                      label={getTrendLabel(insight.change, insight.trend)}
                      size="small"
                      sx={{
                        mt: 1,
                        bgcolor: getTrendColor(insight.trend),
                        color: 'white',
                        fontWeight: 'bold'
                      }}
                    />
                  </Paper>
                </Grid>
              ))}
            </Grid>
          </CardContent>
        </Card>

        {/* Additional Info */}
        <Paper elevation={2} sx={{ 
          p: 3, 
          mt: 4, 
          bgcolor: isDark 
            ? 'rgba(74, 222, 128, 0.15)' 
            : 'rgba(240, 253, 244, 0.9)', 
          borderRadius: 2,
          backdropFilter: 'blur(12px)',
          border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)'
        }}>
          <Typography variant="body2" textAlign="center" sx={{ 
            color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)' 
          }}>
            💡 <strong>Tip:</strong> Green indicators show price decreases (good for buyers), 
            while red indicators show price increases. Use this data to plan your purchases wisely.
          </Typography>
        </Paper>
      </Container>
    </Box>
  );
};

export default MarketAnalysis;
