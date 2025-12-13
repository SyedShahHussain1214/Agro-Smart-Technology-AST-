// Marketplace Service - Firebase Firestore integration would go here

// Mock marketplace listings
const MOCK_LISTINGS = [
  {
    id: 1,
    type: 'sell',
    crop: 'Wheat',
    cropUrdu: 'گندم',
    quantity: '1000 kg',
    price: 3400,
    pricePerUnit: 'per 40kg',
    location: 'Lahore',
    seller: 'Ahmad Khan',
    phone: '+92 300 1234567',
    postedDate: '2025-12-08',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400'
  },
  {
    id: 2,
    type: 'buy',
    crop: 'Rice',
    cropUrdu: 'چاول',
    quantity: '2000 kg',
    price: 4100,
    pricePerUnit: 'per 40kg',
    location: 'Faisalabad',
    buyer: 'Bilal Ahmed',
    phone: '+92 301 2345678',
    postedDate: '2025-12-07',
    image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400'
  },
  {
    id: 3,
    type: 'sell',
    crop: 'Cotton',
    cropUrdu: 'کپاس',
    quantity: '500 kg',
    price: 7400,
    pricePerUnit: 'per 40kg',
    location: 'Multan',
    seller: 'Hassan Ali',
    phone: '+92 302 3456789',
    postedDate: '2025-12-08',
    image: 'https://images.unsplash.com/photo-1616431101491-554c0932ea40?w=400'
  },
  {
    id: 4,
    type: 'buy',
    crop: 'Tomato',
    cropUrdu: 'ٹماٹر',
    quantity: '300 kg',
    price: 2900,
    pricePerUnit: 'per 40kg',
    location: 'Lahore',
    buyer: 'Imran Shah',
    phone: '+92 303 4567890',
    postedDate: '2025-12-06',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400'
  },
  {
    id: 5,
    type: 'sell',
    crop: 'Onion',
    cropUrdu: 'پیاز',
    quantity: '800 kg',
    price: 2400,
    pricePerUnit: 'per 40kg',
    location: 'Faisalabad',
    seller: 'Khalid Mahmood',
    phone: '+92 304 5678901',
    postedDate: '2025-12-08',
    image: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400'
  }
];

export const getListings = async (filterType = 'all') => {
  await new Promise(resolve => setTimeout(resolve, 300));

  try {
    let listings = MOCK_LISTINGS;
    
    if (filterType !== 'all') {
      listings = listings.filter(listing => listing.type === filterType);
    }

    return {
      success: true,
      listings
    };
  } catch (error) {
    console.error('Marketplace API Error:', error);
    return {
      success: false,
      error: error.message,
      listings: []
    };
  }
};

export const createListing = async (listingData) => {
  await new Promise(resolve => setTimeout(resolve, 500));

  try {
    const newListing = {
      id: Date.now(),
      ...listingData,
      postedDate: new Date().toISOString().split('T')[0]
    };

    return {
      success: true,
      listing: newListing,
      message: 'Listing created successfully!'
    };
  } catch (error) {
    console.error('Create Listing Error:', error);
    return {
      success: false,
      error: error.message
    };
  }
};

export const searchListings = (query) => {
  const lowerQuery = query.toLowerCase();
  return MOCK_LISTINGS.filter(listing => 
    listing.crop.toLowerCase().includes(lowerQuery) ||
    listing.cropUrdu.includes(query) ||
    listing.location.toLowerCase().includes(lowerQuery)
  );
};
