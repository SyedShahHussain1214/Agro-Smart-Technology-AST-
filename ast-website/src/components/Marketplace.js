import React, { useState, useEffect } from 'react';
import { Box, Container, Typography, Card, CardContent, CardMedia, Grid, Button, Chip, TextField, Dialog, DialogTitle, DialogContent, DialogActions, CircularProgress } from '@mui/material';
import { Shop, Phone, LocationOn, Add, Search } from '@mui/icons-material';
import { getListings, createListing } from '../services/marketplaceService';
import { useThemeMode } from '../App';

const Marketplace = () => {
  const { isDark } = useThemeMode();
  const [listings, setListings] = useState([]);
  const [filteredListings, setFilteredListings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [openDialog, setOpenDialog] = useState(false);
  const [formData, setFormData] = useState({
    type: 'sell',
    crop: '',
    quantity: '',
    price: '',
    location: '',
    phone: ''
  });

  const loadListings = async () => {
    setLoading(true);
    const result = await getListings(filter);
    if (result.success) {
      setListings(result.listings);
      setFilteredListings(result.listings);
    }
    setLoading(false);
  };

  useEffect(() => {
    loadListings();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filter]);

  useEffect(() => {
    if (searchQuery) {
      const filtered = listings.filter(listing => 
        listing.crop.toLowerCase().includes(searchQuery.toLowerCase()) ||
        listing.cropUrdu.includes(searchQuery) ||
        listing.location.toLowerCase().includes(searchQuery.toLowerCase())
      );
      setFilteredListings(filtered);
    } else {
      setFilteredListings(listings);
    }
  }, [searchQuery, listings]);

  const handleCreateListing = async () => {
    const result = await createListing(formData);
    if (result.success) {
      alert(result.message);
      setOpenDialog(false);
      setFormData({ type: 'sell', crop: '', quantity: '', price: '', location: '', phone: '' });
      loadListings();
    }
  };

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '100vh', bgcolor: 'transparent' }}>
        <CircularProgress size={60} sx={{ color: isDark ? '#4ade80' : '#28a745' }} />
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'transparent', py: 4 }}>
      <Container maxWidth="lg">
        {/* Header */}
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <Shop sx={{ 
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
            Digital Farmer Marketplace
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
            کسانوں کی ڈیجیٹل منڈی
          </Typography>
          <Typography 
            variant="body1" 
            sx={{ color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)' }}
          >
            Direct buyer-seller connection — no middlemen
          </Typography>
        </Box>

        {/* Action Bar */}
        <Box sx={{ mb: 4 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: 2, mb: 3 }}>
            <Box sx={{ display: 'flex', gap: 2 }}>
              <Chip
                label="All"
                onClick={() => setFilter('all')}
                color={filter === 'all' ? 'primary' : 'default'}
                sx={{ 
                  bgcolor: filter === 'all' 
                    ? (isDark ? '#4ade80' : '#28a745') 
                    : (isDark ? 'rgba(74, 222, 128, 0.15)' : 'white'), 
                  color: filter === 'all' 
                    ? (isDark ? '#000' : 'white') 
                    : (isDark ? 'rgba(255,255,255,0.9)' : 'black'),
                  fontWeight: filter === 'all' ? 'bold' : 'normal',
                  border: isDark ? '1px solid rgba(74, 222, 128, 0.3)' : 'none'
                }}
              />
              <Chip
                label="Selling"
                onClick={() => setFilter('sell')}
                color={filter === 'sell' ? 'primary' : 'default'}
                sx={{ 
                  bgcolor: filter === 'sell' 
                    ? (isDark ? '#4ade80' : '#28a745') 
                    : (isDark ? 'rgba(74, 222, 128, 0.15)' : 'white'), 
                  color: filter === 'sell' 
                    ? (isDark ? '#000' : 'white') 
                    : (isDark ? 'rgba(255,255,255,0.9)' : 'black'),
                  fontWeight: filter === 'sell' ? 'bold' : 'normal',
                  border: isDark ? '1px solid rgba(74, 222, 128, 0.3)' : 'none'
                }}
              />
              <Chip
                label="Buying"
                onClick={() => setFilter('buy')}
                color={filter === 'buy' ? 'primary' : 'default'}
                sx={{ 
                  bgcolor: filter === 'buy' 
                    ? (isDark ? '#4ade80' : '#28a745') 
                    : (isDark ? 'rgba(74, 222, 128, 0.15)' : 'white'), 
                  color: filter === 'buy' 
                    ? (isDark ? '#000' : 'white') 
                    : (isDark ? 'rgba(255,255,255,0.9)' : 'black'),
                  fontWeight: filter === 'buy' ? 'bold' : 'normal',
                  border: isDark ? '1px solid rgba(74, 222, 128, 0.3)' : 'none'
                }}
              />
            </Box>

            <Button
              variant="contained"
              startIcon={<Add />}
              onClick={() => setOpenDialog(true)}
              sx={{ 
                bgcolor: isDark ? '#4ade80' : '#28a745', 
                '&:hover': { bgcolor: isDark ? '#22c55e' : '#20a745' },
                color: isDark ? '#000' : '#fff',
                fontWeight: 'bold',
                boxShadow: isDark ? '0 4px 12px rgba(74, 222, 128, 0.3)' : '0 2px 8px rgba(40, 167, 69, 0.2)'
              }}
            >
              Create Listing
            </Button>
          </Box>

          <TextField
            fullWidth
            placeholder="Search listings... اشتہار تلاش کریں"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            sx={{
              '& .MuiOutlinedInput-root': {
                color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)',
                bgcolor: isDark ? 'rgba(26, 31, 53, 0.5)' : 'rgba(255, 255, 255, 0.8)',
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
        </Box>

        {/* Listings Grid */}
        <Grid container spacing={3}>
          {filteredListings.map(listing => (
            <Grid item xs={12} sm={6} md={4} key={listing.id}>
              <Card sx={{ 
                height: '100%',
                bgcolor: isDark ? 'rgba(26, 31, 53, 0.90)' : 'rgba(255, 255, 255, 0.90)',
                backdropFilter: 'blur(12px) saturate(180%)',
                WebkitBackdropFilter: 'blur(12px) saturate(180%)',
                border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)',
                boxShadow: isDark ? '0 8px 32px rgba(0, 0, 0, 0.3)' : '0 4px 12px rgba(0, 0, 0, 0.08)',
                transition: 'transform 0.3s, box-shadow 0.3s',
                '&:hover': {
                  transform: 'translateY(-8px)',
                  boxShadow: isDark ? '0 12px 48px rgba(74, 222, 128, 0.2)' : '0 8px 24px rgba(0, 0, 0, 0.15)'
                }
              }}>
                <CardMedia
                  component="img"
                  height="200"
                  image={listing.image}
                  alt={listing.crop}
                />
                <CardContent>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                    <Chip 
                      label={listing.type === 'sell' ? 'Selling' : 'Buying'}
                      size="small"
                      sx={{ 
                        bgcolor: listing.type === 'sell' ? '#10b981' : '#3b82f6',
                        color: 'white',
                        fontWeight: 'bold'
                      }}
                    />
                    <Typography variant="caption" sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.75)' : 'rgba(0,0,0,0.6)' 
                    }}>
                      {listing.postedDate}
                    </Typography>
                  </Box>

                  <Typography variant="h6" fontWeight="bold" gutterBottom sx={{ 
                    color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
                  }}>
                    {listing.crop}
                  </Typography>
                  <Typography variant="body2" sx={{ 
                    fontFamily: 'Noto Nastaliq Urdu', 
                    color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)', 
                    mb: 2 
                  }}>
                    {listing.cropUrdu}
                  </Typography>

                  <Box sx={{ mb: 2 }}>
                    <Typography variant="body2" sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
                    }}>
                      Quantity: {listing.quantity}
                    </Typography>
                    <Typography variant="h5" fontWeight="bold" sx={{ 
                      color: isDark ? '#4ade80' : '#28a745' 
                    }}>
                      Rs {listing.price.toLocaleString()}
                    </Typography>
                    <Typography variant="caption" sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.65)' : 'rgba(0,0,0,0.6)' 
                    }}>
                      {listing.pricePerUnit}
                    </Typography>
                  </Box>

                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1 }}>
                    <LocationOn sx={{ 
                      fontSize: 18, 
                      color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.54)' 
                    }} />
                    <Typography variant="body2" sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.9)' : 'rgba(0,0,0,0.87)' 
                    }}>
                      {listing.location}
                    </Typography>
                  </Box>

                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                    <Typography variant="body2" fontWeight="bold" sx={{ 
                      color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)' 
                    }}>
                      {listing.seller || listing.buyer}
                    </Typography>
                  </Box>

                  <Button
                    fullWidth
                    variant="contained"
                    startIcon={<Phone />}
                    href={`tel:${listing.phone}`}
                    sx={{ 
                      bgcolor: isDark ? '#4ade80' : '#28a745', 
                      '&:hover': { bgcolor: isDark ? '#22c55e' : '#20a745' },
                      color: isDark ? '#000' : '#fff',
                      fontWeight: 'bold',
                      boxShadow: isDark ? '0 4px 12px rgba(74, 222, 128, 0.3)' : '0 2px 8px rgba(40, 167, 69, 0.2)'
                    }}
                  >
                    Contact
                  </Button>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>

        {filteredListings.length === 0 && (
          <Box sx={{ textAlign: 'center', py: 8 }}>
            <Typography variant="h6" sx={{ 
              color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.75)' 
            }}>
              No listings found | کوئی اشتہار نہیں ملا
            </Typography>
          </Box>
        )}

        {/* Create Listing Dialog */}
        <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="sm" fullWidth>
          <DialogTitle sx={{ 
            color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)',
            bgcolor: isDark ? 'rgba(26, 31, 53, 0.95)' : 'rgba(255, 255, 255, 0.95)'
          }}>
            Create New Listing | نیا اشتہار بنائیں
          </DialogTitle>
          <DialogContent sx={{ 
            bgcolor: isDark ? 'rgba(26, 31, 53, 0.95)' : 'rgba(255, 255, 255, 0.95)'
          }}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 2 }}>
              <Box sx={{ display: 'flex', gap: 2 }}>
                <Chip
                  label="Selling"
                  onClick={() => setFormData({...formData, type: 'sell'})}
                  color={formData.type === 'sell' ? 'primary' : 'default'}
                  sx={{ 
                    bgcolor: formData.type === 'sell' 
                      ? (isDark ? '#4ade80' : '#28a745') 
                      : (isDark ? 'rgba(74, 222, 128, 0.15)' : 'default'),
                    color: formData.type === 'sell' 
                      ? (isDark ? '#000' : '#fff') 
                      : (isDark ? 'rgba(255,255,255,0.9)' : 'rgba(0,0,0,0.87)'),
                    border: isDark ? '1px solid rgba(74, 222, 128, 0.3)' : 'none'
                  }}
                />
                <Chip
                  label="Buying"
                  onClick={() => setFormData({...formData, type: 'buy'})}
                  color={formData.type === 'buy' ? 'primary' : 'default'}
                  sx={{ 
                    bgcolor: formData.type === 'buy' 
                      ? (isDark ? '#4ade80' : '#28a745') 
                      : (isDark ? 'rgba(74, 222, 128, 0.15)' : 'default'),
                    color: formData.type === 'buy' 
                      ? (isDark ? '#000' : '#fff') 
                      : (isDark ? 'rgba(255,255,255,0.9)' : 'rgba(0,0,0,0.87)'),
                    border: isDark ? '1px solid rgba(74, 222, 128, 0.3)' : 'none'
                  }}
                />
              </Box>
              <TextField
                label="Crop Name"
                value={formData.crop}
                onChange={(e) => setFormData({...formData, crop: e.target.value})}
                fullWidth
              />
              <TextField
                label="Quantity (kg)"
                value={formData.quantity}
                onChange={(e) => setFormData({...formData, quantity: e.target.value})}
                fullWidth
              />
              <TextField
                label="Price (Rs)"
                type="number"
                value={formData.price}
                onChange={(e) => setFormData({...formData, price: e.target.value})}
                fullWidth
              />
              <TextField
                label="Location"
                value={formData.location}
                onChange={(e) => setFormData({...formData, location: e.target.value})}
                fullWidth
              />
              <TextField
                label="Phone Number"
                value={formData.phone}
                onChange={(e) => setFormData({...formData, phone: e.target.value})}
                fullWidth
              />
            </Box>
          </DialogContent>
          <DialogActions sx={{ 
            bgcolor: isDark ? 'rgba(26, 31, 53, 0.95)' : 'rgba(255, 255, 255, 0.95)'
          }}>
            <Button onClick={() => setOpenDialog(false)} sx={{ 
              color: isDark ? 'rgba(255,255,255,0.9)' : 'rgba(0,0,0,0.87)' 
            }}>
              Cancel
            </Button>
            <Button 
              onClick={handleCreateListing} 
              variant="contained" 
              sx={{ 
                bgcolor: isDark ? '#4ade80' : '#28a745',
                '&:hover': { bgcolor: isDark ? '#22c55e' : '#218838' },
                color: isDark ? '#000' : '#fff',
                fontWeight: 'bold'
              }}
            >
              Create
            </Button>
          </DialogActions>
        </Dialog>
      </Container>
    </Box>
  );
};

export default Marketplace;
