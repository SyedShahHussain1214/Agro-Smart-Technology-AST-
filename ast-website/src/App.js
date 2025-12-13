import React, { useState, createContext, useContext } from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import './App.css';
import { 
  AppBar, 
  Toolbar, 
  Typography, 
  Button, 
  Container, 
  Box, 
  Grid,
  Card,
  CardContent,
  CardMedia,
  Paper,
  TextField,
  Tooltip,
  IconButton,
  Drawer,
  Divider,
  Link,
  createTheme,
  ThemeProvider
} from '@mui/material';
import { 
  Mic, 
  TrendingUp, 
  Smartphone,
  Download,
  Shop,
  Agriculture,
  WbSunny,
  Home as HomeIcon,
  Close,
  ArrowBack,
  Menu,
  Info,
  Facebook,
  Twitter,
  Instagram,
  LinkedIn,
  GitHub,
  Email,
  Phone,
  LocationOn,
  LightMode,
  DarkMode
} from '@mui/icons-material';

// Import components
import VoiceQA from './components/VoiceQA';
import DiseaseDetection from './components/DiseaseDetection';
import Weather from './components/Weather';
import MandiRates from './components/MandiRates';
import MarketAnalysis from './components/MarketAnalysis';
import Marketplace from './components/Marketplace';

// Create Theme Context
const ThemeContext = createContext();

export const useThemeMode = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    return { isDark: false, toggleTheme: () => {} };
  }
  return context;
};

