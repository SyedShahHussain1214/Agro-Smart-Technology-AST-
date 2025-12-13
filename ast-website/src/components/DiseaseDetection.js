import React, { useState } from 'react';
import { Box, Container, Typography, Button, Card, CardContent, CardMedia, Paper, Chip, CircularProgress } from '@mui/material';
import { PhotoCamera, Agriculture, Warning, CheckCircle } from '@mui/icons-material';
import { detectDiseaseWithTF } from '../services/tfDiseaseDetectionService';
import { useThemeMode } from '../App';

const DiseaseDetection = () => {
  const { isDark } = useThemeMode();
  const [selectedImage, setSelectedImage] = useState(null);
  const [detection, setDetection] = useState(null);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [error, setError] = useState(null);

  const handleImageUpload = async (event) => {
    const file = event.target.files[0];
    if (file) {
      console.log('File selected:', file.name, file.type, file.size);
      
      // Validate file type
      if (!file.type.startsWith('image/')) {
        setError('Please upload a valid image file (JPG, PNG, etc.)');
        return;
      }
      
      // Validate file size (max 10MB)
      if (file.size > 10 * 1024 * 1024) {
        setError('Image file is too large. Please upload an image smaller than 10MB.');
        return;
      }
      
      setSelectedImage(URL.createObjectURL(file));
      setIsAnalyzing(true);
      setDetection(null);
      setError(null);

      try {
        console.log('Starting disease detection...');
        const result = await detectDiseaseWithTF(file);
        console.log('Detection result:', result);
        
        if (result.success) {
          setDetection(result.detection);
          setError(null);
          console.log('Detection successful:', result.detection);
        } else {
          setError(result.error || 'Failed to analyze image. Please try again.');
          console.error('Detection failed:', result.error);
        }
      } catch (err) {
        setError('An error occurred while analyzing the image. Please check your internet connection and try again.');
        console.error('Upload error:', err);
      }
      
      setIsAnalyzing(false);
    }
  };

  const getSeverityColor = (severity) => {
    switch (severity) {
      case 'High': return 'error';
      case 'Medium': return 'warning';
      case 'Low': return 'success';
      default: return 'default';
    }
  };

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'transparent', py: 4 }}>
      <Container maxWidth="lg">
        {/* Header */}
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <Agriculture sx={{ fontSize: 60, color: '#28a745', mb: 2 }} />
          <Typography variant="h3" fontWeight="bold" color="#28a745" gutterBottom>
            AI Crop Disease Detection
          </Typography>
          <Typography variant="h5" sx={{ fontFamily: 'Noto Nastaliq Urdu', color: '#28a745', mb: 2 }}>
            فصل کی بیماری کی AI تشخیص
          </Typography>
          <Typography variant="body1" color="text.secondary">
            Upload a photo of your crop leaf to instantly identify diseases
          </Typography>
        </Box>

        {/* Upload Section */}
        <Paper sx={{ p: 4, mb: 4, textAlign: 'center', border: '2px dashed #28a745' }}>
          <input
            accept="image/*"
            style={{ display: 'none' }}
            id="image-upload"
            type="file"
            onChange={handleImageUpload}
          />
          <label htmlFor="image-upload">
            <Button
              variant="contained"
              component="span"
              startIcon={<PhotoCamera />}
              size="large"
              sx={{ 
                bgcolor: '#28a745',
                '&:hover': { bgcolor: '#20a745' },
                px: 4,
                py: 1.5
              }}
            >
              Take Photo / Upload Image
            </Button>
          </label>
          <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
            تصویر لیں یا اپ لوڈ کریں
          </Typography>
        </Paper>

        {/* Processing */}
        {isAnalyzing && (
          <Box sx={{ textAlign: 'center', my: 4 }}>
            <CircularProgress size={60} sx={{ color: '#28a745' }} />
            <Typography variant="h6" sx={{ mt: 2 }}>
              Analyzing image with AI... تجزیہ ہو رہا ہے...
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
              This may take 10-15 seconds
            </Typography>
          </Box>
        )}

        {/* Error Message */}
        {error && !isAnalyzing && (
          <Paper sx={{ p: 3, bgcolor: '#ffebee', my: 3 }}>
            <Typography variant="h6" color="error" gutterBottom>
              ❌ Analysis Failed
            </Typography>
            <Typography variant="body1" paragraph>
              {error}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Tips:
              • Make sure you have internet connection
              • Upload a clear photo of a crop leaf
              • Try taking a new photo with better lighting
            </Typography>
          </Paper>
        )}

        {/* Results */}
        {detection && !isAnalyzing && (
          <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', md: '1fr 1fr' }, gap: 3 }}>
            {/* Image Preview */}
            <Card>
              <CardMedia
                component="img"
                image={detection.imageUrl}
                alt="Uploaded crop"
                sx={{ height: 400, objectFit: 'cover' }}
              />
            </Card>

            {/* Detection Results */}
            <Card>
              <CardContent>
                <Box sx={{ mb: 3 }}>
                  <Typography variant="h5" fontWeight="bold" gutterBottom>
                    Detection Results
                  </Typography>
                  <Typography variant="body2" sx={{ fontFamily: 'Noto Nastaliq Urdu', color: 'text.secondary' }}>
                    تشخیص کے نتائج
                  </Typography>
                </Box>

                <Box sx={{ mb: 3 }}>
                  <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    Crop Type
                  </Typography>
                  <Chip 
                    label={detection.crop} 
                    color="primary" 
                    sx={{ mb: 2, bgcolor: '#28a745' }}
                  />
                  
                  <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    Disease Detected
                  </Typography>
                  <Typography variant="h6" fontWeight="bold" gutterBottom>
                    {detection.disease.name}
                  </Typography>
                  <Typography variant="body2" sx={{ fontFamily: 'Noto Nastaliq Urdu', color: 'text.secondary', mb: 2 }}>
                    {detection.disease.nameUrdu}
                  </Typography>

                  <Box sx={{ display: 'flex', gap: 1, mb: 3 }}>
                    <Chip 
                      label={`Confidence: ${detection.confidence}%`}
                      color="success"
                      icon={<CheckCircle />}
                    />
                    <Chip 
                      label={`Severity: ${detection.disease.severity}`}
                      color={getSeverityColor(detection.disease.severity)}
                      icon={<Warning />}
                    />
                  </Box>
                </Box>

                <Box sx={{ mb: 3 }}>
                  <Typography variant="subtitle1" fontWeight="bold" gutterBottom>
                    Symptoms | علامات
                  </Typography>
                  <Typography variant="body2" paragraph>
                    {detection.disease.symptoms}
                  </Typography>
                </Box>

                <Box sx={{ mb: 3 }}>
                  <Typography variant="subtitle1" fontWeight="bold" gutterBottom>
                    Treatment | علاج
                  </Typography>
                  <Paper sx={{ p: 2, bgcolor: detection.healthy ? '#e8f5e9' : '#fff3e0' }}>
                    <Typography variant="body2">
                      {detection.disease.treatment}
                    </Typography>
                  </Paper>
                </Box>

                {detection.prevention && (
                  <Box>
                    <Typography variant="subtitle1" fontWeight="bold" gutterBottom>
                      Prevention | احتیاطی تدابیر
                    </Typography>
                    <Paper sx={{ p: 2, bgcolor: '#e3f2fd' }}>
                      <Typography variant="body2">
                        {detection.prevention}
                      </Typography>
                    </Paper>
                  </Box>
                )}
              </CardContent>
            </Card>
          </Box>
        )}

        {/* Info Cards */}
        {!selectedImage && (
          <Box sx={{ mt: 4 }}>
            <Typography variant="h5" fontWeight="bold" textAlign="center" mb={3}>
              How It Works | یہ کیسے کام کرتا ہے
            </Typography>
            <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', md: '1fr 1fr 1fr' }, gap: 3, mb: 4 }}>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <PhotoCamera sx={{ fontSize: 40, color: '#28a745', mb: 1 }} />
                  <Typography variant="h6" gutterBottom>1. Upload Photo</Typography>
                  <Typography variant="body2" color="text.secondary">
                    Take or upload a clear photo of the crop leaf
                  </Typography>
                </CardContent>
              </Card>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Agriculture sx={{ fontSize: 40, color: '#28a745', mb: 1 }} />
                  <Typography variant="h6" gutterBottom>2. AI Analysis</Typography>
                  <Typography variant="body2" color="text.secondary">
                    Our AI identifies the crop and detects any diseases
                  </Typography>
                </CardContent>
              </Card>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <CheckCircle sx={{ fontSize: 40, color: '#28a745', mb: 1 }} />
                  <Typography variant="h6" gutterBottom>3. Get Treatment</Typography>
                  <Typography variant="body2" color="text.secondary">
                    Receive instant treatment and prevention advice
                  </Typography>
                </CardContent>
              </Card>
            </Box>

            <Typography variant="h5" fontWeight="bold" textAlign="center" mb={3}>
              Supported Crops
            </Typography>
            <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr 1fr', sm: '1fr 1fr 1fr', md: '1fr 1fr 1fr 1fr' }, gap: 2 }}>
              {['Cotton', 'Rice', 'Wheat', 'Sugarcane', 'Maize', 'Potato', 'Onion', 'Tomato'].map(crop => (
                <Card key={crop}>
                  <CardContent sx={{ textAlign: 'center', py: 2 }}>
                    <Agriculture sx={{ fontSize: 35, color: '#28a745', mb: 1 }} />
                    <Typography variant="body1" fontWeight="medium">{crop}</Typography>
                  </CardContent>
                </Card>
              ))}
            </Box>
          </Box>
        )}
      </Container>
    </Box>
  );
};

export default DiseaseDetection;
