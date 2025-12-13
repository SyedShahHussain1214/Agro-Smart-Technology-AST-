// OpenWeatherMap API Service
const OPENWEATHER_API_KEY = 'bd0a7106c8a51f1eb7d128794e741c7f';
const WEATHER_API_URL = 'https://api.openweathermap.org/data/2.5/weather';
const FORECAST_API_URL = 'https://api.openweathermap.org/data/2.5/forecast';

export const getCurrentWeather = async (city = 'Lahore') => {
  try {
    const response = await fetch(
      `${WEATHER_API_URL}?q=${encodeURIComponent(city)}&units=metric&appid=${OPENWEATHER_API_KEY}`
    );

    if (!response.ok) {
      throw new Error('Weather API error');
    }

    const data = await response.json();
    
    return {
      success: true,
      data: {
        temp: Math.round(data.main.temp),
        feelsLike: Math.round(data.main.feels_like),
        humidity: data.main.humidity,
        condition: data.weather[0].main,
        description: data.weather[0].description,
        windSpeed: data.wind.speed,
        icon: data.weather[0].icon,
        city: data.name
      }
    };
  } catch (error) {
    console.error('Weather API Error:', error);
    return {
      success: false,
      error: error.message,
      data: {
        temp: 25,
        humidity: 65,
        condition: 'Demo Mode',
        description: 'Add your API key for real data',
        city: city
      }
    };
  }
};

export const getForecast = async (city = 'Lahore') => {
  try {
    const response = await fetch(
      `${FORECAST_API_URL}?q=${encodeURIComponent(city)}&units=metric&appid=${OPENWEATHER_API_KEY}`
    );

    if (!response.ok) {
      throw new Error('Forecast API error');
    }

    const data = await response.json();
    
    // Group forecasts by day and get one forecast per day (noon time preferred)
    const dailyForecasts = {};
    
    data.list.forEach(item => {
      const date = new Date(item.dt * 1000);
      const dateKey = date.toLocaleDateString('en-US');
      const hour = date.getHours();
      
      // Prefer noon forecasts (12pm) or closest to it
      if (!dailyForecasts[dateKey] || Math.abs(hour - 12) < Math.abs(new Date(dailyForecasts[dateKey].dt * 1000).getHours() - 12)) {
        dailyForecasts[dateKey] = item;
      }
    });
    
    // Convert to array and take first 7 days
    const forecastArray = Object.values(dailyForecasts).slice(0, 7).map(item => {
      const date = new Date(item.dt * 1000);
      const today = new Date();
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);
      
      let dayName;
      if (date.toDateString() === today.toDateString()) {
        dayName = 'Today';
      } else if (date.toDateString() === tomorrow.toDateString()) {
        dayName = 'Tomorrow';
      } else {
        dayName = date.toLocaleDateString('en-US', { weekday: 'long' });
      }
      
      return {
        date: dayName,
        fullDate: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
        temp: Math.round(item.main.temp),
        tempMin: Math.round(item.main.temp_min),
        tempMax: Math.round(item.main.temp_max),
        condition: item.weather[0].main,
        description: item.weather[0].description,
        icon: item.weather[0].icon,
        humidity: item.main.humidity,
        windSpeed: item.wind.speed
      };
    });
    
    return {
      success: true,
      forecast: forecastArray
    };
  } catch (error) {
    console.error('Forecast API Error:', error);
    return {
      success: false,
      forecast: []
    };
  }
};