function HomePage() {
  const navigate = useNavigate();
  const { isDark } = useThemeMode();
  const [isHovering, setIsHovering] = useState(null);
  const [formData, setFormData] = useState({ name: '', phone: '', message: '' });
  const [selectedStory, setSelectedStory] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    alert('Thank you! Your message has been sent. — شکریہ! آپ کا پیغام بھیج دیا گیا ہے۔');
    setFormData({ name: '', phone: '', message: '' });
  };

  const scrollToSection = (sectionId) => {
    document.getElementById(sectionId)?.scrollIntoView({ behavior: 'smooth' });
  };

  const features = [
    {
      icon: <Mic sx={{ fontSize: 60 }} />,
      title: 'Voice Q&A in Urdu',
      titleUrdu: 'اردو میں آواز سے سوالات',
      desc: 'Ask about crops, fertilizers, pests, weather — get instant answers in Urdu',
      descUrdu: 'فصل، کھاد، کیڑے، موسم کے بارے میں پوچھیں — فوراً جواب سنیں',
      image: `${process.env.PUBLIC_URL}/images/Voice Q&A in Urdu.jpg`,
      path: '/voice-qa'
    },
    {
      icon: <Agriculture sx={{ fontSize: 60 }} />,
      title: 'AI Crop Disease Detection',
      titleUrdu: 'فصل کی بیماری کی AI تشخیص',
      desc: 'Take photo of leaf — instantly identify diseases in cotton, rice, wheat, sugarcane',
      descUrdu: 'پتے کی تصویر لیں — کپاس، چاول، گندم، گنے کی بیماری فوراً پتہ چلے',
      image: `${process.env.PUBLIC_URL}/images/AI Crop Disease Detection.jpg`,
      path: '/disease-detection'
    },
    {
      icon: <TrendingUp sx={{ fontSize: 60 }} />,
      title: 'Real-Time Mandi Rates',
      titleUrdu: 'منڈی کے تازہ ریٹ',
      desc: 'Latest prices from Lahore, Faisalabad, Multan mandis — updated daily',
      descUrdu: 'لاہور، فیصل آباد، ملتان کی منڈیوں کے تازہ ترین ریٹ',
      image: `${process.env.PUBLIC_URL}/images/Real-Time Mandi Rates.png`,
      path: '/mandi-rates'
    },
    {
      icon: <Shop sx={{ fontSize: 60 }} />,
      title: 'Digital Farmer Marketplace',
      titleUrdu: 'کسانوں کی ڈیجیٹل منڈی',
      desc: 'Direct buyer-seller connection — no middlemen',
      descUrdu: 'خریدار اور بیچنے والے کا براہ راست رابطہ — کوئی دلال نہیں',
      image: `${process.env.PUBLIC_URL}/images/Digital Farmer Marketplace.jpg`,
      path: '/marketplace'
    },
    {
      icon: <WbSunny sx={{ fontSize: 60 }} />,
      title: 'Accurate Weather Forecast',
      titleUrdu: 'درست موسم کی پیشگوئی',
      desc: 'Rain, temperature, humidity alerts for your area',
      descUrdu: 'بارش، درجہ حرارت، نمی کی الرٹس',
      image: `${process.env.PUBLIC_URL}/images/Accurate Weather Forecast.jpg`,
      path: '/weather'
    },
    {
      icon: <Smartphone sx={{ fontSize: 60 }} />,
      title: 'Works Offline',
      titleUrdu: 'انٹرنیٹ کے بغیر بھی کام کرتا ہے',
      desc: 'Disease detection & basic advice available without internet',
      descUrdu: 'بیماری کی تشخیص اور بنیادی مشورے آف لائن دستیاب',
      image: `${process.env.PUBLIC_URL}/images/Works Offline.jpg`,
      path: '/disease-detection'
    }
  ];

  const farmerStories = [
    {
      id: 1,
      image: `${process.env.PUBLIC_URL}/images/Real pakistani farmers using AST/10.jpg`,
      title: 'The Laptop Duo – Brothers United in the Fields',
      titleUrdu: 'لیپ ٹاپ جوڑی – کھیتوں میں متحد بھائی',
      storyEnglish: `In the vast, golden wheat fields of rural Punjab, where the sun beats down mercilessly and the soil tells tales of generations of toil, lived two brothers, Ali and Asif. Ali, the elder at 45, with calloused hands and a furrowed brow from years of worry, had always been the backbone of their small family farm. Asif, 38, his younger sibling, shared the same weathered face, marked by the relentless struggle against nature's whims. Their 5-acre plot was their lifeblood, but it had become a source of endless despair. Pests like armyworms and aphids descended like silent invaders, devouring half their crops season after season. Without the ability to read pesticide labels or navigate English-heavy agricultural apps, they resorted to guesswork, often spraying toxic chemicals that poisoned the soil and their health, yet failed to save the harvest. Middlemen, those cunning brokers who lurked at the mandi gates, exploited their ignorance, buying their meager yields at rock-bottom prices and reselling them for profit. Debt piled up like storm clouds—loans for seeds, fertilizers, and even food for their families. Ali's wife worried endlessly about their children's education, while Asif's young son fell ill from the chemical fumes, his cough echoing through their modest mud-brick home at night. The brothers argued, their bond strained by the fear of losing everything their father had passed down. Hope seemed as distant as the city lights they could only dream of.

One fateful afternoon, as they sat exhausted under a lone tree, laptop borrowed from a neighbor's son who studied in Lahore, a fellow farmer mentioned Agro Smart Technology (AST). Skeptical but desperate, they opened the website on the old device. Speaking into the microphone in their native Urdu, Ali hesitantly asked, "Kheti mein keere ka ilaj kya hai?" The calm, reassuring voice responded instantly, guiding them through Integrated Pest Management (IPM) techniques—natural remedies like neem oil sprays and biological controls, without the need for harmful over-dosing. Asif uploaded a photo of their infested wheat leaves via the app's simple interface, and within seconds, the AI-powered disease detection module identified the pest as wheat stem rust, providing voice instructions on safe, targeted treatments. No typing, no reading—just spoken wisdom in their own language. They followed the advice meticulously, applying the right amounts at the right times, and watched in awe as their crops began to recover.

But AST offered more than just pest control. The brothers checked real-time weather updates, learning of an impending rain that allowed them to adjust planting schedules. Market prices flashed in spoken Urdu, revealing that middlemen had been underpaying them by 40%. Through the digital marketplace feature, they listed their produce with voice commands—"Bechna hai gehun, kitna rate?"—and connected directly with buyers in nearby cities, securing fair deals without intermediaries. That season, their yield increased by 50%, turning a potential loss into a bountiful harvest. Incomes doubled, debts were cleared, and they even afforded new seeds for the next cycle. As they sat together again, this time with smiles and full bellies, Ali turned to Asif, tears glistening in his eyes. "Bhai, ye AST nahi, hamara naya bhai hai," he said, hugging his brother tightly. The laptop that once seemed alien now felt like a lifeline, and their fields bloomed not just with wheat, but with renewed brotherhood and hope for a brighter future.`,
      storyUrdu: `پنجاب کے دیہی علاقوں کے وسیع و عریض سنہری گندم کے کھیتوں میں، جہاں دھوپ بے رحمی سے برس رہی ہوتی ہے اور مٹی نسلوں کی محنت کی داستانیں سناتی ہے، وہاں دو بھائی علی اور آصف رہتے تھے۔ بڑے بھائی علی، ۴۵ سال کے، ہاتھوں پر گٹے اور پیشانی پر فکر کی لکیروں والے، ہمیشہ اپنے چھوٹے سے خاندانی فارم کی ریڑھ کی ہڈی رہے۔ چھوٹا بھائی آصف، ۳۸ سال کا، وہی تھکا ہوا چہرہ، فطرت کے موڑوں سے لڑتے ہوئے۔ ان کے پانچ ایکڑ کے ٹکڑے کی وجہ سے وہ زندہ تھے، مگر اب یہی مایوسی کا سبب بن گیا تھا۔ کیڑے جیسے آرمی ورم اور ایفڈز خاموش حملہ آوروں کی طرح آتے اور آدھی فصل کھا جاتے۔ کیڑے مار ادویات کے لیبل پڑھ نہ سکنے اور انگریزی ایگری ایپس چلانے کے قابل نہ ہونے کی وجہ سے اندازے سے زہریلی دوائیں چھڑکتے، جو مٹی اور صحت دونوں کو تباہ کرتیں مگر فصل نہ بچا پاتیں۔ منڈی کے دروازوں پر گھات لگائے بیٹھے دلال ان کی جہالت کا فائدہ اٹھاتے، کم سے کم دام پر خریدتے اور منافع کما لیتے۔ قرضے طوفانی بادل کی طرح جمع ہوتے جاتے—بیج، کھاد، یہاں تک کہ گھر کے کھانے کے لیے بھی قرض۔ علی کی بیوی بچوں کی تعلیم کی فکر میں گھلتی رہتی، آصف کا چھوٹا بیٹا کیمیکل کے دھوئیں سے بیمار، رات کو اس کی کھانسی گھر میں گونجتی۔ بھائی آپس میں لڑتے، باپ دادا کی میراث کھونے کے ڈر سے رشتہ کمزور پڑتا جا رہا تھا۔ امید شہر کی روشنیوں جتنی ہی دور لگتی جو وہ صرف خوابوں میں دیکھ سکتے تھے۔

ایک قسمت بدل دینے والے دوپہر، جب وہ تنہا درخت کے نیچے تھک کر بیٹھے تھے، پڑوس کے لڑکے سے لاہور پڑھنے والے کے پاس سے ادھار لایا ہوا لیپ ٹاپ کھولا، ایک ساتھی کسان نے Agro Smart Technology (AST) کا نام لیا۔ شک کی نگاہ سے بھرے مگر مجبور، انہوں نے پرانے لیپ ٹاپ پر ویب سائٹ کھولی۔ مائیک میں اپنی مادری اردو میں علی نے ہچکچاتے ہوئے پوچھا، "کھیتی میں کیڑے کا علاج کیا ہے؟" پرسکون، تسلی دینے والی آواز نے فوراً جواب دیا، Integrated Pest Management (IPM) کی تکنیک بتائی—نیچے تیل کا سپرے، حیاتیاتی کنٹرول، بغیر زہریلی زیادتی کے۔ آصف نے متاثرہ گندم کے پتوں کی تصویر ایپ پر اپ لوڈ کی، سیکنڈوں میں AI نے بیماری کی شناخت کی—wheat stem rust—اور محفوظ، ٹارگٹڈ علاج کی آوازی ہدایات دیں۔ نہ ٹائپنگ، نہ پڑھنا—بس اپنی زبان میں بولی ہوئی حکمت۔ انہوں نے ہر ہدایت پر عمل کیا، ٹھیک مقدار، ٹھیک وقت پر، اور حیرت سے دیکھا کہ فصل صحت یاب ہو رہی ہے۔

مگر AST نے کیڑوں سے زیادہ دیا۔ بھائیوں نے حقیقی وقت کا موسم جانا، آنے والی بارش کی وجہ سے بوائی کا شیڈول ایڈجسٹ کیا۔ منڈی کے ریٹ اردو میں بول کر سنائے گئے، پتہ چلا دلال ۴۰٪ کم دے رہے تھے۔ ڈیجیٹل مارکیٹ پلیس پر آواز سے لسٹنگ کی—"بیچنا ہے گہوں، کتنا ریٹ؟"—اور شہروں کے خریداروں سے براہ راست رابطہ، بغیر دلال کے منصفانہ سودے۔ اس سیزن میں پیداوار ۵۰٪ بڑھی، نقصان کی جگہ خوبصورت فصل۔ آمدنی دگنی، قرضے ختم، اگلے سائیکل کے لیے نئے بیج بھی آ گئے۔ جب دوبارہ بیٹھے تو مسکراتوں اور پیٹ بھرے، علی نے آنکھوں میں آنسو بھرے آصف کو گلے لگایا: "بھائی، یہ AST نہیں، ہمارا نیا بھائی ہے۔" لیپ ٹاپ جو پہلے اجنبی لگتا تھا اب لائف لائن بن گیا، اور کھیتوں میں صرف گندم نہیں، بھائی چارے اور روشن مستقبل کی امید بھی اگنے لگی।`
    },
    {
      id: 2,
      image: `${process.env.PUBLIC_URL}/images/Real pakistani farmers using AST/blog-34-1.jpg`,
      title: 'Hoe and Hope – Karim\'s Battle with the Elements',
      titleUrdu: 'کدال اور امید – کریم کی عناصر سے لڑائی',
      storyEnglish: `Karim, a sturdy 50-year-old farmer from the rice paddies of Sindh, had spent his life wielding a hoe like a warrior's sword, carving furrows into the earth that fed his family for decades. But the land, once generous, had turned treacherous. Erratic weather patterns—droughts followed by flash floods—ruined his rice crops year after year, leaving fields barren and his heart heavy. Unknown diseases crept in, yellowing leaves and stunting growth, but Karim's low literacy meant he couldn't decipher the complex instructions on fertilizer bags or search online for solutions. He sold portions of his land cheaply to pay off debts, watching helplessly as his teenage son dropped out of school to help in the fields, dreams of becoming a teacher shattered. The family meals grew sparse, Karim's wife patching old clothes repeatedly, and the village elders shook their heads, whispering that the gods were angry. Karim's shoulders slumped under the weight of it all, his once-proud stance now bent like the wilted stalks in his paddy. Nights were sleepless, filled with worries about the next monsoon or the pests that seemed invincible, pushing him to the brink of giving up the farm entirely.

Then, one scorching day while resting with his hoe slung over his shoulder, a traveling extension officer demonstrated the AST app on his smartphone. Intrigued, Karim downloaded it, his fingers fumbling but guided by the voice interface. "Barish kab aayegi? Chawal ki bimari ka ilaj batao," he spoke into the phone, his voice thick with doubt. The app's Urdu voice responded warmly, providing precise weather forecasts from integrated APIs, warning of dry spells and suggesting irrigation tips. For the mysterious diseases, he described symptoms aloud—"Pattay peele ho rahe hain"—and the NLP-powered system analyzed them, recommending balanced fertilizers and organic treatments to restore soil health. Offline capabilities meant he could access core advice even in areas with spotty internet, and the photo upload feature confirmed bacterial blight, offering step-by-step voice guidance on eco-friendly cures.

Emboldened, Karim delved deeper. The app's market price module revealed he had been undersold by exploitative buyers, so he used voice commands to list his rice on the digital marketplace, connecting with fair-trade cooperatives. Government schemes he never knew about—subsidies for seeds and equipment—were explained in simple spoken Urdu, helping him apply without paperwork hassles. That harvest, his crops thrived, yields tripling as he avoided losses from weather and pests. Profits surged, allowing him to repurchase lost land and send his son back to school. The family home echoed with laughter again, Karim's wife preparing feasts from their abundance. Standing tall in his field, hoe in hand, Karim gazed at his phone with gratitude, a rare smile breaking through. "AST ne meri umeed wapas la di," he murmured, his voice steady with triumph. The hoe, once a symbol of endless struggle, now represented hope reborn through technology's gentle touch.`,
      storyUrdu: `سندھ کے چاول کے کھیتوں میں کدال کو تلوار کی طرح استعمال کرنے والا مضبوط ۵۰ سالہ کریم اپنی زندگی بھر زمین کھودتا رہا جو اس کے خاندان کو کھلاتی پلاتی تھی۔ مگر زمین جو کبھی سخی تھی اب غدار ہو گئی۔ غیر یقینی موسم—سوکھا پھر طغیانی—سال بہ سال چاول برباد۔ نامعلوم بیماریاں، پتے زرد، نشوونما رکی ہوئی، مگر کم پڑھا لکھا ہونے کی وجہ سے کھاد کے تھیلوں پر لکھی ہدایات نہ سمجھ سکتا، نہ آن لائن تلاش کر سکتا۔ قرض اتارنے کو زمین کے ٹکڑے سستے بیچتا رہا، بیٹا اسکول چھوڑ کر کھیتوں میں آیا، استاد بننے کا خواب ٹوٹ گیا۔ کھانے کم، بیوی پرانے کپڑوں پر پیوند لگاتی، گاؤں کے بزرگ سر ہلاتے کہ دیوتا ناراض ہیں۔ کریم کے کندھے جھک گئے، کندھوں والا وقار مرجھائی ہوئی فصل جیسا۔ راتیں بے خواب، اگلی بارش یا ناقابلِ شکست کیڑوں کی فکر، فارم چھوڑنے کے دہانے پر۔

ایک جھلسا دینے والے دن جب کدال کندھے پر ڈالے آرام کر رہا تھا، ایک گھومنے والا ایکسٹینشن افسر نے AST ایپ دکھائی۔ دلچسپی ہوئی، کریم نے ڈاؤن لوڈ کی، انگلیاں لڑھکتیں مگر آواز انٹرفیس نے رہنمائی کی۔ "بارش کب آئے گی؟ چاول کی بیماری کا علاج بتاؤ" اس نے شک بھری آواز میں کہا۔ اردو آواز نے گرمجوشی سے جواب دیا، APIs سے درست موسم، خشک سالی کی وارننگ، آبپاشی کے مشورے۔ بیماری کے لیے علامات بتائیں—"پتے پیلے ہو رہے ہیں"—NLP نے تجزیہ کیا، متوازن کھاد اور نامیاتی علاج تجویز کیے۔ آف لائن فیچر کی وجہ سے انٹرنیٹ نہ ہونے پر بھی بنیادی مشورے۔ فوٹو اپ لوڈ سے bacterial blight کی تصدیق، ماحول دوست علاج کی آوازی ہدایات۔

ہمت بڑھی تو مزید دریافت کیا۔ مارکیٹ پرائس ماڈیول سے پتہ چلا دلال کم دے رہے تھے، آواز سے ڈیجیٹل مارکیٹ میں لسٹ کیا، منصفانہ تجارت والے کوآپریٹو سے رابطہ۔ حکومتی اسکیمیں جو کبھی نہ سنی تھیں—بیج اور آلات پر سبسڈی—سادہ اردو میں سمجھائیں، کاغذی کارروائی کے بغیر درخواست۔ اس فصل میں کاشت لہلہائی، پیداوار تین گنا، نقصانات سے بچت۔ منافع بڑھے، کھوئی زمین واپس خریدی، بیٹا اسکول واپس۔ گھر میں دوبارہ ہنسی، بیوی کھانوں کی دعوت۔ کھیت میں سیدھا کھڑا کریم فون کو دیکھ مسکرایا: "AST نے میری امید واپس لا دی۔" کدال اب جدوجہد کی نہیں، امید کی علامت تھی۔`
    },
    {
      id: 3,
      image: `${process.env.PUBLIC_URL}/images/Real pakistani farmers using AST/blog-app.jpg`,
      title: 'Field Focus – Tariq\'s Journey from Isolation to Respect',
      titleUrdu: 'کھیت کا فوکس – تنہائی سے عزت تک طارق کا سفر',
      storyEnglish: `Tariq, a veteran grower in his late 50s from the fertile plains near Lahore, had always been a solitary figure in his vast fields, his mustache graying with the passage of time and hardship. Isolation defined his life—no nearby neighbors to share knowledge, and his low education level left him cut off from modern farming insights. Wrong fertilizers, applied blindly, leached into the soil, killing its fertility and yielding stunted crops of cotton and maize. Market information was a mystery; he relied on rumors, often selling at losses to opportunistic traders. Poverty tightened its grip, his health deteriorating from chemical exposure—aches in his joints, shortness of breath—and the village viewed him as a relic of old ways, unworthy of respect. His children, grown and distant in the city, called less often, sensing his fading spirit. Tariq felt the weight of failure, questioning if his life's work amounted to nothing but dust and regret.

A turning point came when a community workshop introduced him to the AST website. Logging in on a borrowed tablet, Tariq spoke tentatively in Urdu: "Zameen kharab ho gayi, khad kaun si dalun?" The voice-assisted platform sprang to life, delivering tailored advice on soil restoration, recommending precise fertilizer mixes based on crop types and weather data. Voice Q&A sessions explained modern techniques like crop rotation and sustainable watering, all without requiring him to read a single word. For persistent issues, he uploaded field photos, and the CNN-based disease detection identified nutrient deficiencies, guiding him with spoken instructions on corrections.

As Tariq implemented the changes, the app's real-time features shone. Weather updates prevented flood damage, and mandi price integrations ensured he sold at peak values. The digital marketplace allowed him to voice-list his produce, forging direct links with buyers and bypassing middlemen. His fields revived, crops lush and abundant, boosting earnings enough to afford medical checkups and family visits. Health improved, and the village now sought his advice, dubbing him "Ustad Tariq." With tears of pride, he reflected on his phone: "AST ne mujhe tanha se maqbool bana diya." No longer isolated, Tariq stood focused in his field, a man reclaimed by innovation and community respect.`,
      storyUrdu: `لاہور کے قریب زرخیز میدانوں میں ۵۰ کے آخر میں طارق، سرمئی مونچھوں والا تنہا کسان۔ تنہائی اس کی زندگی تھی—قریب کوئی پڑوسی نہ، کم تعلیم کی وجہ سے جدید زرعی علم سے کٹا ہوا۔ غلط کھادیں اندھا دھند ڈالیں، مٹی کی زرخیزی ختم، کپاس اور مکئی کی فصل چھوٹی۔ منڈی کی معلومات راز، افواہوں پر انحصار، نقصان پر بیچتا۔ غربت نے گھیر لیا، کیمیکل سے صحت خراب—جوڑوں میں درد، سانس کی تنگی—گاؤں والے پرانے طریقوں کا باقیات سمجھتے۔ شہر میں بچے کم فون کرتے، اس کی روح مرتی محسوس کرتے۔ طارق ناکامی کا بوجھ اٹھاتا، سوچتا زندگی مٹی اور پچھتاوے کے سوا کچھ نہ۔

ایک کمیونٹی ورکشاپ میں AST ویب سائٹ متعارف کروائی گئی۔ ادھار ٹیبلٹ پر لاگ ان کیا، اردو میں بولا: "زمین خراب ہو گئی، کون سی کھاد ڈالوں؟" آواز مددگار پلیٹ فارم نے فوراً مٹی بحالی کے حسب ضرورت مشورے دیے، فصل اور موسم کے مطابق درست کھاد۔ آواز Q&A نے فصل گردشی، پائیدار پانی کے طریقے سمجھائے، ایک لفظ پڑھنے کی ضرورت نہ۔ مسلسل مسائل پر فوٹو اپ لوڈ، CNN بیماری شناخت نے غذائی کمی بتائی، آوازی ہدایات سے درست کیا۔

تبدیلیاں نافذ کیں تو حقیقی وقت فیچر چمکے۔ موسم کی اپ ڈیٹ سے سیلاب کا نقصان بچا، منڈی پرائس سے زیادہ دام ملے۔ ڈیجیٹل مارکیٹ میں آواز سے لسٹنگ، دلال ہٹا کر براہ راست خریدار۔ کھیت زندہ ہوئے، فصل خوبصورت، آمدنی بڑھی، ڈاکٹر اور خاندانی دورے ممکن۔ صحت بہتر، گاؤں والے مشورے مانگتے، "استاد طارق" کہتے۔ فخر کے آنسوؤں سے فون کو دیکھا: "AST نے مجھے تنہا سے مقبول بنا دیا۔" اب تنہا نہیں، جدت اور عزت والا طارق کھیت میں فوکسڈ کھڑا۔`
    },
    {
      id: 4,
      image: `${process.env.PUBLIC_URL}/images/Real pakistani farmers using AST/Farmer-Empowered-with-mobile-tech-1536x643.jpg`,
      title: 'App in Hand – The Season That Was Supposed to Be Habib\'s Last',
      titleUrdu: 'ہاتھ میں ایپ – وہ سیزن جو حبیب کا آخری ہونا تھا',
      storyEnglish: `Habib was 70, living in a cracked mud house on the edge of a Balochistan village where even the wind felt tired. Fifteen years had passed since his wife died, and now he was raising three grandchildren whose parents had been taken by a truck on the highway. Two acres of land, tomatoes, okra, chilies, that was all he had left of his life. But the land had stopped listening to him.

Every year the insects came like an army. Habib couldn't read a single word on the pesticide bottles. He just poured whatever the shopkeeper handed him, sometimes half the bottle, sometimes the whole thing. The soil turned bitter, the plants turned black, the harvest turned to nothing. Debt grew like weeds. At night the grandchildren pressed against his thin blankets, breathing the small, hungry breaths of children who have learned not to complain. The eldest, ten-year-old Amina, had already stopped asking for milk. Habib had made up his mind: after this season, whatever little he could salvage, he would sell the land, take the children to Quetta, and beg if he had to. Pride was a luxury he could no longer afford.

One afternoon, when the sky was the color of rusted iron, a young neighbor named Javed came with an old smartphone and said, "Baba, just talk to it. It speaks Urdu like us." Habib laughed until he coughed, then held the phone like it might bite him. Finally, in a voice cracked from dust and shame, he spoke: "Mere tamatar mar gaye… keede kha gaye… bachchon ke liye kuch bacha do, warna hum sab mar jayenge." The phone answered. A calm, kind man's voice, speaking the same rough Balochi-accented Urdu Habib used. It told him to stop the poison, to boil neem leaves with garlic and soap water, to spray only in the evening, only this much, only these many days. It waited while Habib repeated the instructions aloud to memorize them. When he managed to take a shaky photo of the dying vines, the voice said softly, "Ye powdery mildew hai, Baba. Tension na lo, ye ilaj hai." And it gave the cure, word by word, like a father teaching his son.

Habib followed every syllable like it was Quran. He stopped buying chemicals. He made the spray in an old bucket, hands shaking with hope he hadn't felt in years. The grandchildren watched wide-eyed as the leaves slowly turned green again. He asked the phone, "Aaj tamatar ka rate kya hai?" The voice told him the real price in Quetta mandi, twice what the local arhti ever paid. Trembling, he said, "Bechna hai." Within an hour a restaurant owner called, came the next morning, paid cash, loaded the crates himself. That season the vines were so heavy with fruit that Amina ran between the rows stuffing tomatoes into her shalwar like red balloons, laughing the laugh Habib had forgotten existed. The house filled with smells of cooking Habib hadn't afforded in years. He bought milk, meat, new shoes for the children, and a small silver nose-pin his wife had always wanted but never got. Now every evening Habib sits on the charpai, phone resting on his chest like a second heart. He kisses the screen and whispers the same words every night: "Beta, tune meri maut ko zindagi mein badal diya. Ab main marunga tab bhi hans ke marunga."`,
      storyUrdu: `حبیب ۷۰ سالہ، بلوچستان کے گاؤں کے کنارے ٹوٹی مٹی کی جھونپڑی میں، ہوا بھی تھکی لگتی تھی۔ بیوی گئی ۱۵ سال ہوئے، اب تین پوتے پال رہا تھا جن کے ماں باپ ہائی وے کے ٹرک تلے چلے گئے۔ دو ایکڑ زمین، ٹماٹر، بھنڈی، مرچیں—یہی اس کی زندگی تھی۔ مگر زمین نے سننا چھوڑ دیا تھا۔

ہر سال کیڑے فوج بن کر آتے۔ حبیب ایک لفظ نہ پڑھ سکتا۔ دکاندار جو دیتا وہ ڈال دیتا، کبھی آدھی بوتل، کبھی پوری۔ مٹی کڑوی، پودے کالے، فصل صفر۔ قرضے گھاس کی طرح بڑھتے۔ رات کو پوتے پتلی کمبلوں سے چمٹے بھوکے سانس لیتے۔ دس سالہ آمنہ دودھ مانگنا چھوڑ چکی۔ حبیب نے فیصلہ کر لیا: اس سیزن کے بعد جو ملے زمین بیچ، بچوں کو کوئٹہ لے جاؤ، بھیک ہی مانگنی پڑے۔ عزت اب آسائش نہ تھی۔

ایک دوپہر جب آسمان زنگ آلود لوہے جیسا تھا، پڑوسی جاوید پرانا سمارٹ فون لایا اور بولا، "بابا، بس اس سے بات کرو۔ یہ ہماری طرح اردو بولتا ہے۔" حبیب ہنستا ہنستا کھانس لیا، پھر فون کو کاٹنے والے جانور کی طرح پکڑا۔ آخر کار ٹوٹی پھوٹی آواز میں بولا: "میرے ٹماٹر مر گئے… کیڑے کھا گئے… بچوں کے لیے کچھ بچا دو، ورنہ ہم سب مر جائیں گے۔" فون نے جواب دیا۔ پرسکون، مہربان مرد کی آواز، وہی بلوچی لہجے والی اردو۔ زہر بند کرو، نیم کے پتے، لہسن، صابن پانی ابال کر شام کو سپرے کرو، اتنا، اتنے دن۔ حبیب نے دہرایا تاکہ یاد رہے۔ جب لرزتی تصویر لی تو آواز نے نرم لہجے میں کہا، "یہ پاؤڈری میلڈیو ہے بابا۔ ٹینشن نہ لو، علاج ہے۔" اور لفظ بہ لفظ علاج بتایا، جیسے باپ بیٹے کو سکھاتا۔

حبیب نے ہر ہجے پر عمل کیا جیسے قرآن پڑھ رہا ہو۔ کیمیکل بند، پرانے بالٹی میں سپرے بنایا، ہاتھ امید سے کانپ رہے۔ پوتے حیرت سے دیکھتے رہے جب پتے آہستہ سبز ہوئے۔ پوچھا، "آج ٹماٹر کا ریٹ کیا ہے؟" آواز نے کوئٹہ منڈی کا اصلی ریٹ بتایا، آرٹی والے سے دگنا۔ لرزتے ہوئے بولا، "بیچنا ہے۔" ایک گھنٹے میں ریستوران والا فون آیا، اگلی صبح آیا، نقد دیے، خود کریٹ اٹھائے۔ اس سیزن انگور جیسے ٹماٹر، آمنہ شلوار میں ٹماٹر بھر کر ہنستی دوڑتی۔ گھر میں کھانوں کی خوشبو جو برسوں نہ آئی۔ دودھ، گوشت، بچوں کے جوتے، اور بیوی کی پسندیدہ چاندی کی ناک کی کیل جو کبھی نہ لے سکا۔ اب ہر شام چارپائی پر بیٹھتا، فون سینے پر رکھ کر سکرین چومتا اور رات کو یہی بولتا: "بیٹا، تُو نے میری موت کو زندگی میں بدل دیا۔ اب میں مروں گا تب بھی ہنس کے مروں گا۔"`
    },
    {
      id: 5,
      image: `${process.env.PUBLIC_URL}/images/Real pakistani farmers using AST/iFarmer-app-bangladesh-696x385.jpg`,
      title: 'Cornfield Victory – The Year Saad\'s Corn Grew Taller Than His Fear',
      titleUrdu: 'مکئی کے کھیت کی فتح – وہ سال جب سعد کی مکئی اس کے ڈر سے اونچی ہو گئی',
      storyEnglish: `Saad, 55, Mardan district. Once the strongest man in the mohalla, now the quietest. Three straight years his corn had betrayed him. Fall armyworm, stem borers, whatever new devil arrived, nothing worked anymore. The old chemicals only made the insects laugh. The cobs came out small, hollow, worthless. The bank manager started visiting like a relative nobody wanted. His wife, Naseem, stopped lighting the evening lamp so the children wouldn't see her crying. Saad had already counted the money he would get for selling the ancestral eight acres, enough to pay the bank and disappear into Peshawar as a daily-wage laborer.

One night his cousin shoved a tablet into his hand and said, "Shout at it if you want, just try." Saad shouted, voice raw with rage: "Makki ke keede maar do! Teen saal se kha rahe hain ghar barbaad kar diya!" The AST voice didn't flinch. It named the exact pest from his description, told him the chemicals he was using had created super-insects, ordered him to burn the residue, switch to a new bio-pesticide available at the government store for free under a scheme he had never heard of. It guided him through the subsidy application by voice alone. Two weeks later a tractor arrived with hybrid seed and drip pipes, all free. Every day Saad sent photos; the offline AI answered even when signals died.

Harvest time the stalks stood taller than Saad—taller than him, cobs thick as his forearm, kernels shining like gold. He opened the marketplace and spoke clearly for the first time in months: "Makki bechni hai. Sachcha rate do, jhoot nahi chalega." A livestock feed company from Peshawar sent three trucks, paid triple the local rate, cash before loading. That night Naseem lit every lamp in the house, cooked chicken, wore the gold earrings Saad bought her for the first time in twenty years. The children ran shouting through the rows. Saad stood in the middle of his green ocean, arms raised to the sky, laughing and crying at the same time: "AST ne meri haar ko itni badi jeet bana diya ke ab makki nahi, khushi ug rahi hai zameen se."`,
      storyUrdu: `سعد، ۵۵، مردان۔ محلے کا سب سے طاقتور آدمی اب سب سے خاموش۔ تین سال مسلسل مکئی نے دھوکہ دیا۔ فال آرمی ورم، سٹیم بورر، جو نیا شیطان آیا پرانے کیمیکل ہنس پڑتے۔ بھٹے چھوٹے، خالی، بے کار۔ بینک منیجر ناپسندیدہ رشتے دار کی طرح آنے لگا۔ بیوی نسیم شام کا دیا بجھا دیتی تاکہ بچے اس کے آنسو نہ دیکھیں۔ سعد نے آٹھ ایکڑ آبائی زمین بیچنے کے پیسے گن لیے، بینک ادا کر پشاور مزدور بن جائے۔

ایک رات کزن نے ٹیبلٹ تھماتے ہوئے بولا، "چلاؤ بھی اگر دل کرے، بس کوشش کرو۔" سعد چلایا، غصے سے چیخا: "مکئی کے کیڑے مار دو! تین سال سے کھا رہے ہیں گھر برباد کر دیا!" AST کی آواز نہ ڈری۔ بیان سے درست کیڑا پہچانا، بتایا پرانے کیمیکل سے سپر کیڑے بن گئے، باقیات جلا دو، نئی بائیو دوائی حکومتی اسٹور سے مفت ملے گی، سبسڈی درخواست آواز سے کروائی۔ دو ہفتے بعد ٹریکٹر ہائبرڈ بیج اور ڈرپ پائپ لے آیا، سب مفت۔ روز تصویر بھیجتا، آف لائن AI جواب دیتا۔

فصل کے وقت تنے سعد سے اونچے، بھٹے بازو جتنے موٹے، دانے سونے جیسے۔ مارکیٹ کھول کر پہلی بار واضح بولا: "مکئی بیچنی ہے۔ سچا ریٹ دو، جھوٹ نہیں چلے گا۔" پشاور کی فیڈ کمپنی نے تین ٹرک بھیجے، لوڈنگ سے پہلے تگنا ریٹ نقد دیا۔ رات کو نسیم نے سارے دیے جلا دیے، مرغی پکائی، بیس سال بعد سونے کے جھمکے پہنے۔ بچے کھیتوں میں چیختے دوڑے۔ سعد سبز سمندر میں بازو اٹھا کر ہنستا روتا رہا: "AST نے میری ہار کو اتنی بڑی جیت بنا دیا کہ اب مکئی نہیں، خوشی اگ رہی ہے زمین سے۔"`
    },
    {
      id: 6,
      image: `${process.env.PUBLIC_URL}/images/Real pakistani farmers using AST/istockphoto-2206670537-612x612.jpg`,
      title: 'Sunset Resolve – The Evening Rehman Stopped Hating Sunsets',
      titleUrdu: 'غروبِ آفتاب کا عزم – وہ شام جب رحمان نے غروبِ آفتاب سے نفرت چھوڑ دی',
      storyEnglish: `Rehman, 48, Bahawalpur. Red pagri, cracked hands, millet fields that once fed three generations now feeding only sorrow. Children in the same torn uniforms for two years, wife counting every grain of rice before cooking. Every sunset felt like the sky was closing a coffin lid on another failed day.

One blood-orange evening, sitting on the field boundary, he held his phone for the first time and spoke to the darkening sky: "Jawaar bacha lo. Barish kab? Rate kya? Bata do warna bachche bhookhe mar jayenge." The AST voice came like mercy: three-day forecast, exact irrigation schedule, soil moisture tips, and the real Karachi mandi rate—double what the village arhti had offered for years. Rehman listened as if his life depended on it, because it did. He followed every instruction like a soldier. When the golden heads finally stood proud and safe, he opened the marketplace and said simply: "Mera jawar bechna hai. Seedhi deal, beech mein koi nahi."

A flour mill owner called within minutes, sent a truck the next day, paid full amount in cash, shook Rehman's hand like an equal. The money bought a new tin roof that didn't leak in the first rain, new school bags, meat three times a week, and bangles for his wife that jingled when she laughed. Now every evening Rehman stands at the exact same spot, same sunset, same red pagri. But his back is straight, eyes shining. He lifts the phone toward the horizon and says, voice thick with emotion: "Tune andhera hata diya, AST. Ab har shaam Eid ki shaam hai."`,
      storyUrdu: `رحمان، ۴۸، بہاولپور۔ سرخ پگڑی، ہاتھ پھٹے، جواری کے کھیت تین نسلوں کو کھلاتے اب صرف غم۔ بچے دو سال سے پھٹے یونیفارم، بیوی چاول گنتی پکاتے وقت۔ ہر غروبِ آفتاب لگتا تابوت بند ہو رہا ہے۔

ایک خون جیسا نارنجی غروبِ آفتاب، کھیت کی مینڈھ پر بیٹھا پہلی بار فون ہاتھ میں لیا اور اندھیرے سے بولا: "جواری بچا لو۔ بارش کب؟ ریٹ کیا؟ بتا دو ورنہ بچے بھوکے مر جائیں گے۔" AST کی آواز رحمت بن کر آئی: تین دن کا موسم، بالکل درست آبپاشی شیڈول، مٹی کی نمی کے مشورے، کراچی منڈی کا اصلی ریٹ گاؤں کے آرٹی سے دگنا۔ رحمان نے ہر لفظ کو جان کی طرح سنا۔ ہر ہدایت پر سپاہی کی طرح عمل کیا۔ جب سنہری بالیں فخر سے کھڑی ہوئیں، مارکیٹ کھول کر بس اتنا بولا: "میرا جواری بیچنا ہے۔ سیدھی ڈیل، بیچ میں کوئی نہیں۔"

منٹوں میں آٹا مل مالک نے فون کیا، اگلے دن ٹرک بھیجا، پورے پیسے نقد دیے، ہاتھ ملا کر برابر سمجھا۔ پیسوں سے نیا ٹین کا چھت آیا جو بارش میں نہ ٹپکے، نئے اسکول بیگ، ہفتے میں تین بار گوشت، اور بیوی کے لیے چوڑیاں جو ہنستے وقت بجتیں۔ اب ہر شام وہی جگہ، وہی غروبِ آفتاب، وہی سرخ پگڑی۔ مگر کمر سیدھی، آنکھیں چمکتیں۔ فون افق کی طرف اٹھا کر بولتا ہے، گلے سے: "تُو نے اندھیرا ہٹا دیا AST۔ اب ہر شام عید کی شام ہے۔"`
    }
  ];

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
      {/* Main Content */}
      <Box sx={{ flexGrow: 1 }}>
        {/* Hero Section - Professional & Compact */}
        <Box
          id="home"
          sx={{
            background: 'linear-gradient(135deg, rgba(20, 30, 48, 0.85) 0%, rgba(36, 59, 85, 0.75) 50%, rgba(40, 167, 69, 0.65) 100%), url(https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=1600&q=80) center/cover no-repeat fixed',
            minHeight: '75vh',
            display: 'flex',
            alignItems: 'center',
            color: 'white',
            position: 'relative',
            overflow: 'hidden',
            '&::before': {
              content: '""',
              position: 'absolute',
              top: '-50%',
              right: '-50%',
              width: '200%',
              height: '200%',
              background: 'radial-gradient(circle, rgba(40, 167, 69, 0.15) 0%, transparent 70%)',
              animation: 'rotate 30s linear infinite'
            },
            '&::after': {
              content: '""',
              position: 'absolute',
              bottom: 0,
              left: 0,
              right: 0,
              height: '40%',
              background: 'linear-gradient(to top, rgba(40, 167, 69, 0.2), transparent)',
              pointerEvents: 'none'
            },
            '@keyframes rotate': {
              'from': { transform: 'rotate(0deg)' },
              'to': { transform: 'rotate(360deg)' }
            }
          }}
        >
          <Container maxWidth="lg" sx={{ position: 'relative', zIndex: 1 }}>
            <Box sx={{ 
              textAlign: 'center',
              animation: 'fadeInUp 1.2s ease-out',
              '@keyframes fadeInUp': {
                'from': { opacity: 0, transform: 'translateY(40px)' },
                'to': { opacity: 1, transform: 'translateY(0)' }
              }
            }}>
              {/* Main Headline */}
              <Typography 
                variant="h2" 
                sx={{ 
                  fontWeight: 900, 
                  mb: { xs: 1, md: 1.5 }, 
                  fontSize: { xs: '1.75rem', sm: '2.5rem', md: '3.5rem' },
                  lineHeight: 1.1,
                  letterSpacing: '-0.02em',
                  color: '#fff',
                  textShadow: '0 4px 30px rgba(0,0,0,0.5), 0 0 60px rgba(40,167,69,0.3)',
                  position: 'relative',
                  px: { xs: 2, sm: 0 },
                  '& span': {
                    background: 'linear-gradient(135deg, #4ade80 0%, #22d3ee 50%, #fff 100%)',
                    backgroundClip: 'text',
                    WebkitBackgroundClip: 'text',
                    WebkitTextFillColor: 'transparent',
                    display: 'inline-block'
                  }
                }}
              >
                Empowering <span>Pakistani Farmers</span>
              </Typography>
              
              {/* Urdu Headline */}
              <Typography 
                variant="h4" 
                sx={{ 
                  fontFamily: 'Noto Nastaliq Urdu, serif', 
                  mb: { xs: 1.5, md: 2 }, 
                  fontSize: { xs: '1.25rem', sm: '1.75rem', md: '2.2rem' }, 
                  fontWeight: 700,
                  textShadow: '0 4px 20px rgba(0,0,0,0.6)',
                  color: '#e8f5e9',
                  lineHeight: 1.4,
                  px: { xs: 2, sm: 0 }
                }}
              >
                پاکستانی کسانوں کو بااختیار بنائیں
              </Typography>
              
              {/* Subtitle */}
              <Typography 
                variant="h6" 
                sx={{ 
                  mb: { xs: 3, md: 4 }, 
                  fontFamily: 'Noto Nastaliq Urdu, serif', 
                  fontWeight: 600,
                  fontSize: { xs: '0.95rem', sm: '1.15rem', md: '1.4rem' },
                  color: 'rgba(255,255,255,0.95)',
                  textShadow: '0 2px 15px rgba(0,0,0,0.5)',
                  maxWidth: '800px',
                  mx: 'auto',
                  lineHeight: 1.6,
                  px: { xs: 3, sm: 0 }
                }}
              >
                اردو میں بولیں، تصویر لیں، فوراً جواب پائیں
              </Typography>

              {/* Feature Highlights */}
              <Box sx={{ 
                display: 'flex', 
                gap: { xs: 1.5, sm: 2, md: 4 }, 
                justifyContent: 'center', 
                flexWrap: 'wrap',
                mb: { xs: 4, md: 6 },
                px: { xs: 1, sm: 2 }
              }}>
                {[
                  { icon: '🎤', text: 'Voice Q&A', textUrdu: 'آواز' },
                  { icon: '🌾', text: 'AI Detection', textUrdu: 'تشخیص' },
                  { icon: '📊', text: 'Mandi Rates', textUrdu: 'منڈی' },
                  { icon: '🌦️', text: 'Weather', textUrdu: 'موسم' }
                ].map((item, idx) => (
                  <Box key={idx} sx={{ 
                    bgcolor: 'rgba(255,255,255,0.12)',
                    backdropFilter: 'blur(10px)',
                    border: '1px solid rgba(255,255,255,0.25)',
                    borderRadius: { xs: 2, md: 3 },
                    px: { xs: 1.5, sm: 2, md: 3 },
                    py: { xs: 1, sm: 1.5 },
                    display: 'flex',
                    alignItems: 'center',
                    gap: { xs: 1, sm: 1.5 },
                    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                    '&:hover': {
                      bgcolor: 'rgba(40,167,69,0.25)',
                      transform: 'translateY(-5px)',
                      boxShadow: '0 10px 30px rgba(40,167,69,0.3)',
                      border: '1px solid rgba(74,222,128,0.5)'
                    }
                  }}>
                    <Typography sx={{ fontSize: { xs: '1.3rem', sm: '1.8rem' } }}>{item.icon}</Typography>
                    <Box sx={{ textAlign: 'left' }}>
                      <Typography sx={{ fontWeight: 700, fontSize: { xs: '0.75rem', sm: '0.9rem' }, lineHeight: 1.2 }}>{item.text}</Typography>
                      <Typography sx={{ fontSize: { xs: '0.65rem', sm: '0.75rem' }, fontFamily: 'Noto Nastaliq Urdu', opacity: 0.9 }}>{item.textUrdu}</Typography>
                    </Box>
                  </Box>
                ))}
              </Box>
            
              {/* CTA Buttons */}
              <Box sx={{ display: 'flex', gap: 3, justifyContent: 'center', flexWrap: 'wrap', mb: 6 }}>
                <Button 
                  variant="contained" 
                  size="large"
                  onClick={() => scrollToSection('features')}
                  sx={{ 
                    bgcolor: '#28a745',
                    background: 'linear-gradient(135deg, #28a745 0%, #20c997 100%)',
                    px: 6, 
                    py: 2.5, 
                    fontSize: '1.1rem',
                    fontWeight: 700,
                    borderRadius: 50, 
                    boxShadow: '0 10px 30px rgba(40, 167, 69, 0.5)',
                    transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
                    textTransform: 'none',
                    '&:hover': { 
                      background: 'linear-gradient(135deg, #20c997 0%, #28a745 100%)',
                      transform: 'translateY(-6px) scale(1.02)',
                      boxShadow: '0 15px 40px rgba(40, 167, 69, 0.6)'
                    }
                  }}
                >
                  🚀 Explore Features
                </Button>
                <Button 
                  variant="outlined" 
                  size="large"
                  onClick={() => scrollToSection('download')}
                  sx={{ 
                    borderColor: 'rgba(255,255,255,0.8)', 
                    color: 'white', 
                    px: 6, 
                    py: 2.5, 
                    fontSize: '1.1rem',
                    fontWeight: 700,
                    borderRadius: 50,
                    borderWidth: 2.5,
                    backdropFilter: 'blur(15px)',
                    bgcolor: 'rgba(255,255,255,0.1)',
                    transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
                    textTransform: 'none',
                    '&:hover': {
                      borderWidth: 2.5,
                      borderColor: '#fff',
                      bgcolor: 'rgba(255,255,255,0.25)',
                      transform: 'translateY(-6px) scale(1.02)',
                      boxShadow: '0 15px 40px rgba(255,255,255,0.2)'
                    }
                  }}
                >
                  📱 Download Android App
                </Button>
              </Box>
            </Box>

            {/* Stats Cards - Top right corner to avoid button overlap */}
            <Box sx={{ 
              position: 'absolute', 
              right: { md: '3%', lg: '5%' }, 
              top: { md: '15%', lg: '20%' },
              display: { xs: 'none', md: 'flex' },
              flexDirection: 'column',
              gap: 2,
              maxWidth: { md: 160, lg: 180 },
              zIndex: 10
            }}>
              {[
                { number: '10K+', label: 'Active Farmers', labelUrdu: 'فعال کسان' },
                { number: '50K+', label: 'Queries', labelUrdu: 'سوالات' },
                { number: '95%', label: 'Accuracy', labelUrdu: 'درستگی' }
              ].map((stat, idx) => (
                <Paper 
                  key={idx}
                  sx={{ 
                    p: 2, 
                    textAlign: 'center', 
                    bgcolor: 'rgba(255,255,255,0.1)',
                    backdropFilter: 'blur(15px)',
                    border: '1px solid rgba(255,255,255,0.3)',
                    borderRadius: 2,
                    transition: 'all 0.3s',
                    '&:hover': {
                      bgcolor: 'rgba(255,255,255,0.2)',
                      transform: 'translateX(-8px)',
                      boxShadow: '0 8px 24px rgba(40,167,69,0.3)'
                    }
                  }}
                >
                  <Typography variant="h4" fontWeight="bold" color="white" sx={{ mb: 0.5 }}>
                    {stat.number}
                  </Typography>
                  <Typography variant="caption" color="white" sx={{ fontSize: '0.75rem' }}>
                    {stat.label}
                  </Typography>
                  <Typography variant="caption" sx={{ fontFamily: 'Noto Nastaliq Urdu, serif', color: 'rgba(255,255,255,0.9)', display: 'block', fontSize: '0.7rem' }}>
                    {stat.labelUrdu}
                  </Typography>
                </Paper>
              ))}
            </Box>
          </Container>
        </Box>

        {/* Features Section - Professional & Aligned */}
        <Box id="features" sx={{ py: 8 }}>
          <Container maxWidth="lg">
            <Typography variant="h4" sx={{ textAlign: 'center', mb: 1.5, fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', textShadow: isDark ? '0 2px 12px rgba(74, 222, 128, 0.6)' : '0 2px 8px rgba(40, 167, 69, 0.3)' }}>
              Our Powerful Features
            </Typography>
            <Typography variant="h6" sx={{ textAlign: 'center', mb: 5, fontFamily: 'Noto Nastaliq Urdu, serif', color: isDark ? 'rgba(255,255,255,0.95)' : '#1b5e20', fontWeight: 600 }}>
              ہماری زبردست خصوصیات
            </Typography>
            <Grid container spacing={4}>
              {features.map((feature, idx) => (
                <Grid item xs={12} sm={6} md={4} key={idx}>
                  <Card
                    onMouseEnter={() => setIsHovering(idx)}
                    onMouseLeave={() => setIsHovering(null)}
                    onClick={() => navigate(feature.path)}
                    sx={{
                      height: '100%',
                      cursor: 'pointer',
                      transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
                      transform: isHovering === idx ? 'translateY(-16px) scale(1.03)' : 'translateY(0)',
                      boxShadow: isHovering === idx ? '0 20px 40px rgba(0,0,0,0.15)' : '0 4px 12px rgba(0,0,0,0.08)',
                      borderRadius: 3,
                      overflow: 'hidden',
                      border: isHovering === idx ? '2px solid #28a745' : '2px solid transparent',
                      '&:hover': {
                        '& .feature-icon': {
                          transform: 'rotate(10deg) scale(1.15)',
                          color: '#28a745'
                        },
                        '& .feature-image': {
                          transform: 'scale(1.1)'
                        }
                      }
                    }}
                  >
                    <Box sx={{ overflow: 'hidden', height: 180, bgcolor: '#f5f5f5' }}>
                      <CardMedia
                        className="feature-image"
                        component="img"
                        height="180"
                        image={feature.image}
                        alt={feature.title}
                        sx={{ 
                          transition: 'transform 0.4s ease',
                          objectFit: 'cover',
                          width: '100%'
                        }}
                      />
                    </Box>
                    <CardContent sx={{ textAlign: 'center', p: 2.5, bgcolor: isDark ? 'rgba(26, 31, 53, 0.95)' : 'rgba(255, 255, 255, 0.90)', backdropFilter: 'blur(10px)', color: isDark ? 'white' : '#1b5e20' }}>
                      <Box className="feature-icon" sx={{ color: isDark ? '#4ade80' : '#28a745', mb: 2, transition: 'all 0.3s' }}>
                        {feature.icon}
                      </Box>
                      <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 0.5, color: isDark ? '#ffffff' : '#1b5e20' }}>
                        {feature.title}
                      </Typography>
                      <Typography variant="body2" sx={{ fontFamily: 'Noto Nastaliq Urdu, serif', mb: 1.5, color: isDark ? '#4ade80' : '#28a745', fontWeight: 700 }}>
                        {feature.titleUrdu}
                      </Typography>
                      <Typography variant="body2" sx={{ mb: 0.5, lineHeight: 1.6, color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0, 0, 0, 0.87)' }}>
                        {feature.desc}
                      </Typography>
                      <Typography variant="body2" sx={{ fontFamily: 'Noto Nastaliq Urdu, serif', fontSize: '0.85rem', color: isDark ? 'rgba(255,255,255,0.90)' : 'rgba(0, 0, 0, 0.80)', lineHeight: 1.5 }}>
                        {feature.descUrdu}
                      </Typography>
                    </CardContent>
                  </Card>
                </Grid>
              ))}
            </Grid>
          </Container>
        </Box>

        {/* Gallery Section - Professional Masonry Layout */}
        <Box id="gallery" sx={{ py: 8 }}>
          <Container maxWidth="lg">
            <Typography variant="h4" sx={{ textAlign: 'center', mb: 1.5, fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', textShadow: isDark ? '0 2px 12px rgba(74, 222, 128, 0.6)' : '0 2px 8px rgba(40, 167, 69, 0.3)' }}>
              Real Pakistani Farmers Using AST
            </Typography>
            <Typography variant="h6" sx={{ textAlign: 'center', mb: 2, fontFamily: 'Noto Nastaliq Urdu, serif', color: isDark ? 'rgba(255,255,255,0.95)' : '#1b5e20', fontWeight: 600 }}>
              حقیقی پاکستانی کسان استعمال کر رہے ہیں
            </Typography>
            <Typography variant="body2" sx={{ textAlign: 'center', mb: 5, color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0, 0, 0, 0.80)', maxWidth: 700, mx: 'auto', fontSize: '1rem' }}>
              Thousands of farmers across Punjab, Sindh, and KPK are using AST to improve their crop yield and income through smart technology.
            </Typography>
            <Grid container spacing={2}>
              {farmerStories.map((story, idx) => (
                <Grid item xs={12} sm={6} md={4} key={idx}>
                  <Box
                    sx={{
                      position: 'relative',
                      overflow: 'hidden',
                      borderRadius: 2,
                      boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
                      cursor: 'pointer',
                      height: idx % 3 === 0 ? 280 : idx % 3 === 1 ? 240 : 260,
                      '&:hover': {
                        boxShadow: '0 8px 24px rgba(40,167,69,0.3)',
                        '& img': {
                          transform: 'scale(1.1)'
                        },
                        '& .overlay': {
                          opacity: 1
                        }
                      }
                    }}
                    onClick={() => setSelectedStory(story)}
                  >
                    <Box
                      component="img"
                      src={story.image}
                      alt={story.title}
                      sx={{
                        width: '100%',
                        height: '100%',
                        objectFit: 'cover',
                        transition: 'transform 0.4s ease',
                        userSelect: 'none'
                      }}
                    />
                    <Box
                      className="overlay"
                      sx={{
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        background: 'linear-gradient(to top, rgba(40,167,69,0.9) 0%, rgba(0,0,0,0.3) 50%, transparent 80%)',
                        opacity: 0,
                        transition: 'opacity 0.3s',
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                        justifyContent: 'flex-end',
                        p: 2
                      }}
                    >
                      <Typography variant="subtitle1" sx={{ color: 'white', fontWeight: 'bold', mb: 0.3, fontSize: '0.95rem' }}>
                        {story.title}
                      </Typography>
                      <Typography variant="body2" sx={{ color: 'rgba(255,255,255,0.9)', fontFamily: 'Noto Nastaliq Urdu, serif', mb: 0.5, fontSize: '0.85rem' }}>
                        {story.titleUrdu}
                      </Typography>
                      <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.9)', fontSize: '0.75rem' }}>
                        Click to read story
                      </Typography>
                    </Box>
                  </Box>
                </Grid>
              ))}
            </Grid>
          </Container>
        </Box>

        {/* Download Section */}
        <Box id="download" sx={{ py: 5, textAlign: 'center', bgcolor: isDark ? 'rgba(40, 167, 69, 0.15)' : '#28a745', backdropFilter: 'blur(10px)', borderTop: isDark ? '2px solid rgba(40, 167, 69, 0.3)' : 'none', borderBottom: isDark ? '2px solid rgba(40, 167, 69, 0.3)' : 'none' }}>
          <Container maxWidth="md">
            <Typography variant="h4" sx={{ mb: 1.5, fontWeight: 'bold', color: isDark ? '#4ade80' : 'white', textShadow: isDark ? '0 2px 12px rgba(74, 222, 128, 0.5)' : '0 2px 8px rgba(0,0,0,0.3)' }}>
              Download Android App Now
            </Typography>
            <Typography variant="h6" sx={{ mb: 1.5, fontFamily: 'Noto Nastaliq Urdu, serif', color: isDark ? 'rgba(255,255,255,0.95)' : 'white', fontWeight: 600 }}>
              ابھی اینڈرائیڈ ایپ ڈاؤن لوڈ کریں
            </Typography>
            <Typography variant="body2" sx={{ mb: 3.5, color: isDark ? 'rgba(255,255,255,0.90)' : 'rgba(255,255,255,0.95)', fontSize: '0.95rem' }}>
              Full features available on mobile — synced with this website via Firebase
            </Typography>
            <Box sx={{ display: 'flex', gap: 2.5, justifyContent: 'center', flexWrap: 'wrap' }}>
              <Button
                variant="contained"
                size="medium"
                component="a"
                href="/app-debug.apk"
                download="AgroSmartTech.apk"
                startIcon={<Download />}
                sx={{
                  bgcolor: isDark ? 'rgba(74, 222, 128, 0.95)' : 'white',
                  color: isDark ? '#0a0e1a' : '#28a745',
                  px: 3.5,
                  py: 1.5,
                  fontSize: '0.95rem',
                  fontWeight: 700,
                  boxShadow: isDark ? '0 4px 20px rgba(74, 222, 128, 0.4)' : '0 4px 15px rgba(0,0,0,0.2)',
                  borderRadius: 2,
                  '&:hover': { bgcolor: isDark ? '#4ade80' : '#f8f9fa', transform: 'translateY(-2px)' }
                }}
              >
                Download APK
              </Button>
              <Button
                variant="outlined"
                size="medium"
                component="a"
                href="https://play.google.com/store"
                target="_blank"
                sx={{
                  borderColor: isDark ? '#4ade80' : 'white',
                  color: isDark ? '#4ade80' : 'white',
                  px: 3.5,
                  py: 1.5,
                  fontSize: '0.95rem',
                  fontWeight: 700,
                  borderWidth: 2,
                  borderRadius: 2,
                  backdropFilter: 'blur(10px)',
                  bgcolor: isDark ? 'rgba(74, 222, 128, 0.1)' : 'rgba(255,255,255,0.1)',
                  '&:hover': { borderWidth: 2, bgcolor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(255,255,255,0.2)', transform: 'translateY(-2px)' }
                }}
              >
                Google Play
              </Button>
            </Box>
            <Typography sx={{ mt: 3, fontSize: '0.85rem', color: isDark ? 'rgba(255,255,255,0.90)' : 'rgba(255,255,255,0.95)' }}>
              Download APK directly or get from Google Play Store
            </Typography>
          </Container>
        </Box>

        {/* Contact Section */}
        <Box id="contact" sx={{ py: 8, bgcolor: isDark ? 'rgba(26, 31, 53, 0.3)' : 'rgba(232, 245, 233, 0.5)', backdropFilter: 'blur(8px)' }}>
          <Container maxWidth="lg">
            <Typography variant="h4" sx={{ textAlign: 'center', mb: 1.5, fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', textShadow: isDark ? '0 2px 12px rgba(74, 222, 128, 0.5)' : '0 2px 8px rgba(40, 167, 69, 0.3)' }}>
              Contact Us
            </Typography>
            <Typography variant="h6" sx={{ textAlign: 'center', mb: 4, fontFamily: 'Noto Nastaliq Urdu, serif', color: isDark ? 'rgba(255,255,255,0.95)' : '#1b5e20', fontWeight: 600 }}>
              رابطہ کریں
            </Typography>
            <Box sx={{ maxWidth: 800, mx: 'auto' }}>
              <Paper sx={{ p: 5, boxShadow: isDark ? '0 8px 32px rgba(0,0,0,0.5)' : '0 4px 20px rgba(0,0,0,0.1)', bgcolor: isDark ? 'rgba(26, 31, 53, 0.95)' : 'rgba(255, 255, 255, 0.95)', backdropFilter: 'blur(12px)', border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : 'none', borderRadius: 3 }}>
                <form onSubmit={handleSubmit}>
                  <Grid container spacing={3}>
                    <Grid item xs={12} md={6}>
                      <TextField
                        fullWidth
                        label="Your Name — آپ کا نام"
                        variant="outlined"
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        required
                        InputProps={{
                          style: { color: isDark ? '#fff' : '#000' }
                        }}
                        InputLabelProps={{
                          style: { color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)' }
                        }}
                        sx={{
                          '& .MuiOutlinedInput-root': {
                            '& fieldset': { borderColor: isDark ? 'rgba(255,255,255,0.3)' : 'rgba(0,0,0,0.23)' },
                            '&:hover fieldset': { borderColor: isDark ? '#4ade80' : '#28a745' },
                            '&.Mui-focused fieldset': { borderColor: isDark ? '#4ade80' : '#28a745' }
                          }
                        }}
                      />
                    </Grid>
                    <Grid item xs={12} md={6}>
                      <TextField
                        fullWidth
                        label="Phone +92"
                        variant="outlined"
                        type="tel"
                        value={formData.phone}
                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                        required
                        InputProps={{
                          style: { color: isDark ? '#fff' : '#000' }
                        }}
                        InputLabelProps={{
                          style: { color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)' }
                        }}
                        sx={{
                          '& .MuiOutlinedInput-root': {
                            '& fieldset': { borderColor: isDark ? 'rgba(255,255,255,0.3)' : 'rgba(0,0,0,0.23)' },
                            '&:hover fieldset': { borderColor: isDark ? '#4ade80' : '#28a745' },
                            '&.Mui-focused fieldset': { borderColor: isDark ? '#4ade80' : '#28a745' }
                          }
                        }}
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        fullWidth
                        label="Your message — آپ کا پیغام"
                        variant="outlined"
                        multiline
                        rows={6}
                        value={formData.message}
                        onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                        required
                        InputProps={{
                          style: { color: isDark ? '#fff' : '#000' }
                        }}
                        InputLabelProps={{
                          style: { color: isDark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.6)' }
                        }}
                        sx={{
                          '& .MuiOutlinedInput-root': {
                            '& fieldset': { borderColor: isDark ? 'rgba(255,255,255,0.3)' : 'rgba(0,0,0,0.23)' },
                            '&:hover fieldset': { borderColor: isDark ? '#4ade80' : '#28a745' },
                            '&.Mui-focused fieldset': { borderColor: isDark ? '#4ade80' : '#28a745' }
                          }
                        }}
                      />
                    </Grid>
                    <Grid item xs={12} sx={{ textAlign: 'center' }}>
                      <Button
                        type="submit"
                        variant="contained"
                        size="large"
                        sx={{
                          bgcolor: isDark ? '#4ade80' : '#28a745',
                          color: isDark ? '#0a0e1a' : 'white',
                          px: 6,
                          py: 1.8,
                          fontSize: '1.05rem',
                          fontWeight: 700,
                          borderRadius: 2,
                          boxShadow: isDark ? '0 4px 20px rgba(74, 222, 128, 0.4)' : '0 4px 15px rgba(40, 167, 69, 0.3)',
                          '&:hover': { bgcolor: isDark ? '#22d3ee' : '#1e7e34', transform: 'translateY(-2px)', boxShadow: isDark ? '0 6px 25px rgba(74, 222, 128, 0.5)' : '0 6px 20px rgba(40, 167, 69, 0.4)' }
                        }}
                      >
                        Send Message — پیغام بھیجیں
                      </Button>
                    </Grid>
                  </Grid>
                </form>
              </Paper>
            </Box>
          </Container>
        </Box>
      </Box>

      {/* Professional Dark Theme Footer */}
      <Box sx={{ 
        bgcolor: isDark ? 'rgba(26, 31, 53, 0.95)' : 'rgba(26, 26, 26, 0.95)', 
        color: 'white', 
        pt: 6, 
        pb: 3,
        backdropFilter: 'blur(10px)',
        borderTop: `1px solid ${isDark ? 'rgba(255,255,255,0.1)' : 'rgba(255,255,255,0.05)'}` 
      }}>
        <Container maxWidth="lg">
          <Grid container spacing={4}>
            {/* About Column */}
            <Grid item xs={12} md={4}>
              <Box sx={{ mb: 3 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                  <Box sx={{ 
                    width: 40, 
                    height: 40, 
                    bgcolor: '#28a745', 
                    borderRadius: 1, 
                    display: 'flex', 
                    alignItems: 'center', 
                    justifyContent: 'center',
                    color: 'white',
                    fontSize: '1.2rem',
                    fontWeight: 700
                  }}>
                    AST
                  </Box>
                  <Typography variant="h6" sx={{ fontWeight: 'bold', color: '#28a745' }}>
                    Agro Smart Technology
                  </Typography>
                </Box>
                <Typography variant="body2" sx={{ color: '#b0b0b0', lineHeight: 1.7, mb: 2 }}>
                  A multilingual (Urdu + English) voice-assisted web and mobile platform designed specifically for Pakistani smallholder farmers. Providing voice-based guidance on modern farming techniques, pest identification, weather updates, market prices, and direct buyer-seller connection through a digital marketplace.
                </Typography>
                <Typography variant="body2" sx={{ fontFamily: 'Noto Nastaliq Urdu, serif', color: '#b0b0b0', lineHeight: 1.9 }}>
                  پاکستانی چھوٹے کسانوں کے لیے صوتی مدد کا پلیٹ فارم
                </Typography>
              </Box>
            </Grid>

            {/* Quick Links Column */}
            <Grid item xs={12} sm={6} md={2}>
              <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 2, color: '#28a745' }}>
                Quick Links
              </Typography>
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                {['Home', 'Features', 'Gallery', 'Download', 'Contact'].map((item) => (
                  <Link
                    key={item}
                    href={`#${item.toLowerCase()}`}
                    sx={{
                      color: '#b0b0b0',
                      textDecoration: 'none',
                      fontSize: '0.9rem',
                      '&:hover': {
                        color: '#28a745',
                        textDecoration: 'underline'
                      }
                    }}
                  >
                    {item}
                  </Link>
                ))}
              </Box>
            </Grid>

            {/* Features Column */}
            <Grid item xs={12} sm={6} md={3}>
              <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 2, color: '#28a745' }}>
                Features
              </Typography>
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                {[
                  'Voice Q&A in Urdu',
                  'AI Disease Detection',
                  'Real-Time Mandi Rates',
                  'Weather Forecast',
                  'Digital Marketplace'
                ].map((item) => (
                  <Typography
                    key={item}
                    variant="body2"
                    sx={{ color: '#b0b0b0', fontSize: '0.9rem' }}
                  >
                    • {item}
                  </Typography>
                ))}
              </Box>
            </Grid>

            {/* Contact Column */}
            <Grid item xs={12} md={3}>
              <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 2, color: '#28a745' }}>
                Contact Us
              </Typography>
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1.5 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                  <Email sx={{ fontSize: 20, color: '#28a745' }} />
                  <Link
                    href="mailto:syedshahh1214@gmail.com"
                    sx={{
                      color: '#b0b0b0',
                      textDecoration: 'none',
                      fontSize: '0.85rem',
                      '&:hover': { color: '#28a745' }
                    }}
                  >
                    syedshahh1214@gmail.com
                  </Link>
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                  <Email sx={{ fontSize: 20, color: '#28a745' }} />
                  <Link
                    href="mailto:malikabdulrehman964@gmail.com"
                    sx={{
                      color: '#b0b0b0',
                      textDecoration: 'none',
                      fontSize: '0.85rem',
                      '&:hover': { color: '#28a745' }
                    }}
                  >
                    malikabdulrehman964@gmail.com
                  </Link>
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                  <Phone sx={{ fontSize: 20, color: '#28a745' }} />
                  <Typography variant="body2" sx={{ color: '#b0b0b0', fontSize: '0.85rem' }}>
                    +92-XXX-XXXXXXX
                  </Typography>
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                  <LocationOn sx={{ fontSize: 20, color: '#28a745' }} />
                  <Typography variant="body2" sx={{ color: '#b0b0b0', fontSize: '0.85rem' }}>
                    UMT, Lahore, Pakistan
                  </Typography>
                </Box>
              </Box>

              {/* Social Media Links */}
              <Box sx={{ mt: 3 }}>
                <Typography variant="subtitle2" sx={{ fontWeight: 'bold', mb: 1.5, color: '#28a745' }}>
                  Follow Us
                </Typography>
                <Box sx={{ display: 'flex', gap: 1 }}>
                  <IconButton
                    component="a"
                    href="https://www.facebook.com/profile.php?id=61571086219866"
                    target="_blank"
                    sx={{
                      bgcolor: '#2e2e2e',
                      color: '#b0b0b0',
                      '&:hover': {
                        bgcolor: '#28a745',
                        color: 'white',
                        transform: 'translateY(-3px)'
                      },
                      transition: 'all 0.3s'
                    }}
                  >
                    <Facebook fontSize="small" />
                  </IconButton>
                  <IconButton
                    component="a"
                    href="https://twitter.com/agrosmarttech"
                    target="_blank"
                    sx={{
                      bgcolor: '#2e2e2e',
                      color: '#b0b0b0',
                      '&:hover': {
                        bgcolor: '#28a745',
                        color: 'white',
                        transform: 'translateY(-3px)'
                      },
                      transition: 'all 0.3s'
                    }}
                  >
                    <Twitter fontSize="small" />
                  </IconButton>
                  <IconButton
                    component="a"
                    href="https://instagram.com/agrosmarttech"
                    target="_blank"
                    sx={{
                      bgcolor: '#2e2e2e',
                      color: '#b0b0b0',
                      '&:hover': {
                        bgcolor: '#28a745',
                        color: 'white',
                        transform: 'translateY(-3px)'
                      },
                      transition: 'all 0.3s'
                    }}
                  >
                    <Instagram fontSize="small" />
                  </IconButton>
                  <IconButton
                    component="a"
                    href="https://linkedin.com/company/agrosmarttech"
                    target="_blank"
                    sx={{
                      bgcolor: '#2e2e2e',
                      color: '#b0b0b0',
                      '&:hover': {
                        bgcolor: '#28a745',
                        color: 'white',
                        transform: 'translateY(-3px)'
                      },
                      transition: 'all 0.3s'
                    }}
                  >
                    <LinkedIn fontSize="small" />
                  </IconButton>
                  <IconButton
                    component="a"
                    href="https://github.com/SyedShahHussain1214/Agro-Smart-Technology-AST-"
                    target="_blank"
                    sx={{
                      bgcolor: '#2e2e2e',
                      color: '#b0b0b0',
                      '&:hover': {
                        bgcolor: '#28a745',
                        color: 'white',
                        transform: 'translateY(-3px)'
                      },
                      transition: 'all 0.3s'
                    }}
                  >
                    <GitHub fontSize="small" />
                  </IconButton>
                </Box>
              </Box>
            </Grid>
          </Grid>

          {/* Bottom Bar */}
          <Divider sx={{ my: 3, borderColor: '#2e2e2e' }} />
          <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, justifyContent: 'space-between', alignItems: 'center', gap: 2 }}>
            <Typography variant="body2" sx={{ color: '#808080', fontSize: '0.85rem', textAlign: { xs: 'center', md: 'left' } }}>
              © 2025 Agro Smart Technology. All rights reserved. | Final Year Project 2024-2025
            </Typography>
            <Typography variant="body2" sx={{ color: '#808080', fontSize: '0.85rem', textAlign: { xs: 'center', md: 'right' } }}>
              Developed by <strong style={{ color: '#28a745' }}>Syed Shah Hussain</strong> (S2024387008) & <strong style={{ color: '#28a745' }}>Malik Abdul Rehman</strong> (S2024387002)
            </Typography>
          </Box>
          <Typography variant="body2" sx={{ color: '#606060', fontSize: '0.75rem', textAlign: 'center', mt: 1 }}>
            The College of Art, Science & Technology | University of Management & Technology, Lahore
          </Typography>
          <Typography variant="body2" sx={{ color: '#505050', fontSize: '0.7rem', textAlign: 'center', mt: 0.5 }}>
            Supervisor: <strong style={{ color: '#28a745' }}>Miss Saima Safdar</strong> (Lecturer, UMT)
          </Typography>
        </Container>
      </Box>

      {/* Story Modal with Smooth Animations & Bright Greenish Blur Background */}
      {selectedStory && (
        <Box
          onClick={(e) => {
            if (e.target === e.currentTarget) setSelectedStory(null);
          }}
          sx={{
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            zIndex: 9999,
            background: isDark ? 'rgba(10, 14, 26, 0.5)' : 'rgba(40, 167, 69, 0.25)',
            backdropFilter: 'blur(20px) brightness(1.2) saturate(150%)',
            WebkitBackdropFilter: 'blur(20px) brightness(1.2) saturate(150%)',
            display: 'flex',
            alignItems: { xs: 'flex-start', md: 'center' },
            justifyContent: 'center',
            p: { xs: 0, md: 4 },
            overflow: 'auto',
            animation: 'fadeIn 0.3s ease-out',
            '@keyframes fadeIn': {
              from: { opacity: 0 },
              to: { opacity: 1 }
            }
          }}
        >
          <Box
            sx={{
              position: 'relative',
              maxWidth: 900,
              width: '100%',
              maxHeight: { xs: '100vh', md: '90vh' },
              overflow: 'auto',
              borderRadius: { xs: 0, md: 4 },
              background: isDark ? 'rgba(26, 31, 53, 0.98)' : '#fff',
              backdropFilter: 'blur(10px)',
              border: isDark ? '1px solid rgba(255,255,255,0.2)' : 'none',
              boxShadow: '0 20px 60px rgba(0,0,0,0.5)',
              animation: { xs: 'slideDown 0.4s cubic-bezier(0.16, 1, 0.3, 1)', md: 'slideDownDesktop 0.4s cubic-bezier(0.16, 1, 0.3, 1)' },
              '@keyframes slideDown': {
                from: {
                  opacity: 0,
                  transform: 'translateY(-100px)'
                },
                to: {
                  opacity: 1,
                  transform: 'translateY(0)'
                }
              },
              '@keyframes slideDownDesktop': {
                from: {
                  opacity: 0,
                  transform: 'translateY(-60px) scale(0.95)'
                },
                to: {
                  opacity: 1,
                  transform: 'translateY(0) scale(1)'
                }
              },
              '&::-webkit-scrollbar': {
                width: '12px'
              },
              '&::-webkit-scrollbar-track': {
                background: 'rgba(0,0,0,0.1)',
                borderRadius: '10px'
              },
              '&::-webkit-scrollbar-thumb': {
                background: 'linear-gradient(180deg, #28a745, #20c997)',
                borderRadius: '10px',
                '&:hover': {
                  background: 'linear-gradient(180deg, #20c997, #17a2b8)'
                }
              }
            }}
          >
            {/* Close Button */}
            <IconButton
              onClick={() => setSelectedStory(null)}
              sx={{
                position: 'sticky',
                top: { xs: 10, md: 20 },
                right: { xs: 10, md: 20 },
                float: 'right',
                mb: -5,
                mr: { xs: 1, md: 2 },
                mt: { xs: 1, md: 2 },
                bgcolor: 'rgba(220,53,69,0.95)',
                color: '#fff',
                zIndex: 10,
                width: { xs: 40, md: 48 },
                height: { xs: 40, md: 48 },
                boxShadow: '0 4px 12px rgba(0,0,0,0.3)',
                '&:hover': {
                  bgcolor: 'rgba(220,53,69,1)',
                  transform: 'scale(1.1) rotate(90deg)',
                  boxShadow: '0 6px 20px rgba(220,53,69,0.4)'
                },
                transition: 'all 0.3s ease'
              }}
            >
              <Close sx={{ fontSize: { xs: 20, md: 24 } }} />
            </IconButton>

            {/* Image Section with Smooth Animation */}
            <Box
              sx={{
                position: 'relative',
                height: { xs: 250, sm: 320, md: 400 },
                overflow: 'hidden',
                borderRadius: { xs: 0, md: '16px 16px 0 0' }
              }}
            >
              <CardMedia
                component="img"
                image={selectedStory.image}
                alt={selectedStory.title}
                sx={{
                  width: '100%',
                  height: '100%',
                  objectFit: 'cover',
                  animation: 'zoomIn 0.5s ease-out',
                  '@keyframes zoomIn': {
                    from: {
                      transform: 'scale(1.1)',
                      opacity: 0
                    },
                    to: {
                      transform: 'scale(1)',
                      opacity: 1
                    }
                  }
                }}
              />
              <Box
                sx={{
                  position: 'absolute',
                  bottom: 0,
                  left: 0,
                  right: 0,
                  p: { xs: 2, sm: 3, md: 4 },
                  background: isDark
                    ? 'linear-gradient(to top, rgba(26,31,53,0.95) 0%, rgba(26,31,53,0.6) 50%, transparent 100%)'
                    : 'linear-gradient(to top, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.4) 60%, transparent 100%)',
                  animation: 'slideInUp 0.5s ease-out 0.2s backwards',
                  '@keyframes slideInUp': {
                    from: {
                      opacity: 0,
                      transform: 'translateY(30px)'
                    },
                    to: {
                      opacity: 1,
                      transform: 'translateY(0)'
                    }
                  }
                }}
              >
                <Typography 
                  variant="h4" 
                  sx={{ 
                    fontWeight: 700, 
                    color: '#fff',
                    mb: 1,
                    fontSize: { xs: '1.5rem', sm: '1.8rem', md: '2.125rem' },
                    textShadow: '0 2px 12px rgba(0,0,0,0.8)',
                    lineHeight: 1.3
                  }}
                >
                  {selectedStory.title}
                </Typography>
                <Typography 
                  variant="h5" 
                  sx={{ 
                    fontFamily: 'Noto Nastaliq Urdu, serif',
                    color: '#28a745',
                    fontWeight: 700,
                    fontSize: { xs: '1.2rem', sm: '1.4rem', md: '1.5rem' },
                    textShadow: '0 2px 12px rgba(0,0,0,0.8)',
                    lineHeight: 1.8
                  }}
                >
                  {selectedStory.titleUrdu}
                </Typography>
              </Box>
            </Box>

            {/* Story Content with Smooth Animation */}
            <Box sx={{ 
              p: { xs: 2.5, sm: 3.5, md: 5 },
              animation: 'fadeInContent 0.4s ease-out 0.3s backwards',
              '@keyframes fadeInContent': {
                from: {
                  opacity: 0,
                  transform: 'translateY(15px)'
                },
                to: {
                  opacity: 1,
                  transform: 'translateY(0)'
                }
              }
            }}>
              {/* English Story */}
              <Box sx={{ mb: 5 }}>
                <Box 
                  sx={{ 
                    display: 'inline-flex',
                    px: 2,
                    py: 0.5,
                    borderRadius: 1,
                    bgcolor: '#28a745',
                    mb: 2
                  }}
                >
                  <Typography 
                    variant="subtitle2" 
                    sx={{ 
                      fontWeight: 700,
                      color: '#fff',
                      letterSpacing: '1px'
                    }}
                  >
                    ENGLISH
                  </Typography>
                </Box>
                <Typography 
                  variant="body1" 
                  sx={{ 
                    color: isDark ? 'rgba(255,255,255,0.9)' : '#333',
                    lineHeight: 1.8,
                    fontSize: { xs: '0.95rem', sm: '1rem', md: '1.05rem' },
                    textAlign: 'justify',
                    whiteSpace: 'pre-line'
                  }}
                >
                  {selectedStory.storyEnglish}
                </Typography>
              </Box>

              {/* Divider */}
              <Box
                sx={{
                  height: 2,
                  background: isDark
                    ? 'linear-gradient(90deg, transparent, rgba(40,167,69,0.6), transparent)'
                    : 'linear-gradient(90deg, transparent, #28a745, transparent)',
                  mb: 5,
                  borderRadius: 2
                }}
              />

              {/* Urdu Story */}
              <Box>
                <Box 
                  sx={{ 
                    display: 'inline-flex',
                    px: 2,
                    py: 0.5,
                    borderRadius: 1,
                    bgcolor: '#20c997',
                    mb: 2
                  }}
                >
                  <Typography 
                    variant="subtitle2" 
                    sx={{ 
                      fontWeight: 700,
                      color: '#fff',
                      letterSpacing: '1px',
                      fontFamily: 'Noto Nastaliq Urdu, serif'
                    }}
                  >
                    اردو
                  </Typography>
                </Box>
                <Typography 
                  variant="body1" 
                  sx={{ 
                    fontFamily: 'Noto Nastaliq Urdu, serif',
                    color: isDark ? 'rgba(255,255,255,0.9)' : '#333',
                    lineHeight: 2.1,
                    fontSize: { xs: '1.05rem', sm: '1.12rem', md: '1.18rem' },
                    textAlign: 'right',
                    direction: 'rtl',
                    whiteSpace: 'pre-line'
                  }}
                >
                  {selectedStory.storyUrdu}
                </Typography>
              </Box>
            </Box>
          </Box>
        </Box>
      )}
    </Box>
  );
}

