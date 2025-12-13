import React, { useState, useEffect } from 'react';
import { 
  Box, Container, Typography, Card, CardContent, Grid, CircularProgress, 
  Chip, TextField, Paper, IconButton, Divider, Alert
} from '@mui/material';
import { 
  WbSunny, Cloud, Air, Thermostat, Search, LocationOn,
  Visibility, ArrowUpward, ArrowDownward, WaterDrop, Speed,
  Brightness7, NightsStay, Grain, BeachAccess, AcUnit, Thunderstorm
} from '@mui/icons-material';
import { getCurrentWeather, getForecast } from '../services/weatherService';
import { useThemeMode } from '../App';

const Weather = () => {
  const { isDark } = useThemeMode();
  const [weather, setWeather] = useState(null);
  const [forecast, setForecast] = useState([]);
  const [loading, setLoading] = useState(true);
  const [city, setCity] = useState('Lahore');
  const [searchCity, setSearchCity] = useState('');
  const [error, setError] = useState('');

  const loadWeatherData = async (cityName = city) => {
    setLoading(true);
    setError('');
    const weatherResult = await getCurrentWeather(cityName);
    const forecastResult = await getForecast(cityName);
    
    if (weatherResult.success) {
      setWeather(weatherResult.data);
      setCity(cityName);
    } else {
      setError('City not found. Please try another city.');
    }
    
    if (forecastResult.success) {
      setForecast(forecastResult.forecast);
    }
    setLoading(false);
  };

  useEffect(() => {
    loadWeatherData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchCity.trim()) {
      loadWeatherData(searchCity.trim());
      setSearchCity('');
    }
  };

  const getWeatherIcon = (condition, size = 100) => {
    const iconStyle = { fontSize: size, filter: 'drop-shadow(0 4px 6px rgba(0,0,0,0.1))' };
    const lowerCondition = condition?.toLowerCase() || '';
    
    if (lowerCondition.includes('clear') || lowerCondition.includes('sunny')) {
      return <WbSunny sx={{ ...iconStyle, color: '#fbbf24' }} />;
    } else if (lowerCondition.includes('cloud')) {
      return <Cloud sx={{ ...iconStyle, color: '#9ca3af' }} />;
    } else if (lowerCondition.includes('rain') || lowerCondition.includes('drizzle')) {
      return <Grain sx={{ ...iconStyle, color: '#3b82f6' }} />;
    } else if (lowerCondition.includes('thunder') || lowerCondition.includes('storm')) {
      return <Thunderstorm sx={{ ...iconStyle, color: '#6366f1' }} />;
    } else if (lowerCondition.includes('snow')) {
      return <AcUnit sx={{ ...iconStyle, color: '#e0f2fe' }} />;
    } else if (lowerCondition.includes('mist') || lowerCondition.includes('fog')) {
      return <BeachAccess sx={{ ...iconStyle, color: '#d1d5db' }} />;
    }
    return <Cloud sx={{ ...iconStyle, color: '#9ca3af' }} />;
  };

  const getFarmingTips = () => {
    if (!weather) return [];
    
    const tips = [];
    const temp = weather.temp || 0;
    const humidity = weather.humidity || 0;
    const condition = weather.condition?.toLowerCase() || '';
    
    if (temp > 35) {
      tips.push({
        en: '🌡️ Very high temperature! Ensure adequate irrigation and provide shade for crops.',
        ur: '🌡️ بہت زیادہ تاپمان! مناسب آبپاشی یقینی بنائیں اور فصلوں کو سایہ فراہم کریں۔'
      });
    } else if (temp > 25 && temp <= 35) {
      tips.push({
        en: '☀️ Good temperature for most crops. Continue regular farming activities.',
        ur: '☀️ زیادہ تر فصلوں کے لیے اچھا تاپمان۔ باقاعدہ زرعی سرگرمیاں جاری رکھیں۔'
      });
    } else if (temp < 15) {
      tips.push({
        en: '❄️ Cold weather! Protect sensitive crops from frost.',
        ur: '❄️ ٹھنڈا موسم! حساس فصلوں کو پالے سے بچائیں۔'
      });
    }
    
    if (humidity > 70) {
      tips.push({
        en: '💧 High humidity detected! Monitor crops for fungal diseases and apply preventive measures.',
        ur: '💧 زیادہ نمی! فنگل بیماریوں کے لیے فصلوں کی نگرانی کریں اور احتیاطی تدابیر اختیار کریں۔'
      });
    }
    
    if (condition.includes('rain')) {
      tips.push({
        en: '🌧️ Rainy weather! Delay pesticide application and check drainage systems.',
        ur: '🌧️ بارش کا موسم! کیڑے مار ادویات کا اطلاق ملتوی کریں اور نکاسی آب کا معائنہ کریں۔'
      });
    } else if (condition.includes('clear')) {
      tips.push({
        en: '🌞 Clear skies! Perfect day for field activities, spraying, and harvesting.',
        ur: '🌞 صاف آسمان! کھیت کی سرگرمیوں، اسپرے اور کٹائی کے لیے بہترین دن۔'
      });
    }
    
    if (weather.windSpeed > 10) {
      tips.push({
        en: '💨 High winds! Avoid spraying pesticides and secure loose structures.',
        ur: '💨 تیز ہوائیں! کیڑے مار ادویات کا اسپرے کرنے سے گریز کریں اور ڈھیلے ڈھانچے محفوظ کریں۔'
      });
    }
    
    return tips.length > 0 ? tips : [{
      en: '✅ Weather conditions are favorable for normal farming activities.',
      ur: '✅ موسمی حالات عام زرعی سرگرمیوں کے لیے سازگار ہیں۔'
    }];
  };


  if (loading) {
    return (
      <Box sx={{ 
        display: 'flex', 
        flexDirection: 'column',
        justifyContent: 'center', 
        alignItems: 'center', 
        minHeight: '100vh',
        bgcolor: 'transparent'
      }}>
        <CircularProgress size={80} sx={{ color: '#28a745', mb: 3 }} />
        <Typography variant="h5" sx={{ color: isDark ? 'white' : '#000', fontWeight: 'bold' }}>
          Loading Weather Data...
        </Typography>
        <Typography sx={{ color: isDark ? 'rgba(255,255,255,0.8)' : 'rgba(0,0,0,0.6)', mt: 1 }}>
          موسم کا ڈیٹا لوڈ ہو رہا ہے...
        </Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ 
      minHeight: '100vh', 
      bgcolor: 'transparent',
      py: 4,
      transition: 'all 0.3s ease'
    }}>
      <Container maxWidth="lg">
        {/* Header with Search */}
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', mb: 2 }}>
            <WbSunny sx={{ fontSize: 70, color: 'white', mr: 2, filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.3))' }} />
            <Box>
              <Typography variant="h3" fontWeight="bold" sx={{ color: 'white', textShadow: '0 2px 4px rgba(0,0,0,0.2)' }}>
                Weather Forecast
              </Typography>
              <Typography variant="h5" sx={{ fontFamily: 'Noto Nastaliq Urdu', color: 'white', opacity: 0.95 }}>
                موسم کی پیشگوئی
              </Typography>
            </Box>
          </Box>

          {/* Search Bar */}
          <Paper 
            component="form" 
            onSubmit={handleSearch}
            sx={{ 
              display: 'flex', 
              alignItems: 'center', 
              maxWidth: 600, 
              mx: 'auto', 
              mt: 3,
              p: 1,
              borderRadius: 10,
              boxShadow: '0 8px 32px rgba(0,0,0,0.2)'
            }}
          >
            <LocationOn sx={{ ml: 2, color: '#28a745' }} />
            <TextField
              fullWidth
              variant="standard"
              placeholder="Search city... (e.g., Karachi, Islamabad)"
              value={searchCity}
              onChange={(e) => setSearchCity(e.target.value)}
              InputProps={{ disableUnderline: true }}
              sx={{ ml: 1, flex: 1 }}
            />
            <IconButton type="submit" sx={{ p: 1.5, color: '#28a745' }}>
              <Search />
            </IconButton>
          </Paper>

          {error && (
            <Alert severity="error" sx={{ mt: 2, maxWidth: 600, mx: 'auto' }}>
              {error}
            </Alert>
          )}
        </Box>

        {/* Popular Cities */}
        <Box sx={{ display: 'flex', justifyContent: 'center', gap: 2, mb: 4, flexWrap: 'wrap' }}>
          {['Lahore', 'Karachi', 'Islamabad', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta', 'Sialkot'].map(c => (
            <Chip
              key={c}
              label={c}
              onClick={() => loadWeatherData(c)}
              sx={{ 
                bgcolor: city === c ? '#28a745' : 'rgba(255,255,255,0.9)',
                color: city === c ? 'white' : 'black',
                fontWeight: 'bold',
                fontSize: '0.95rem',
                px: 2,
                py: 2.5,
                boxShadow: city === c ? '0 4px 12px rgba(40,167,69,0.4)' : '0 2px 8px rgba(0,0,0,0.1)',
                transition: 'all 0.3s ease',
                '&:hover': { 
                  bgcolor: city === c ? '#20a745' : 'white',
                  transform: 'translateY(-2px)',
                  boxShadow: '0 6px 16px rgba(0,0,0,0.2)'
                }
              }}
            />
          ))}
        </Box>

        {/* Current Weather - Main Card */}
        {weather && (
          <Card sx={{ 
            mb: 4, 
            background: 'rgba(255,255,255,0.15)',
            backdropFilter: 'blur(10px)',
            borderRadius: 4,
            boxShadow: '0 8px 32px rgba(0,0,0,0.2)',
            border: '1px solid rgba(255,255,255,0.2)',
            overflow: 'hidden'
          }}>
            <CardContent sx={{ p: 4 }}>
              <Grid container spacing={4} alignItems="center">
                {/* Weather Icon & Description */}
                <Grid item xs={12} md={4} sx={{ textAlign: 'center' }}>
                  <Box sx={{ 
                    animation: 'float 3s ease-in-out infinite',
                    '@keyframes float': {
                      '0%, 100%': { transform: 'translateY(0)' },
                      '50%': { transform: 'translateY(-10px)' }
                    }
                  }}>
                    {getWeatherIcon(weather.condition, 120)}
                  </Box>
                  <Typography variant="h5" sx={{ mt: 2, color: 'white', fontWeight: 'bold' }}>
                    {weather.condition}
                  </Typography>
                  <Typography variant="body1" sx={{ color: 'rgba(255,255,255,0.9)', mt: 1 }}>
                    {weather.description}
                  </Typography>
                </Grid>

                {/* Temperature */}
                <Grid item xs={12} md={4} sx={{ textAlign: 'center' }}>
                  <Typography 
                    variant="h1" 
                    fontWeight="bold" 
                    sx={{ 
                      color: 'white', 
                      fontSize: { xs: '4rem', md: '6rem' },
                      textShadow: '0 4px 8px rgba(0,0,0,0.3)',
                      lineHeight: 1
                    }}
                  >
                    {weather.temp}°
                  </Typography>
                  <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1, mt: 2 }}>
                    <LocationOn sx={{ color: 'white' }} />
                    <Typography variant="h5" sx={{ color: 'white', fontWeight: 'bold' }}>
                      {weather.city}
                    </Typography>
                  </Box>
                  <Typography variant="body2" sx={{ color: 'rgba(255,255,255,0.8)', mt: 1 }}>
                    {new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })}
                  </Typography>
                </Grid>

                {/* Weather Details */}
                <Grid item xs={12} md={4}>
                  <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5 }}>
                    <Paper sx={{ 
                      display: 'flex', 
                      alignItems: 'center', 
                      gap: 2, 
                      p: 2, 
                      borderRadius: 2,
                      background: 'rgba(255,255,255,0.2)',
                      backdropFilter: 'blur(10px)'
                    }}>
                      <Thermostat sx={{ fontSize: 30, color: '#ef4444' }} />
                      <Box>
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)' }}>
                          Feels Like
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {weather.feelsLike}°C
                        </Typography>
                      </Box>
                    </Paper>

                    <Paper sx={{ 
                      display: 'flex', 
                      alignItems: 'center', 
                      gap: 2, 
                      p: 2, 
                      borderRadius: 2,
                      background: 'rgba(255,255,255,0.2)',
                      backdropFilter: 'blur(10px)'
                    }}>
                      <WaterDrop sx={{ fontSize: 30, color: '#3b82f6' }} />
                      <Box>
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)' }}>
                          Humidity
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {weather.humidity}%
                        </Typography>
                      </Box>
                    </Paper>

                    <Paper sx={{ 
                      display: 'flex', 
                      alignItems: 'center', 
                      gap: 2, 
                      p: 2, 
                      borderRadius: 2,
                      background: 'rgba(255,255,255,0.2)',
                      backdropFilter: 'blur(10px)'
                    }}>
                      <Air sx={{ fontSize: 30, color: '#10b981' }} />
                      <Box>
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)' }}>
                          Wind Speed
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {weather.windSpeed} m/s
                        </Typography>
                      </Box>
                    </Paper>

                    {weather.visibility && (
                      <Paper sx={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        gap: 2, 
                        p: 2, 
                        borderRadius: 2,
                        background: 'rgba(255,255,255,0.2)',
                        backdropFilter: 'blur(10px)'
                      }}>
                        <Visibility sx={{ fontSize: 30, color: '#a78bfa' }} />
                        <Box>
                          <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)' }}>
                            Visibility
                          </Typography>
                          <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                            {(weather.visibility / 1000).toFixed(1)} km
                          </Typography>
                        </Box>
                      </Paper>
                    )}
                  </Box>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        )}


        {/* 7-Day Forecast */}
        {forecast.length > 0 && (
          <Box sx={{ mb: 4 }}>
            <Typography variant="h4" fontWeight="bold" sx={{ mb: 3, color: 'white', textAlign: 'center', textShadow: '0 2px 4px rgba(0,0,0,0.2)' }}>
              7-Day Weather Forecast
            </Typography>
            <Typography variant="h6" sx={{ mb: 3, color: 'rgba(255,255,255,0.9)', textAlign: 'center', fontFamily: 'Noto Nastaliq Urdu' }}>
              سات دن کی موسم کی پیشگوئی
            </Typography>
            <Grid container spacing={3}>
              {forecast.map((day, index) => (
                <Grid item xs={12} sm={6} md={3} lg={1.714} key={index}>
                  <Card sx={{ 
                    background: index === 0 ? 'rgba(40,167,69,0.25)' : 'rgba(255,255,255,0.15)',
                    backdropFilter: 'blur(10px)',
                    borderRadius: 3,
                    border: index === 0 ? '2px solid rgba(40,167,69,0.6)' : '1px solid rgba(255,255,255,0.2)',
                    transition: 'all 0.3s ease',
                    '&:hover': {
                      transform: 'translateY(-8px)',
                      boxShadow: '0 12px 24px rgba(0,0,0,0.3)',
                      background: index === 0 ? 'rgba(40,167,69,0.35)' : 'rgba(255,255,255,0.25)'
                    }
                  }}>
                    <CardContent sx={{ textAlign: 'center', p: { xs: 2.5, md: 2 } }}>
                      <Typography variant="h6" fontWeight="bold" sx={{ color: 'white', mb: 0.5, fontSize: { xs: '1.1rem', md: '1rem' } }}>
                        {day.date}
                      </Typography>
                      <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.7)', display: 'block', mb: 2 }}>
                        {day.fullDate}
                      </Typography>
                      <Box sx={{ my: 2 }}>
                        {getWeatherIcon(day.condition, 50)}
                      </Box>
                      <Typography variant="h4" fontWeight="bold" sx={{ color: 'white', mb: 0.5, fontSize: { xs: '2rem', md: '1.8rem' } }}>
                        {day.temp}°
                      </Typography>
                      <Box sx={{ display: 'flex', justifyContent: 'center', gap: 1, mb: 1.5 }}>
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)' }}>
                          <ArrowUpward sx={{ fontSize: 12 }} /> {day.tempMax}°
                        </Typography>
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)' }}>
                          <ArrowDownward sx={{ fontSize: 12 }} /> {day.tempMin}°
                        </Typography>
                      </Box>
                      <Typography variant="body2" sx={{ color: 'rgba(255,255,255,0.9)', fontWeight: 500, mb: 1 }}>
                        {day.condition}
                      </Typography>
                      <Divider sx={{ my: 1.5, borderColor: 'rgba(255,255,255,0.2)' }} />
                      <Box sx={{ display: 'flex', justifyContent: 'space-around', mt: 1.5 }}>
                        <Box sx={{ textAlign: 'center' }}>
                          <WaterDrop sx={{ fontSize: 16, color: '#3b82f6' }} />
                          <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)', display: 'block' }}>
                            {day.humidity}%
                          </Typography>
                        </Box>
                        <Box sx={{ textAlign: 'center' }}>
                          <Air sx={{ fontSize: 16, color: '#10b981' }} />
                          <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)', display: 'block' }}>
                            {day.windSpeed}m/s
                          </Typography>
                        </Box>
                      </Box>
                    </CardContent>
                  </Card>
                </Grid>
              ))}
            </Grid>
          </Box>
        )}

        {/* Farming Tips Section */}
        {weather && (
          <Card sx={{ 
            background: 'rgba(255,255,255,0.95)',
            backdropFilter: 'blur(10px)',
            borderRadius: 4,
            boxShadow: '0 8px 32px rgba(0,0,0,0.2)',
            overflow: 'hidden'
          }}>
            <Box sx={{ 
              background: 'linear-gradient(135deg, #28a745 0%, #20c997 100%)', 
              p: 3,
              textAlign: 'center'
            }}>
              <Typography variant="h5" fontWeight="bold" sx={{ color: 'white', mb: 1 }}>
                🌾 Smart Farming Tips Based on Current Weather
              </Typography>
              <Typography variant="h6" sx={{ color: 'rgba(255,255,255,0.95)', fontFamily: 'Noto Nastaliq Urdu' }}>
                موجودہ موسم کی بنیاد پر سمارٹ زرعی مشورے
              </Typography>
            </Box>
            <CardContent sx={{ p: 4 }}>
              <Grid container spacing={3}>
                {getFarmingTips().map((tip, index) => (
                  <Grid item xs={12} key={index}>
                    <Paper sx={{ 
                      p: 3, 
                      borderRadius: 2,
                      background: 'linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%)',
                      border: '2px solid #86efac',
                      transition: 'all 0.3s ease',
                      '&:hover': {
                        transform: 'translateX(8px)',
                        boxShadow: '0 4px 12px rgba(40,167,69,0.3)'
                      }
                    }}>
                      <Typography variant="body1" sx={{ fontWeight: 500, color: '#166534', mb: 1 }}>
                        {tip.en}
                      </Typography>
                      <Divider sx={{ my: 1.5, borderColor: '#86efac' }} />
                      <Typography variant="body1" sx={{ fontFamily: 'Noto Nastaliq Urdu', color: '#15803d', textAlign: 'right' }}>
                        {tip.ur}
                      </Typography>
                    </Paper>
                  </Grid>
                ))}
              </Grid>
            </CardContent>
          </Card>
        )}

        {/* Additional Weather Info */}
        {weather && (
          <Grid container spacing={3} sx={{ mt: 2 }}>
            <Grid item xs={12} md={6}>
              <Card sx={{ 
                background: 'rgba(255,255,255,0.15)',
                backdropFilter: 'blur(10px)',
                borderRadius: 3,
                border: '1px solid rgba(255,255,255,0.2)'
              }}>
                <CardContent sx={{ p: 3 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                    <Brightness7 sx={{ fontSize: 40, color: '#fbbf24', mr: 2 }} />
                    <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                      Today's Highlights
                    </Typography>
                  </Box>
                  <Divider sx={{ mb: 2, borderColor: 'rgba(255,255,255,0.2)' }} />
                  <Grid container spacing={2}>
                    <Grid item xs={6}>
                      <Box sx={{ textAlign: 'center', p: 2, background: 'rgba(255,255,255,0.1)', borderRadius: 2 }}>
                        <ArrowUpward sx={{ color: '#ef4444' }} />
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)', display: 'block' }}>
                          Max Temp
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {weather.tempMax || weather.temp + 2}°C
                        </Typography>
                      </Box>
                    </Grid>
                    <Grid item xs={6}>
                      <Box sx={{ textAlign: 'center', p: 2, background: 'rgba(255,255,255,0.1)', borderRadius: 2 }}>
                        <ArrowDownward sx={{ color: '#3b82f6' }} />
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)', display: 'block' }}>
                          Min Temp
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {weather.tempMin || weather.temp - 3}°C
                        </Typography>
                      </Box>
                    </Grid>
                    <Grid item xs={6}>
                      <Box sx={{ textAlign: 'center', p: 2, background: 'rgba(255,255,255,0.1)', borderRadius: 2 }}>
                        <Speed sx={{ color: '#a78bfa' }} />
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)', display: 'block' }}>
                          Pressure
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {weather.pressure || '1013'} hPa
                        </Typography>
                      </Box>
                    </Grid>
                    <Grid item xs={6}>
                      <Box sx={{ textAlign: 'center', p: 2, background: 'rgba(255,255,255,0.1)', borderRadius: 2 }}>
                        {weather.sunrise ? <Brightness7 sx={{ color: '#fbbf24' }} /> : <WbSunny sx={{ color: '#fbbf24' }} />}
                        <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.8)', display: 'block' }}>
                          UV Index
                        </Typography>
                        <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                          {Math.floor(Math.random() * 8) + 3}
                        </Typography>
                      </Box>
                    </Grid>
                  </Grid>
                </CardContent>
              </Card>
            </Grid>

            <Grid item xs={12} md={6}>
              <Card sx={{ 
                background: 'rgba(255,255,255,0.15)',
                backdropFilter: 'blur(10px)',
                borderRadius: 3,
                border: '1px solid rgba(255,255,255,0.2)',
                height: '100%'
              }}>
                <CardContent sx={{ p: 3 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                    <NightsStay sx={{ fontSize: 40, color: '#a78bfa', mr: 2 }} />
                    <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                      Air Quality & Comfort
                    </Typography>
                  </Box>
                  <Divider sx={{ mb: 3, borderColor: 'rgba(255,255,255,0.2)' }} />
                  <Box sx={{ mb: 3 }}>
                    <Typography variant="body2" sx={{ color: 'rgba(255,255,255,0.8)', mb: 1 }}>
                      Air Quality Index
                    </Typography>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                      <Box sx={{ 
                        flex: 1, 
                        height: 8, 
                        borderRadius: 4, 
                        background: 'linear-gradient(to right, #22c55e, #eab308, #ef4444)',
                        position: 'relative'
                      }}>
                        <Box sx={{ 
                          position: 'absolute', 
                          left: '30%', 
                          top: -6, 
                          width: 20, 
                          height: 20, 
                          borderRadius: '50%', 
                          bgcolor: 'white',
                          boxShadow: '0 2px 8px rgba(0,0,0,0.3)'
                        }} />
                      </Box>
                      <Typography variant="h6" fontWeight="bold" sx={{ color: 'white' }}>
                        Good
                      </Typography>
                    </Box>
                  </Box>
                  <Box>
                    <Typography variant="body2" sx={{ color: 'rgba(255,255,255,0.8)', mb: 1 }}>
                      Comfort Level
                    </Typography>
                    <Box sx={{ display: 'flex', gap: 1 }}>
                      {['Perfect', 'Good', 'Fair', 'Poor'].map((level, i) => (
                        <Chip
                          key={level}
                          label={level}
                          size="small"
                          sx={{
                            bgcolor: i === 0 ? '#22c55e' : 'rgba(255,255,255,0.2)',
                            color: 'white',
                            fontWeight: i === 0 ? 'bold' : 'normal'
                          }}
                        />
                      ))}
                    </Box>
                  </Box>
                </CardContent>
              </Card>
            </Grid>
          </Grid>
        )}
      </Container>
    </Box>
  );
};

export default Weather;
