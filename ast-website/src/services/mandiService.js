// Mandi Rates Service - Mock data (replace with actual API when available)

const MOCK_MANDI_RATES = [
  {
    id: 1,
    name: 'Wheat',
    nameUrdu: 'گندم',
    price: 3500,
    unit: 'per 40kg',
    trend: 'up',
    change: '+150',
    city: 'Lahore',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 2,
    name: 'Rice',
    nameUrdu: 'چاول',
    price: 4200,
    unit: 'per 40kg',
    trend: 'down',
    change: '-80',
    city: 'Faisalabad',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 3,
    name: 'Cotton',
    nameUrdu: 'کپاس',
    price: 7500,
    unit: 'per 40kg',
    trend: 'stable',
    change: '0',
    city: 'Multan',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 4,
    name: 'Sugarcane',
    nameUrdu: 'گنا',
    price: 300,
    unit: 'per 40kg',
    trend: 'up',
    change: '+20',
    city: 'Lahore',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 5,
    name: 'Maize',
    nameUrdu: 'مکئی',
    price: 2800,
    unit: 'per 40kg',
    trend: 'stable',
    change: '0',
    city: 'Faisalabad',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 6,
    name: 'Potato',
    nameUrdu: 'آلو',
    price: 1200,
    unit: 'per 40kg',
    trend: 'down',
    change: '-100',
    city: 'Multan',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 7,
    name: 'Onion',
    nameUrdu: 'پیاز',
    price: 2500,
    unit: 'per 40kg',
    trend: 'up',
    change: '+200',
    city: 'Lahore',
    lastUpdated: new Date().toISOString()
  },
  {
    id: 8,
    name: 'Tomato',
    nameUrdu: 'ٹماٹر',
    price: 3000,
    unit: 'per 40kg',
    trend: 'up',
    change: '+300',
    city: 'Faisalabad',
    lastUpdated: new Date().toISOString()
  }
];

export const getMandiRates = async (city = null) => {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 500));

  try {
    let rates = MOCK_MANDI_RATES;
    
    if (city) {
      rates = rates.filter(rate => rate.city === city);
    }

    return {
      success: true,
      rates,
      lastUpdated: new Date().toISOString()
    };
  } catch (error) {
    console.error('Mandi API Error:', error);
    return {
      success: false,
      error: error.message,
      rates: []
    };
  }
};

export const getCities = () => {
  return ['Lahore', 'Faisalabad', 'Multan'];
};

export const searchCrop = (query) => {
  const lowerQuery = query.toLowerCase();
  return MOCK_MANDI_RATES.filter(rate => 
    rate.name.toLowerCase().includes(lowerQuery) ||
    rate.nameUrdu.includes(query)
  );
};