// Beautiful Theme Toggle Button Component
function ThemeToggleButton() {
  const { isDark, toggleTheme } = useThemeMode();
  
  return (
    <Tooltip title={isDark ? "Switch to Light Mode" : "Switch to Dark Mode"} placement="bottom">
      <Box
        onClick={toggleTheme}
        sx={{
          position: 'relative',
          width: 56,
          height: 28,
          borderRadius: 14,
          background: isDark 
            ? 'linear-gradient(135deg, #1a1f35 0%, #0a0e1a 100%)'
            : 'linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%)',
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          padding: '2px',
          border: '2px solid',
          borderColor: isDark ? 'rgba(255,255,255,0.2)' : 'rgba(251, 191, 36, 0.5)',
          transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
          mr: 1,
          '&:hover': {
            transform: 'scale(1.05)',
            boxShadow: isDark 
              ? '0 4px 20px rgba(74, 222, 128, 0.4)'
              : '0 4px 20px rgba(251, 191, 36, 0.4)',
          }
        }}
      >
        {/* Sliding Toggle */}
        <Box
          sx={{
            position: 'absolute',
            width: 22,
            height: 22,
            borderRadius: '50%',
            background: isDark
              ? 'linear-gradient(135deg, #4ade80 0%, #28a745 100%)'
              : 'linear-gradient(135deg, #ffffff 0%, #f3f4f6 100%)',
            boxShadow: isDark
              ? '0 2px 8px rgba(74, 222, 128, 0.5)'
              : '0 2px 8px rgba(0, 0, 0, 0.2)',
            transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
            transform: isDark ? 'translateX(28px)' : 'translateX(0px)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          {isDark ? (
            <DarkMode sx={{ fontSize: 14, color: '#0a0e1a' }} />
          ) : (
            <LightMode sx={{ fontSize: 14, color: '#f59e0b' }} />
          )}
        </Box>
        
        {/* Background Icons */}
        <Box sx={{ 
          position: 'absolute', 
          left: 6, 
          opacity: isDark ? 0 : 1,
          transition: 'opacity 0.3s'
        }}>
          <LightMode sx={{ fontSize: 14, color: 'rgba(255,255,255,0.7)' }} />
        </Box>
        <Box sx={{ 
          position: 'absolute', 
          right: 6,
          opacity: isDark ? 1 : 0,
          transition: 'opacity 0.3s'
        }}>
          <DarkMode sx={{ fontSize: 14, color: 'rgba(74, 222, 128, 0.5)' }} />
        </Box>
      </Box>
    </Tooltip>
  );
}

