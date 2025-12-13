import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Box, 
  Container, 
  Typography, 
  Card, 
  CardContent, 
  Grid, 
  Chip, 
  TextField, 
  CircularProgress,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Button,
  Alert,
  Paper,
  Skeleton,
  Link
} from '@mui/material';
import { 
  TrendingUp, 
  TrendingDown, 
  Remove, 
  Search, 
  Refresh,
  LocationOn,
  Schedule,
  Assessment
} from '@mui/icons-material';
import { fetchLiveMandiRates } from '../services/geminiMandiService';
import { useThemeMode } from '../App';

const CITIES = ['Lahore', 'Karachi', 'Islamabad', 'Multan', 'Faisalabad', 'Peshawar'];

const MandiRates = () => {
  const { isDark } = useThemeMode();
  const navigate = useNavigate();
  const [rates, setRates] = useState([]);
  const [filteredRates, setFilteredRates] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedCity, setSelectedCity] = useState('Lahore');
  const [searchQuery, setSearchQuery] = useState('');
  const [sources, setSources] = useState([]);
  const [lastFetched, setLastFetched] = useState(null);
  const [error, setError] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const [isLiveData, setIsLiveData] = useState(false);

  const loadMandiRates = async (showRefreshLoader = false) => {
    if (showRefreshLoader) {
      setRefreshing(true);
    } else {
      setLoading(true);
    }
    setError(null);

    try {
      console.log(`Fetching mandi rates for ${selectedCity}...`);
      const result = await fetchLiveMandiRates(selectedCity);
      console.log('Fetch result:', result);
      
      if (result.items && result.items.length > 0) {
        setRates(result.items);
        setFilteredRates(result.items);
        setSources(result.sources || []);
        setLastFetched(result.lastFetched || new Date().toISOString());
        setIsLiveData(result.isLiveData || false);
        
        if (result.error) {
          setError(result.error);
        } else if (result.isLiveData) {
          // Show success message for live data
          console.log('✅ Successfully loaded LIVE data from real sources!');
        }
      } else {
        setError('No market data available for this city');
      }
    } catch (err) {
      console.error('Error loading mandi rates:', err);
      setError('Failed to fetch market rates. Please try again.');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    loadMandiRates();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedCity]);

  useEffect(() => {
    if (searchQuery) {
      const filtered = rates.filter(rate => 
        rate.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        rate.category.toLowerCase().includes(searchQuery.toLowerCase())
      );
      setFilteredRates(filtered);
    } else {
      setFilteredRates(rates);
    }
  }, [searchQuery, rates]);

  const getTrendIcon = (trend) => {
    switch (trend) {
      case 'up': return <TrendingUp sx={{ color: '#10b981', fontSize: 24 }} />;
      case 'down': return <TrendingDown sx={{ color: '#ef4444', fontSize: 24 }} />;
      default: return <Remove sx={{ color: '#6b7280', fontSize: 24 }} />;
    }
  };

  const getTrendColor = (trend) => {
    switch (trend) {
      case 'up': return '#10b981';
      case 'down': return '#ef4444';
      default: return '#6b7280';
    }
  };

  const getTrendLabel = (trend) => {
    switch (trend) {
      case 'up': return 'Increasing';
      case 'down': return 'Decreasing';
      default: return 'Stable';
    }
  };

  const getCategoryColor = (category) => {
    switch (category.toLowerCase()) {
      case 'vegetable': return '#10b981';
      case 'fruit': return '#f59e0b';
      case 'grain': return '#8b5cf6';
      default: return '#6b7280';
    }
  };

  if (loading) {
    return (
      <Box sx={{ minHeight: '100vh', bgcolor: 'transparent', py: 4 }}>
        <Container maxWidth="lg">
          <Box sx={{ textAlign: 'center', mb: 4 }}>
            <Skeleton variant="circular" width={60} height={60} sx={{ mx: 'auto', mb: 2 }} />
            <Skeleton variant="text" width="40%" sx={{ mx: 'auto', fontSize: '2rem' }} />
            <Skeleton variant="text" width="30%" sx={{ mx: 'auto' }} />
          </Box>
          <Grid container spacing={3}>
            {[1, 2, 3, 4, 5, 6].map(i => (
              <Grid item xs={12} sm={6} md={4} key={i}>
                <Skeleton variant="rectangular" height={200} sx={{ borderRadius: 2 }} />
              </Grid>
            ))}
          </Grid>
        </Container>
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'transparent', py: 4 }}>
      <Container maxWidth="lg">
        {/* Header */}
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <TrendingUp sx={{ fontSize: 60, color: '#28a745', mb: 2 }} />
          <Typography variant="h3" fontWeight="bold" color="#28a745" gutterBottom>
            Real-Time Mandi Rates
          </Typography>
          <Typography variant="h5" sx={{ fontFamily: 'Noto Nastaliq Urdu', color: '#28a745', mb: 2 }}>
            منڈی کے تازہ ریٹ - لائیو
          </Typography>
          <Typography variant="body1" color="text.secondary">
            Latest market prices powered by AI — ایل آئی سے تازہ ترین منڈی ریٹ
          </Typography>
          {lastFetched && (
            <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 2, mt: 1 }}>
              <Typography variant="caption" color="text.secondary" sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                <Schedule fontSize="small" />
                Last updated: {new Date(lastFetched).toLocaleString()}
              </Typography>
              {isLiveData && (
                <Chip 
                  label="LIVE DATA ✓" 
                  size="small" 
                  sx={{ 
                    bgcolor: '#10b981', 
                    color: 'white', 
                    fontWeight: 'bold',
                    animation: 'pulse 2s infinite'
                  }} 
                />
              )}
            </Box>
          )}
        </Box>

        {/* Error Alert */}
        {error && (
          <Alert severity={isLiveData ? "info" : "warning"} sx={{ mb: 3 }}>
            {error}
          </Alert>
        )}

        {/* Live Data Success Alert */}
        {!error && isLiveData && sources.length > 0 && (
          <Alert severity="success" sx={{ mb: 3 }}>
            ✅ Live data fetched successfully from {sources.length} real source{sources.length > 1 ? 's' : ''}! 
            All prices are current as of {new Date(lastFetched).toLocaleString()}.
          </Alert>
        )}

        {/* Controls */}
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
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} md={4}>
              <FormControl fullWidth>
                <InputLabel sx={{ color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)' }}>
                  <LocationOn fontSize="small" sx={{ mr: 0.5, verticalAlign: 'middle' }} />
                  Select City — شہر منتخب کریں
                </InputLabel>
                <Select
                  value={selectedCity}
                  label="Select City — شہر منتخب کریں"
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
            </Grid>
            
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                placeholder="Search crops... فصل تلاش کریں"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                sx={{
                  '& .MuiOutlinedInput-root': {
                    color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)',
                    '& fieldset': {
                      borderColor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(40, 167, 69, 0.2)'
                    },
                    '&:hover fieldset': {
                      borderColor: isDark ? 'rgba(74, 222, 128, 0.4)' : 'rgba(40, 167, 69, 0.4)'
                    }
                  },
                  '& .MuiInputBase-input::placeholder': {
                    color: isDark ? 'rgba(255,255,255,0.5)' : 'rgba(0,0,0,0.5)',
                    opacity: 1
                  }
                }}
                InputProps={{
                  startAdornment: <Search sx={{ mr: 1, color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.54)' }} />
                }}
              />
            </Grid>

            <Grid item xs={12} md={2}>
              <Button
                fullWidth
                variant="contained"
                startIcon={refreshing ? <CircularProgress size={20} color="inherit" /> : <Refresh />}
                onClick={() => loadMandiRates(true)}
                disabled={refreshing}
                sx={{ 
                  bgcolor: isDark ? '#4ade80' : '#28a745', 
                  '&:hover': { bgcolor: isDark ? '#22c55e' : '#218838' },
                  color: isDark ? '#000' : '#fff',
                  fontWeight: 'bold',
                  height: 56,
                  boxShadow: isDark ? '0 4px 12px rgba(74, 222, 128, 0.3)' : '0 2px 8px rgba(40, 167, 69, 0.2)'
                }}
              >
                {refreshing ? 'Loading...' : 'Refresh'}
              </Button>
            </Grid>
          </Grid>
        </Paper>

        {/* Stats Summary */}
        <Grid container spacing={2} sx={{ mb: 4 }}>
          <Grid item xs={12} sm={4}>
            <Card sx={{ 
              bgcolor: isDark 
                ? 'rgba(74, 222, 128, 0.15)' 
                : 'rgba(232, 245, 233, 0.9)', 
              borderLeft: `4px solid ${isDark ? '#4ade80' : '#28a745'}`,
              backdropFilter: 'blur(12px) saturate(180%)',
              WebkitBackdropFilter: 'blur(12px) saturate(180%)',
              border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
              boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
            }}>
              <CardContent>
                <Typography variant="h4" fontWeight="bold" sx={{ color: isDark ? '#4ade80' : '#28a745' }}>
                  {rates.length}
                </Typography>
                <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' }}>
                  Total Items — کل اشیاء
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={12} sm={4}>
            <Card sx={{ 
              bgcolor: isDark 
                ? 'rgba(251, 191, 36, 0.15)' 
                : 'rgba(254, 243, 199, 0.9)', 
              borderLeft: `4px solid ${isDark ? '#fbbf24' : '#f59e0b'}`,
              backdropFilter: 'blur(12px) saturate(180%)',
              WebkitBackdropFilter: 'blur(12px) saturate(180%)',
              border: isDark ? '1px solid rgba(251, 191, 36, 0.2)' : '1px solid rgba(245, 158, 11, 0.1)',
              boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
            }}>
              <CardContent>
                <Typography variant="h4" fontWeight="bold" sx={{ color: isDark ? '#fbbf24' : '#f59e0b' }}>
                  {rates.filter(r => r.trend === 'up').length}
                </Typography>
                <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' }}>
                  Price Increasing — قیمت بڑھ رہی
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={12} sm={4}>
            <Card sx={{ 
              bgcolor: isDark 
                ? 'rgba(239, 68, 68, 0.15)' 
                : 'rgba(254, 226, 226, 0.9)', 
              borderLeft: `4px solid ${isDark ? '#f87171' : '#ef4444'}`,
              backdropFilter: 'blur(12px) saturate(180%)',
              WebkitBackdropFilter: 'blur(12px) saturate(180%)',
              border: isDark ? '1px solid rgba(248, 113, 113, 0.2)' : '1px solid rgba(239, 68, 68, 0.1)',
              boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
            }}>
              <CardContent>
                <Typography variant="h4" fontWeight="bold" sx={{ color: isDark ? '#f87171' : '#ef4444' }}>
                  {rates.filter(r => r.trend === 'down').length}
                </Typography>
                <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' }}>
                  Price Decreasing — قیمت کم ہو رہی
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>

        {/* Rates Grid */}
        <Grid container spacing={3}>
          {filteredRates.map(rate => (
            <Grid item xs={12} sm={6} md={4} lg={3} key={rate.id}>
              <Card sx={{ 
                height: '100%',
                bgcolor: isDark ? 'rgba(26, 31, 53, 0.90)' : 'rgba(255, 255, 255, 0.90)',
                backdropFilter: 'blur(12px) saturate(180%)',
                WebkitBackdropFilter: 'blur(12px) saturate(180%)',
                border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
                boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)',
                transition: 'all 0.3s ease',
                '&:hover': {
                  transform: 'translateY(-8px)',
                  boxShadow: isDark ? '0 12px 48px rgba(74, 222, 128, 0.2)' : '0 8px 24px rgba(0, 0, 0, 0.15)',
                  borderColor: getCategoryColor(rate.category)
                }
              }}>
                <CardContent>
                  {/* Header with Category Badge */}
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 2 }}>
                    <Box sx={{ flex: 1 }}>
                      <Typography variant="h6" fontWeight="bold" sx={{ 
                        mb: 0.5,
                        color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)'
                      }}>
                        {rate.name}
                      </Typography>
                      <Chip 
                        label={rate.category} 
                        size="small" 
                        sx={{ 
                          bgcolor: getCategoryColor(rate.category),
                          color: 'white',
                          fontWeight: 'bold',
                          fontSize: '0.7rem'
                        }}
                      />
                    </Box>
                    {getTrendIcon(rate.trend)}
                  </Box>

                  {/* Price Display */}
                  <Box sx={{ 
                    bgcolor: isDark 
                      ? 'rgba(74, 222, 128, 0.15)' 
                      : 'rgba(232, 245, 233, 0.9)', 
                    p: 2.5, 
                    borderRadius: 2,
                    textAlign: 'center',
                    mb: 2
                  }}>
                    <Typography variant="body2" sx={{ 
                      mb: 0.5,
                      color: isDark ? 'rgba(255,255,255,0.75)' : 'rgba(0,0,0,0.6)'
                    }}>
                      Price Range
                    </Typography>
                    <Typography variant="h4" fontWeight="bold" sx={{ 
                      color: isDark ? '#4ade80' : '#28a745'
                    }}>
                      Rs {rate.minPrice} - {rate.maxPrice}
                    </Typography>
                    <Typography variant="caption" sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.65)' : 'rgba(0,0,0,0.6)'
                    }}>
                      per {rate.unit}
                    </Typography>
                  </Box>

                  {/* Footer Info */}
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <Chip 
                      icon={<LocationOn sx={{ fontSize: 16 }} />}
                      label={rate.city} 
                      size="small" 
                      sx={{ 
                        bgcolor: isDark ? 'rgba(74, 222, 128, 0.2)' : '#f3f4f6',
                        color: isDark ? 'rgba(255,255,255,0.9)' : 'rgba(0,0,0,0.8)'
                      }}
                    />
                    <Typography 
                      variant="body2" 
                      fontWeight="bold"
                      sx={{ color: getTrendColor(rate.trend) }}
                    >
                      {getTrendLabel(rate.trend)}
                    </Typography>
                  </Box>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>

        {filteredRates.length === 0 && !loading && (
          <Box sx={{ textAlign: 'center', py: 8 }}>
            <Typography variant="h6" gutterBottom sx={{ 
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              No crops found
            </Typography>
            <Typography variant="body2" sx={{ 
              fontFamily: 'Noto Nastaliq Urdu', 
              color: isDark ? 'rgba(255,255,255,0.75)' : 'rgba(0,0,0,0.6)' 
            }}>
              کوئی فصل نہیں ملی
            </Typography>
          </Box>
        )}

        {/* Sources */}
        {sources.length > 0 && (
          <Card sx={{ 
            mt: 4, 
            bgcolor: isDark 
              ? 'rgba(74, 222, 128, 0.15)' 
              : 'rgba(232, 245, 233, 0.9)', 
            borderLeft: `4px solid ${isDark ? '#4ade80' : '#28a745'}`,
            backdropFilter: 'blur(12px) saturate(180%)',
            WebkitBackdropFilter: 'blur(12px) saturate(180%)',
            border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
            boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
          }}>
            <CardContent>
              <Typography variant="body1" fontWeight="bold" gutterBottom sx={{ 
                color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
              }}>
                📊 Data Sources — ڈیٹا کے ذرائع
              </Typography>
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, mt: 2 }}>
                {sources.map((source, index) => (
                  <Link
                    key={index}
                    href={source}
                    target="_blank"
                    rel="noopener noreferrer"
                    sx={{
                      fontSize: '0.85rem',
                      color: isDark ? '#4ade80' : '#28a745',
                      textDecoration: 'none',
                      '&:hover': { textDecoration: 'underline' }
                    }}
                  >
                    {new URL(source).hostname.replace('www.', '')} →
                  </Link>
                ))}
              </Box>
            </CardContent>
          </Card>
        )}

        {/* Info Banner */}
        <Card sx={{ 
          mt: 4, 
          bgcolor: isDark 
            ? 'rgba(251, 191, 36, 0.15)' 
            : 'rgba(255, 243, 205, 0.9)', 
          borderLeft: `4px solid ${isDark ? '#fbbf24' : '#ffc107'}`,
          backdropFilter: 'blur(12px) saturate(180%)',
          WebkitBackdropFilter: 'blur(12px) saturate(180%)',
          border: isDark ? '1px solid rgba(251, 191, 36, 0.2)' : '1px solid rgba(255, 193, 7, 0.1)',
          boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)'
        }}>
          <CardContent>
            <Typography variant="body1" fontWeight="bold" gutterBottom sx={{ 
              color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
            }}>
              💡 Market Tips | منڈی کے مشورے
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 0.5,
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              • Prices fetched in real-time using AI and Google Search (ریٹ AI اور گوگل سرچ سے حاصل کیے جاتے ہیں)
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 0.5,
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              • Data sourced from official government portals and trusted news sites (سرکاری ویب سائٹس سے ڈیٹا)
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 0.5,
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              • Check trends before selling your crop (بیچنے سے پہلے رجحانات دیکھیں)
            </Typography>
            <Typography variant="body2" sx={{ 
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              • Compare prices across different cities (مختلف شہروں میں ریٹ کا موازنہ کریں)
            </Typography>
          </CardContent>
        </Card>

        {/* Market Analysis CTA */}
        <Card sx={{ 
          mt: 3, 
          bgcolor: isDark 
            ? 'rgba(74, 222, 128, 0.15)' 
            : 'rgba(232, 245, 233, 0.9)', 
          borderLeft: `4px solid ${isDark ? '#4ade80' : '#28a745'}`,
          backdropFilter: 'blur(12px) saturate(180%)',
          WebkitBackdropFilter: 'blur(12px) saturate(180%)',
          border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
          boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)',
          textAlign: 'center' 
        }}>
          <CardContent>
            <Assessment sx={{ 
              fontSize: 50, 
              color: isDark ? '#4ade80' : '#28a745', 
              mb: 2,
              filter: isDark ? 'drop-shadow(0 2px 8px rgba(74, 222, 128, 0.5))' : 'none'
            }} />
            <Typography variant="h6" fontWeight="bold" gutterBottom sx={{ 
              color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
            }}>
              View Market Trends Analysis
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 2,
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              See 7-day price fluctuations and weekly comparisons — ہفتہ وار رجحانات دیکھیں
            </Typography>
            <Button
              variant="contained"
              size="large"
              startIcon={<Assessment />}
              onClick={() => navigate('/market-analysis')}
              sx={{ 
                bgcolor: isDark ? '#4ade80' : '#28a745', 
                '&:hover': { bgcolor: isDark ? '#22c55e' : '#218838' },
                color: isDark ? '#000' : '#fff',
                fontWeight: 'bold',
                boxShadow: isDark ? '0 4px 12px rgba(74, 222, 128, 0.3)' : '0 2px 8px rgba(40, 167, 69, 0.2)'
              }}
            >
              View Analysis Charts — تجزیہ دیکھیں
            </Button>
          </CardContent>
        </Card>
      </Container>
    </Box>
  );
};

export default MandiRates;