// Permanent Header Component with About Us
function PermanentHeader() {
  const { isDark } = useThemeMode();
  const navigate = useNavigate();
  const location = window.location.pathname;
  const isHomePage = location === '/';
  const [aboutDrawerOpen, setAboutDrawerOpen] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  
  const scrollToSection = (sectionId) => {
    if (!isHomePage) {
      navigate('/');
      setTimeout(() => {
        document.getElementById(sectionId)?.scrollIntoView({ behavior: 'smooth' });
      }, 100);
    } else {
      document.getElementById(sectionId)?.scrollIntoView({ behavior: 'smooth' });
    }
  };
  
  return (
    <>
      <AppBar 
        position="sticky" 
        sx={{ 
          background: isDark 
            ? 'linear-gradient(135deg, rgba(26, 31, 53, 0.95) 0%, rgba(40, 167, 69, 0.85) 100%)'
            : 'linear-gradient(135deg, #28a745 0%, #20a745 100%)',
          backdropFilter: 'blur(10px)',
          boxShadow: isDark ? '0 4px 20px rgba(40, 167, 69, 0.5)' : '0 4px 20px rgba(40, 167, 69, 0.3)',
          zIndex: 10000,
          borderBottom: isDark ? '1px solid rgba(255,255,255,0.1)' : 'none'
        }}
      >
        <Toolbar sx={{ minHeight: { xs: 56, sm: 64 }, py: 0.5 }}>
          {/* Back Button (only on sub-pages) */}
          {!isHomePage && (
            <Tooltip title="Go Back" placement="right">
              <IconButton
                onClick={() => navigate(-1)}
                sx={{
                  color: 'white',
                  bgcolor: 'rgba(255,255,255,0.15)',
                  '&:hover': {
                    bgcolor: 'rgba(255,255,255,0.25)',
                    transform: 'translateX(-4px)'
                  },
                  transition: 'all 0.3s ease',
                  mr: 1
                }}
              >
                <ArrowBack />
              </IconButton>
            </Tooltip>
          )}
          
          {/* Logo */}
          <Box 
            sx={{ 
              display: 'flex', 
              alignItems: 'center', 
              gap: { xs: 0.5, sm: 1 }, 
              cursor: 'pointer',
              flex: 1
            }} 
            onClick={() => navigate('/')}
          >
            <Box sx={{ 
              width: { xs: 36, sm: 40 }, 
              height: { xs: 36, sm: 40 }, 
              bgcolor: 'white', 
              borderRadius: 1, 
              display: 'flex', 
              alignItems: 'center', 
              justifyContent: 'center',
              color: '#28a745',
              fontSize: { xs: '1rem', sm: '1.2rem' },
              fontWeight: 700,
              boxShadow: '0 2px 8px rgba(0,0,0,0.2)'
            }}>
              AST
            </Box>
            <Box sx={{ display: { xs: 'none', sm: 'block' } }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 'bold', color: 'white', lineHeight: 1.2, fontSize: { sm: '0.9rem', md: '1rem' } }}>
                Agro Smart Technology
              </Typography>
              <Typography sx={{ fontSize: '0.7rem', fontFamily: 'Noto Nastaliq Urdu, serif', color: 'rgba(255,255,255,0.95)', fontWeight: 600, lineHeight: 1 }}>
                ذہین زرعی مشیر
              </Typography>
            </Box>
          </Box>
          
          {/* Mobile Menu Button */}
          <Box sx={{ display: { xs: 'flex', md: 'none' }, gap: 0.5 }}>
            <Tooltip title="Menu">
              <IconButton
                onClick={() => setMobileMenuOpen(true)}
                sx={{
                  color: 'white',
                  bgcolor: 'rgba(255,255,255,0.15)',
                  '&:hover': {
                    bgcolor: 'rgba(255,255,255,0.25)'
                  }
                }}
              >
                <Menu />
              </IconButton>
            </Tooltip>
          </Box>
          
          {/* Navigation Buttons (Desktop) */}
          <Box sx={{ display: { xs: 'none', md: 'flex' }, gap: 1, mr: 1 }}>
            <Button onClick={() => scrollToSection('home')} sx={{ color: 'white', fontWeight: 500, '&:hover': { bgcolor: 'rgba(255,255,255,0.15)' } }}>Home</Button>
            <Button onClick={() => scrollToSection('features')} sx={{ color: 'white', fontWeight: 500, '&:hover': { bgcolor: 'rgba(255,255,255,0.15)' } }}>Features</Button>
            <Button onClick={() => scrollToSection('gallery')} sx={{ color: 'white', fontWeight: 500, '&:hover': { bgcolor: 'rgba(255,255,255,0.15)' } }}>Gallery</Button>
            <Button onClick={() => scrollToSection('download')} sx={{ color: 'white', fontWeight: 500, '&:hover': { bgcolor: 'rgba(255,255,255,0.15)' } }}>Download</Button>
            <Button onClick={() => scrollToSection('contact')} sx={{ color: 'white', fontWeight: 500, '&:hover': { bgcolor: 'rgba(255,255,255,0.15)' } }}>Contact</Button>
          </Box>
          
          {/* About Us Button (Desktop Only) */}
          <Box sx={{ display: { xs: 'none', md: 'block' } }}>
            <Tooltip title="About Us" placement="left">
              <IconButton
                onClick={() => setAboutDrawerOpen(true)}
                sx={{
                  color: 'white',
                  bgcolor: 'rgba(255,255,255,0.15)',
                  '&:hover': {
                    bgcolor: 'rgba(255,255,255,0.25)',
                    transform: 'scale(1.1)'
                  },
                  transition: 'all 0.3s ease',
                  mr: 1
                }}
              >
                <Info />
              </IconButton>
            </Tooltip>
          </Box>

          {/* Theme Toggle Button */}
          <ThemeToggleButton />
          
          {/* Home Button (only on sub-pages) */}
          {!isHomePage && (
            <Tooltip title="Home" placement="left">
              <IconButton
                onClick={() => navigate('/')}
                sx={{
                  color: 'white',
                  bgcolor: 'rgba(255,255,255,0.15)',
                  '&:hover': {
                    bgcolor: 'rgba(255,255,255,0.25)',
                    transform: 'scale(1.1)'
                  },
                  transition: 'all 0.3s ease'
                }}
              >
                <HomeIcon />
              </IconButton>
            </Tooltip>
          )}
        </Toolbar>
      </AppBar>
      
      {/* About Us Drawer */}
      <Drawer
        anchor="right"
        open={aboutDrawerOpen}
        onClose={() => setAboutDrawerOpen(false)}
        sx={{
          '& .MuiDrawer-paper': {
            width: { xs: '85%', sm: 400 },
            background: isDark 
              ? 'linear-gradient(135deg, rgba(26, 31, 53, 0.98) 0%, rgba(40, 167, 69, 0.15) 100%)'
              : 'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
            backdropFilter: 'blur(10px)',
            color: isDark ? 'white' : 'inherit'
          }
        }}
      >
        <Box sx={{ p: 3 }}>
          {/* Header */}
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
            <Typography variant="h5" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745' }}>
              About Us
            </Typography>
            <IconButton onClick={() => setAboutDrawerOpen(false)} sx={{ color: isDark ? 'rgba(255,255,255,0.8)' : 'rgba(0,0,0,0.6)' }}>
              <Close />
            </IconButton>
          </Box>
          
          <Divider sx={{ mb: 3, borderColor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(40, 167, 69, 0.2)' }} />
          
          {/* Project Info */}
          <Box sx={{ mb: 4 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', mb: 2 }}>
              🌾 Project Overview
            </Typography>
            <Typography variant="body1" sx={{ color: isDark ? 'rgba(255,255,255,0.95)' : 'rgba(0,0,0,0.87)', lineHeight: 1.8, mb: 2 }}>
              <strong>Agro Smart Technology (AST)</strong> is a comprehensive AI-powered agricultural assistance platform designed to empower Pakistani farmers with modern technology.
            </Typography>
            <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.90)' : 'rgba(0,0,0,0.75)', lineHeight: 1.7, mb: 1 }}>
              Our mission is to bridge the gap between traditional farming and modern agricultural practices through accessible, voice-enabled technology in Urdu.
            </Typography>
          </Box>
          
          <Divider sx={{ mb: 3, borderColor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(40, 167, 69, 0.2)' }} />
          
          {/* Purpose */}
          <Box sx={{ mb: 4 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', mb: 2 }}>
              🎯 Purpose & Features
            </Typography>
            <Box component="ul" sx={{ pl: 2, color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)', '& li': { mb: 1, lineHeight: 1.7 }, '& strong': { color: isDark ? '#4ade80' : '#28a745' } }}>
              <li><strong>Voice Q&A in Urdu:</strong> Ask farming questions and get instant answers</li>
              <li><strong>AI Disease Detection:</strong> Identify crop diseases through photos</li>
              <li><strong>Real-Time Mandi Rates:</strong> Live market prices from major cities</li>
              <li><strong>Weather Forecasts:</strong> Accurate predictions for farming decisions</li>
              <li><strong>Digital Marketplace:</strong> Direct buyer-seller connections</li>
            </Box>
          </Box>
          
          <Divider sx={{ mb: 3, borderColor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(40, 167, 69, 0.2)' }} />
          
          {/* Developers */}
          <Box sx={{ mb: 4 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', mb: 2 }}>
              👨‍💻 Development Team
            </Typography>
            <Box sx={{ bgcolor: isDark ? 'rgba(74, 222, 128, 0.1)' : 'rgba(40, 167, 69, 0.05)', p: 2, borderRadius: 2, boxShadow: 1, mb: 2, border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)' }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745' }}>
                Syed Shah Hussain (S2024387008)
              </Typography>
              <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.70)', mb: 0.5 }}>
                Lead Developer & Project Manager
              </Typography>
              <Typography variant="caption" sx={{ color: isDark ? 'rgba(255,255,255,0.75)' : 'rgba(0,0,0,0.60)' }}>
                Full-stack Development (React.js, Flutter), Firebase Integration, UI/UX Design, Voice Interface Implementation, System Architecture, Project Coordination
              </Typography>
            </Box>
            <Box sx={{ bgcolor: isDark ? 'rgba(74, 222, 128, 0.1)' : 'rgba(40, 167, 69, 0.05)', p: 2, borderRadius: 2, boxShadow: 1, border: isDark ? '1px solid rgba(74, 222, 128, 0.2)' : '1px solid rgba(40, 167, 69, 0.1)' }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745' }}>
                Malik Abdul Rehman (S2024387002)
              </Typography>
              <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.70)', mb: 0.5 }}>
                AI/ML Engineer & Backend Developer
              </Typography>
              <Typography variant="caption" sx={{ color: isDark ? 'rgba(255,255,255,0.75)' : 'rgba(0,0,0,0.60)' }}>
                Machine Learning Models (TensorFlow Lite), Disease Detection Module, Node.js Backend, API Integration, Natural Language Processing, Speech Recognition Implementation
              </Typography>
            </Box>
          </Box>
          
          <Divider sx={{ mb: 3, borderColor: isDark ? 'rgba(74, 222, 128, 0.2)' : 'rgba(40, 167, 69, 0.2)' }} />
          
          {/* Final Year Project */}
          <Box>
            <Typography variant="h6" sx={{ fontWeight: 'bold', color: isDark ? '#4ade80' : '#28a745', mb: 2 }}>
              🎓 Final Year Project
            </Typography>
            <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.92)' : 'rgba(0,0,0,0.87)', lineHeight: 1.7, mb: 1 }}>
              This project represents our Final Year Project (FYP) at <strong>The College of Art, Science & Technology, University of Management & Technology (UMT), Lahore</strong>.
            </Typography>
            <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.88)' : 'rgba(0,0,0,0.75)', lineHeight: 1.7, mb: 2 }}>
              <strong>Academic Year:</strong> 2024-2025<br />
              <strong>Project Supervisor:</strong> Miss Saima Safdar (Lecturer, UMT)<br />
              <strong>Students:</strong> Syed Shah Hussain (S2024387008) & Malik Abdul Rehman (S2024387002)<br />
              <strong>Technology Stack:</strong> React.js, Flutter, Node.js, Firebase, OpenAI GPT-4, Google Gemini AI, TensorFlow Lite<br />
              <strong>Platform:</strong> Web Application + Android Mobile App
            </Typography>
            <Typography variant="body2" sx={{ color: '#666', fontStyle: 'italic', mb: 2 }}>
              "Empowering farmers through technology, one field at a time."
            </Typography>
            <Typography variant="subtitle2" sx={{ fontWeight: 'bold', color: '#28a745', mb: 1 }}>
              Project Objectives:
            </Typography>
            <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(0,0,0,0.70)', lineHeight: 1.7, mb: 1 }}>
              • Provide voice-based guidance on pest identification, IPM, and safe pesticide use<br />
              • Deliver real-time weather forecasts, market prices, and government scheme information in Urdu<br />
              • Enable crop disease detection through voice-described symptoms or photo upload<br />
              • Create a digital marketplace for direct farmer-buyer connection using voice commands<br />
              • Ensure offline functionality for core features to support low-literacy users
            </Typography>
            <Typography variant="body2" sx={{ color: isDark ? 'rgba(255,255,255,0.88)' : 'rgba(0,0,0,0.75)', lineHeight: 1.7 }}>
              <strong>Mission:</strong> AST bridges the digital and knowledge divide for Pakistani smallholder farmers by providing accessible, AI-powered, voice-enabled agricultural assistance in Urdu, reducing pesticide misuse, increasing crop yields, and improving farmers' income through modern farming techniques and direct market access.
            </Typography>
          </Box>
          
          {/* Footer */}
          <Box sx={{ mt: 4, pt: 3, borderTop: isDark ? '2px solid rgba(74, 222, 128, 0.3)' : '2px solid #28a745', textAlign: 'center' }}>
            <Typography variant="caption" sx={{ color: isDark ? 'rgba(255,255,255,0.70)' : 'rgba(0,0,0,0.60)' }}>
              © 2025 Agro Smart Technology. All rights reserved.
            </Typography>
          </Box>
        </Box>
      </Drawer>
      
      {/* Mobile Menu Drawer */}
      <Drawer
        anchor="left"
        open={mobileMenuOpen}
        onClose={() => setMobileMenuOpen(false)}
        sx={{
          display: { xs: 'block', md: 'none' },
          '& .MuiDrawer-paper': {
            width: '70%',
            maxWidth: 280,
            background: isDark 
              ? 'linear-gradient(135deg, rgba(26, 31, 53, 0.98) 0%, rgba(40, 167, 69, 0.85) 100%)'
              : 'linear-gradient(135deg, #28a745 0%, #20a745 100%)',
            backdropFilter: 'blur(10px)'
          }
        }}
      >
        <Box sx={{ p: 2 }}>
          {/* Mobile Menu Header */}
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', color: 'white' }}>
              Menu
            </Typography>
            <IconButton onClick={() => setMobileMenuOpen(false)} sx={{ color: 'white' }}>
              <Close />
            </IconButton>
          </Box>
          
          <Divider sx={{ borderColor: 'rgba(255,255,255,0.2)', mb: 2 }} />
          
          {/* Mobile Menu Items */}
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
            {[
              { label: 'Home', icon: <HomeIcon />, section: 'home' },
              { label: 'Features', icon: <Agriculture />, section: 'features' },
              { label: 'Gallery', icon: <Shop />, section: 'gallery' },
              { label: 'Download', icon: <Download />, section: 'download' },
              { label: 'Contact', icon: <Email />, section: 'contact' }
            ].map((item) => (
              <Button
                key={item.section}
                onClick={() => {
                  scrollToSection(item.section);
                  setMobileMenuOpen(false);
                }}
                startIcon={item.icon}
                sx={{
                  color: 'white',
                  justifyContent: 'flex-start',
                  px: 2,
                  py: 1.5,
                  fontWeight: 500,
                  fontSize: '1rem',
                  bgcolor: 'rgba(255,255,255,0.1)',
                  borderRadius: 2,
                  '&:hover': {
                    bgcolor: 'rgba(255,255,255,0.2)',
                    transform: 'translateX(5px)'
                  },
                  transition: 'all 0.3s ease'
                }}
              >
                {item.label}
              </Button>
            ))}
            
            <Divider sx={{ borderColor: 'rgba(255,255,255,0.2)', my: 1 }} />
            
            <Button
              onClick={() => {
                setMobileMenuOpen(false);
                setAboutDrawerOpen(true);
              }}
              startIcon={<Info />}
              sx={{
                color: 'white',
                justifyContent: 'flex-start',
                px: 2,
                py: 1.5,
                fontWeight: 500,
                fontSize: '1rem',
                bgcolor: 'rgba(255,255,255,0.15)',
                borderRadius: 2,
                '&:hover': {
                  bgcolor: 'rgba(255,255,255,0.25)',
                  transform: 'translateX(5px)'
                },
                transition: 'all 0.3s ease'
              }}
            >
              About Us
            </Button>
          </Box>
        </Box>
      </Drawer>
    </>
  );
}

// Main App with Routing
function App() {
  const [isDark, setIsDark] = useState(false);

  const toggleTheme = () => {
    setIsDark(!isDark);
    localStorage.setItem('theme', !isDark ? 'dark' : 'light');
  };

  // Load theme from localStorage on mount
  React.useEffect(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
      setIsDark(true);
    }
  }, []);

  // Create dynamic theme
  const theme = createTheme({
    palette: {
      mode: isDark ? 'dark' : 'light',
      primary: {
        main: '#28a745',
        light: '#4ade80',
        dark: '#20a745',
      },
      secondary: {
        main: '#20c997',
      },
      background: {
        default: isDark ? 'rgba(10, 14, 26, 0.92)' : 'rgba(232, 245, 233, 0.75)',
        paper: isDark ? 'rgba(26, 31, 53, 0.9)' : 'rgba(255, 255, 255, 0.75)',
      },
      text: {
        primary: isDark ? '#ffffff' : '#1b5e20',
        secondary: isDark ? 'rgba(255,255,255,0.85)' : 'rgba(27, 94, 32, 0.8)',
      },
    },
    typography: {
      fontFamily: '"Inter", "Noto Nastaliq Urdu", sans-serif',
    },
    components: {
      MuiPaper: {
        styleOverrides: {
          root: {
            backgroundImage: 'none',
            backdropFilter: 'blur(10px)',
            border: '1px solid',
            borderColor: 'rgba(255, 255, 255, 0.1)',
          },
        },
      },
      MuiCard: {
        styleOverrides: {
          root: {
            backgroundImage: 'none',
            backdropFilter: 'blur(10px)',
            transition: 'all 0.3s ease',
            border: '1px solid',
            borderColor: isDark ? 'rgba(255, 255, 255, 0.15)' : 'rgba(27, 94, 32, 0.2)',
          },
        },
      },
    },
  });

  return (
    <ThemeContext.Provider value={{ isDark, toggleTheme }}>
      <ThemeProvider theme={theme}>
        <Box sx={{ 
          minHeight: '100vh',
          background: isDark 
            ? 'linear-gradient(135deg, rgba(10, 14, 26, 0.92) 0%, rgba(26, 31, 53, 0.88) 50%, rgba(40, 167, 69, 0.2) 100%), url(https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=1600&q=80) center/cover fixed'
            : 'linear-gradient(135deg, rgba(232, 245, 233, 0.75) 0%, rgba(200, 230, 201, 0.70) 50%, rgba(165, 214, 167, 0.65) 100%), url(https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=1600&q=80) center/cover fixed',
          transition: 'all 0.5s ease',
          position: 'relative'
        }}>
          <Router>
            {/* Permanent Header on all pages */}
            <PermanentHeader />
            
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/voice-qa" element={<VoiceQA />} />
        <Route path="/disease-detection" element={<DiseaseDetection />} />
        <Route path="/weather" element={<Weather />} />
        <Route path="/mandi-rates" element={<MandiRates />} />
        <Route path="/market-analysis" element={<MarketAnalysis />} />
        <Route path="/marketplace" element={<Marketplace />} />
      </Routes>
          </Router>
        </Box>
      </ThemeProvider>
    </ThemeContext.Provider>
  );
}

export default App;
