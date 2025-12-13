import React, { useState, useEffect } from 'react';
import { Box, Container, Typography, Grid, Card, CardMedia, IconButton, Fade, Slide, Zoom } from '@mui/material';
import { ChevronLeft, ChevronRight, Close } from '@mui/icons-material';

const farmerStories = [
  {
    id: 1,
    image: '/images/Real pakistani farmers using AST/image (1).jpg',
    title: 'The Laptop Duo – Brothers United in the Fields',
    titleUrdu: 'لیپ ٹاپ جوڑی – کھیتوں میں متحد بھائی',
    storyEnglish: `In the vast, golden wheat fields of rural Punjab, where the sun beats down mercilessly and the soil tells tales of generations of toil, lived two brothers, Ali and Asif. Ali, the elder at 45, with calloused hands and a furrowed brow from years of worry, had always been the backbone of their small family farm. Asif, 38, his younger sibling, shared the same weathered face, marked by the relentless struggle against nature's whims. Their 5-acre plot was their lifeblood, but it had become a source of endless despair. Pests like armyworms and aphids descended like silent invaders, devouring half their crops season after season.

One fateful afternoon, as they sat exhausted under a lone tree, laptop borrowed from a neighbor's son who studied in Lahore, a fellow farmer mentioned Agro Smart Technology (AST). Skeptical but desperate, they opened the website on the old device. Speaking into the microphone in their native Urdu, Ali hesitantly asked, "Kheti mein keere ka ilaj kya hai?" The calm, reassuring voice responded instantly, guiding them through Integrated Pest Management (IPM) techniques—natural remedies like neem oil sprays and biological controls, without the need for harmful over-dosing.

That season, their yield increased by 50%, turning a potential loss into a bountiful harvest. Incomes doubled, debts were cleared, and they even afforded new seeds for the next cycle. As they sat together again, this time with smiles and full bellies, Ali turned to Asif, tears glistening in his eyes. "Bhai, ye AST nahi, hamara naya bhai hai," he said, hugging his brother tightly.`,
    storyUrdu: `پنجاب کے دیہی علاقوں کے وسیع و عریض سنہری گندم کے کھیتوں میں، جہاں دھوپ بے رحمی سے برس رہی ہوتی ہے اور مٹی نسلوں کی محنت کی داستانیں سناتی ہے، وہاں دو بھائی علی اور آصف رہتے تھے۔ بڑے بھائی علی، ۴۵ سال کے، ہاتھوں پر گٹے اور پیشانی پر فکر کی لکیروں والے، ہمیشہ اپنے چھوٹے سے خاندانی فارم کی ریڑھ کی ہڈی رہے۔ چھوٹا بھائی آصف، ۳۸ سال کا، وہی تھکا ہوا چہرہ، فطرت کے موڑوں سے لڑتے ہوئے۔

ایک قسمت بدل دینے والے دوپہر، جب وہ تنہا درخت کے نیچے تھک کر بیٹھے تھے، ایک ساتھی کسان نے Agro Smart Technology (AST) کا نام لیا۔ شک کی نگاہ سے بھرے مگر مجبور، انہوں نے پرانے لیپ ٹاپ پر ویب سائٹ کھولی۔ مائیک میں اپنی مادری اردو میں علی نے ہچکچاتے ہوئے پوچھا، "کھیتی میں کیڑے کا علاج کیا ہے؟" پرسکون، تسلی دینے والی آواز نے فوراً جواب دیا۔

اس سیزن میں پیداوار ۵۰٪ بڑھی، نقصان کی جگہ خوبصورت فصل۔ آمدنی دگنی، قرضے ختم، اگلے سائیکل کے لیے نئے بیج بھی آ گئے۔ جب دوبارہ بیٹھے تو مسکراتوں اور پیٹ بھرے، علی نے آنکھوں میں آنسو بھرے آصف کو گلے لگایا: "بھائی، یہ AST نہیں، ہمارا نیا بھائی ہے۔"`
  },
  {
    id: 2,
    image: '/images/Real pakistani farmers using AST/image (2).jpg',
    title: 'Hoe and Hope – Karim\'s Battle with the Elements',
    titleUrdu: 'کدال اور امید – کریم کی عناصر سے لڑائی',
    storyEnglish: `Karim, a sturdy 50-year-old farmer from the rice paddies of Sindh, had spent his life wielding a hoe like a warrior's sword, carving furrows into the earth that fed his family for decades. But the land, once generous, had turned treacherous. Erratic weather patterns—droughts followed by flash floods—ruined his rice crops year after year, leaving fields barren and his heart heavy.

Then, one scorching day while resting with his hoe slung over his shoulder, a traveling extension officer demonstrated the AST app on his smartphone. Intrigued, Karim downloaded it, his fingers fumbling but guided by the voice interface. "Barish kab aayegi? Chawal ki bimari ka ilaj batao," he spoke into the phone, his voice thick with doubt. The app's Urdu voice responded warmly, providing precise weather forecasts from integrated APIs, warning of dry spells and suggesting irrigation tips.

That harvest, his crops thrived, yields tripling as he avoided losses from weather and pests. Profits surged, allowing him to repurchase lost land and send his son back to school. Standing tall in his field, hoe in hand, Karim gazed at his phone with gratitude, a rare smile breaking through. "AST ne meri umeed wapas la di," he murmured, his voice steady with triumph.`,
    storyUrdu: `سندھ کے چاول کے کھیتوں میں کدال کو تلوار کی طرح استعمال کرنے والا مضبوط ۵۰ سالہ کریم اپنی زندگی بھر زمین کھودتا رہا جو اس کے خاندان کو کھلاتی پلاتی تھی۔ مگر زمین جو کبھی سخی تھی اب غدار ہو گئی۔ غیر یقینی موسم—سوکھا پھر طغیانی—سال بہ سال چاول برباد۔

ایک جھلسا دینے والے دن جب کدال کندھے پر ڈالے آرام کر رہا تھا، ایک گھومنے والا ایکسٹینشن افسر نے AST ایپ دکھائی۔ دلچسپی ہوئی، کریم نے ڈاؤن لوڈ کی، انگلیاں لڑھکتیں مگر آواز انٹرفیس نے رہنمائی کی۔ "بارش کب آئے گی؟ چاول کی بیماری کا علاج بتاؤ" اس نے شک بھری آواز میں کہا۔ اردو آواز نے گرمجوشی سے جواب دیا۔

اس فصل میں کاشت لہلہائی، پیداوار تین گنا، نقصانات سے بچت۔ منافع بڑھے، کھوئی زمین واپس خریدی، بیٹا اسکول واپس۔ کھیت میں سیدھا کھڑا کریم فون کو دیکھ مسکرایا: "AST نے میری امید واپس لا دی۔"`
  },
  {
    id: 3,
    image: '/images/Real pakistani farmers using AST/image (3).jpg',
    title: 'Field Focus – Tariq\'s Journey from Isolation to Respect',
    titleUrdu: 'کھیت کا فوکس – تنہائی سے عزت تک طارق کا سفر',
    storyEnglish: `Tariq, a veteran grower in his late 50s from the fertile plains near Lahore, had always been a solitary figure in his vast fields, his mustache graying with the passage of time and hardship. Isolation defined his life—no nearby neighbors to share knowledge, and his low education level left him cut off from modern farming insights. Wrong fertilizers, applied blindly, leached into the soil, killing its fertility and yielding stunted crops of cotton and maize.

A turning point came when a community workshop introduced him to the AST website. Logging in on a borrowed tablet, Tariq spoke tentatively in Urdu: "Zameen kharab ho gayi, khad kaun si dalun?" The voice-assisted platform sprang to life, delivering tailored advice on soil restoration, recommending precise fertilizer mixes based on crop types and weather data.

As Tariq implemented the changes, his fields revived, crops lush and abundant, boosting earnings enough to afford medical checkups and family visits. Health improved, and the village now sought his advice, dubbing him "Ustad Tariq." With tears of pride, he reflected on his phone: "AST ne mujhe tanha se maqbool bana diya." No longer isolated, Tariq stood focused in his field, a man reclaimed by innovation and community respect.`,
    storyUrdu: `لاہور کے قریب زرخیز میدانوں میں ۵۰ کے آخر میں طارق، سرمئی مونچھوں والا تنہا کسان۔ تنہائی اس کی زندگی تھی—قریب کوئی پڑوسی نہ، کم تعلیم کی وجہ سے جدید زرعی علم سے کٹا ہوا۔ غلط کھادیں اندھا دھند ڈالیں، مٹی کی زرخیزی ختم۔

ایک کمیونٹی ورکشاپ میں AST ویب سائٹ متعارف کروائی گئی۔ ادھار ٹیبلٹ پر لاگ ان کیا، اردو میں بولا: "زمین خراب ہو گئی، کون سی کھاد ڈالوں؟" آواز مددگار پلیٹ فارم نے فوراً مٹی بحالی کے حسب ضرورت مشورے دیے۔

کھیت زندہ ہوئے، فصل خوبصورت، آمدنی بڑھی، ڈاکٹر اور خاندانی دورے ممکن۔ صحت بہتر، گاؤں والے مشورے مانگتے، "استاد طارق" کہتے۔ فخر کے آنسوؤں سے فون کو دیکھا: "AST نے مجھے تنہا سے مقبول بنا دیا۔"`
  },
  {
    id: 4,
    image: '/images/Real pakistani farmers using AST/image (4).jpg',
    title: 'App in Hand – The Season That Was Supposed to Be Habib\'s Last',
    titleUrdu: 'ہاتھ میں ایپ – وہ سیزن جو حبیب کا آخری ہونا تھا',
    storyEnglish: `Habib was 70, living in a cracked mud house on the edge of a Balochistan village where even the wind felt tired. Fifteen years had passed since his wife died, and now he was raising three grandchildren whose parents had been taken by a truck on the highway. Two acres of land, tomatoes, okra, chilies, that was all he had left of his life. But the land had stopped listening to him.

One afternoon, when the sky was the color of rusted iron, a young neighbor named Javed came with an old smartphone and said, "Baba, just talk to it. It speaks Urdu like us." Habib laughed until he coughed, then held the phone like it might bite him. Finally, in a voice cracked from dust and shame, he spoke: "Mere tamatar mar gaye… keede kha gaye… bachchon ke liye kuch bacha do, warna hum sab mar jayenge."

The phone answered with a calm, kind voice, speaking the same rough Balochi-accented Urdu Habib used. It told him to stop the poison, to boil neem leaves with garlic and soap water, to spray only in the evening. That season the vines were so heavy with fruit that his granddaughter Amina ran between the rows stuffing tomatoes into her shalwar like red balloons, laughing. The house filled with smells of cooking Habib hadn't afforded in years.

Now every evening Habib sits on the charpai, phone resting on his chest like a second heart. He kisses the screen and whispers: "Beta, tune meri maut ko zindagi mein badal diya. Ab main marunga tab bhi hans ke marunga."`,
    storyUrdu: `حبیب ۷۰ سالہ، بلوچستان کے گاؤں کے کنارے ٹوٹی مٹی کی جھونپڑی میں، ہوا بھی تھکی لگتی تھی۔ بیوی گئی ۱۵ سال ہوئے، اب تین پوتے پال رہا تھا جن کے ماں باپ ہائی وے کے ٹرک تلے چلے گئے۔

ایک دوپہر جب آسمان زنگ آلود لوہے جیسا تھا، پڑوسی جاوید پرانا سمارٹ فون لایا اور بولا، "بابا، بس اس سے بات کرو۔ یہ ہماری طرح اردو بولتا ہے۔" ٹوٹی پھوٹی آواز میں بولا: "میرے ٹماٹر مر گئے… کیڑے کھا گئے… بچوں کے لیے کچھ بچا دو، ورنہ ہم سب مر جائیں گے۔"

فون نے جواب دیا۔ پرسکون، مہربان مرد کی آواز۔ اس سیزن انگور جیسے ٹماٹر، آمنہ شلوار میں ٹماٹر بھر کر ہنستی دوڑتی۔

اب ہر شام چارپائی پر بیٹھتا، فون سینے پر رکھ کر سکرین چومتا: "بیٹا، تُو نے میری موت کو زندگی میں بدل دیا۔ اب میں مروں گا تب بھی ہنس کے مروں گا۔"`
  },
  {
    id: 5,
    image: '/images/Real pakistani farmers using AST/image (5).jpg',
    title: 'Cornfield Victory – The Year Saad\'s Corn Grew Taller Than His Fear',
    titleUrdu: 'مکئی کے کھیت کی فتح – وہ سال جب سعد کی مکئی اس کے ڈر سے اونچی ہو گئی',
    storyEnglish: `Saad, 55, Mardan district. Once the strongest man in the mohalla, now the quietest. Three straight years his corn had betrayed him. Fall armyworm, stem borers, whatever new devil arrived, nothing worked anymore. The old chemicals only made the insects laugh. The bank manager started visiting like a relative nobody wanted.

One night his cousin shoved a tablet into his hand and said, "Shout at it if you want, just try." Saad shouted, voice raw with rage: "Makki ke keede maar do! Teen saal se kha rahe hain ghar barbaad kar diya!"

The AST voice didn't flinch. It named the exact pest from his description, told him the chemicals he was using had created super-insects, ordered him to burn the residue, switch to a new bio-pesticide available at the government store for free. Harvest time the stalks stood taller than Saad, cobs thick as his forearm, kernels shining like gold.

That night his wife Naseem lit every lamp in the house, cooked chicken, wore the gold earrings Saad bought her for the first time in twenty years. Saad stood in the middle of his green ocean, arms raised to the sky, laughing and crying: "AST ne meri haar ko itni badi jeet bana diya ke ab makki nahi, khushi ug rahi hai zameen se."`,
    storyUrdu: `سعد، ۵۵، مردان۔ محلے کا سب سے طاقتور آدمی اب سب سے خاموش۔ تین سال مسلسل مکئی نے دھوکہ دیا۔

ایک رات کزن نے ٹیبلٹ تھماتے ہوئے بولا، "چلاؤ بھی اگر دل کرے، بس کوشش کرو۔" سعد چلایا: "مکئی کے کیڑے مار دو! تین سال سے کھا رہے ہیں گھر برباد کر دیا!"

AST کی آواز نہ ڈری۔ فصل کے وقت تنے سعد سے اونچے، بھٹے بازو جتنے موٹے، دانے سونے جیسے۔

رات کو نسیم نے سارے دیے جلا دیے، مرغی پکائی، بیس سال بعد سونے کے جھمکے پہنے۔ سعد سبز سمندر میں بازو اٹھا کر ہنستا روتا رہا: "AST نے میری ہار کو اتنی بڑی جیت بنا دیا کہ اب مکئی نہیں، خوشی اگ رہی ہے زمین سے۔"`
  },
  {
    id: 6,
    image: '/images/Real pakistani farmers using AST/image (6).jpg',
    title: 'Sunset Resolve – The Evening Rehman Stopped Hating Sunsets',
    titleUrdu: 'غروبِ آفتاب کا عزم – وہ شام جب رحمان نے غروبِ آفتاب سے نفرت چھوڑ دی',
    storyEnglish: `Rehman, 48, Bahawalpur. Red pagri, cracked hands, millet fields that once fed three generations now feeding only sorrow. Children in the same torn uniforms for two years, wife counting every grain of rice before cooking. Every sunset felt like the sky was closing a coffin lid on another failed day.

One blood-orange evening he sat on the field boundary, phone in hand for the first time, and spoke to the darkening sky: "Jawaar bacha lo. Barish kab? Rate kya? Bata do warna bachche bhookhe mar jayenge."

The AST voice came like mercy: three-day forecast, exact irrigation schedule, soil moisture tips, and the real Karachi mandi rate double what the village arhti had offered for years. When the golden heads finally stood proud and safe, he opened the marketplace and said simply: "Mera jawar bechna hai. Seedhi deal, beech mein koi nahi."

A flour mill owner called within minutes, sent a truck the next day, paid full amount in cash. The money bought a new tin roof that didn't leak, new school bags, meat three times a week, and bangles for his wife that jingled when she laughed.

Now every evening Rehman stands at the exact same spot, red pagri glowing against the same sunset. But his back is straight, eyes shining. He lifts the phone toward the horizon and says: "Tune andhera hata diya, AST. Ab har shaam Eid ki shaam hai."`,
    storyUrdu: `رحمان، ۴۸، بہاولپور۔ سرخ پگڑی، ہاتھ پھٹے، جواری کے کھیت تین نسلوں کو کھلاتے اب صرف غم۔ ہر غروبِ آفتاب لگتا تابوت بند ہو رہا ہے۔

ایک خون جیسا نارنجی غروبِ آفتاب، کھیت کی مینڈھ پر بیٹھا پہلی بار فون ہاتھ میں لیا: "جواری بچا لو۔ بارش کب؟ ریٹ کیا؟ بتا دو ورنہ بچے بھوکے مر جائیں گے۔"

AST کی آواز رحمت بن کر آئی۔ جب سنہری بالیں فخر سے کھڑی ہوئیں، بس اتنا بولا: "میرا جواری بیچنا ہے۔ سیدھی ڈیل، بیچ میں کوئی نہیں۔"

منٹوں میں آٹا مل مالک نے فون کیا، پورے پیسے نقد دیے۔ نیا ٹین کا چھت، نئے اسکول بیگ، بیوی کے لیے چوڑیاں۔

اب ہر شام وہی جگہ، کمر سیدھی، آنکھیں چمکتیں۔ فون افق کی طرف اٹھا کر: "تُو نے اندھیرا ہٹا دیا AST۔ اب ہر شام عید کی شام ہے۔"`
  }
];

const FarmerStories = () => {
  const [selectedStory, setSelectedStory] = useState(null);
  const [hoveredCard, setHoveredCard] = useState(null);

  useEffect(() => {
    // Load Urdu font
    const style = document.createElement('style');
    style.innerHTML = `
      @font-face {
        font-family: 'Noto Nastaliq Urdu';
        src: url('/fonts/NotoNastaliqUrdu-Regular.ttf') format('truetype');
        font-weight: normal;
        font-style: normal;
      }
      @font-face {
        font-family: 'Noto Nastaliq Urdu';
        src: url('/fonts/NotoNastaliqUrdu-Bold.ttf') format('truetype');
        font-weight: bold;
        font-style: normal;
      }
    `;
    document.head.appendChild(style);

    return () => {
      document.head.removeChild(style);
    };
  }, []);

  const handleNextStory = () => {
    if (selectedStory) {
      const currentIndex = farmerStories.findIndex(s => s.id === selectedStory.id);
      const nextIndex = (currentIndex + 1) % farmerStories.length;
      setSelectedStory(farmerStories[nextIndex]);
    }
  };

  const handlePrevStory = () => {
    if (selectedStory) {
      const currentIndex = farmerStories.findIndex(s => s.id === selectedStory.id);
      const prevIndex = (currentIndex - 1 + farmerStories.length) % farmerStories.length;
      setSelectedStory(farmerStories[prevIndex]);
    }
  };

  return (
    <>
      {/* Stories Grid Section */}
      <Box 
        id="farmer-stories" 
        sx={{ 
          py: 12, 
          background: 'linear-gradient(180deg, #0a1929 0%, #1a2332 50%, #0a1929 100%)',
          position: 'relative',
          overflow: 'hidden',
          '&::before': {
            content: '""',
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            background: 'radial-gradient(circle at 20% 50%, rgba(40,167,69,0.1) 0%, transparent 50%), radial-gradient(circle at 80% 50%, rgba(40,167,69,0.08) 0%, transparent 50%)',
            pointerEvents: 'none'
          }
        }}
      >
        <Container maxWidth="xl">
          {/* Section Header */}
          <Fade in timeout={1000}>
            <Box sx={{ textAlign: 'center', mb: 8 }}>
              <Typography 
                variant="h2" 
                sx={{ 
                  fontWeight: 900, 
                  mb: 2,
                  background: 'linear-gradient(135deg, #28a745 0%, #20c997 50%, #17a2b8 100%)',
                  backgroundClip: 'text',
                  WebkitBackgroundClip: 'text',
                  WebkitTextFillColor: 'transparent',
                  textShadow: '0 0 40px rgba(40,167,69,0.3)',
                  letterSpacing: '-1px'
                }}
              >
                Success Stories
              </Typography>
              <Typography 
                variant="h3" 
                sx={{ 
                  fontFamily: 'Noto Nastaliq Urdu, serif',
                  color: '#fff',
                  mb: 2,
                  fontWeight: 700,
                  textShadow: '0 4px 20px rgba(0,0,0,0.5)'
                }}
              >
                حقیقی کامیابی کی داستانیں
              </Typography>
              <Typography 
                variant="h6" 
                sx={{ 
                  color: 'rgba(255,255,255,0.7)',
                  maxWidth: 800,
                  mx: 'auto',
                  lineHeight: 1.8
                }}
              >
                Real Pakistani farmers whose lives were transformed by Agro Smart Technology. 
                Click any story to experience their journey.
              </Typography>
            </Box>
          </Fade>

          {/* Stories Grid */}
          <Grid container spacing={4}>
            {farmerStories.map((story, index) => (
              <Grid item xs={12} sm={6} md={4} key={story.id}>
                <Zoom in timeout={300 + index * 100}>
                  <Card
                    onMouseEnter={() => setHoveredCard(story.id)}
                    onMouseLeave={() => setHoveredCard(null)}
                    onClick={() => setSelectedStory(story)}
                    sx={{
                      position: 'relative',
                      height: 500,
                      cursor: 'pointer',
                      borderRadius: 4,
                      overflow: 'hidden',
                      transition: 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)',
                      transform: hoveredCard === story.id ? 'translateY(-15px) scale(1.02)' : 'translateY(0) scale(1)',
                      boxShadow: hoveredCard === story.id 
                        ? '0 25px 60px rgba(40,167,69,0.4), 0 0 0 1px rgba(40,167,69,0.3)'
                        : '0 8px 30px rgba(0,0,0,0.3)',
                      '&::before': {
                        content: '""',
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        background: hoveredCard === story.id 
                          ? 'linear-gradient(180deg, transparent 0%, rgba(40,167,69,0.2) 40%, rgba(0,0,0,0.95) 100%)'
                          : 'linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.4) 40%, rgba(0,0,0,0.9) 100%)',
                        transition: 'background 0.5s ease',
                        zIndex: 1
                      }
                    }}
                  >
                    {/* Background Image */}
                    <CardMedia
                      component="img"
                      image={story.image}
                      alt={story.title}
                      sx={{
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        width: '100%',
                        height: '100%',
                        objectFit: 'cover',
                        transition: 'transform 0.7s cubic-bezier(0.4, 0, 0.2, 1)',
                        transform: hoveredCard === story.id ? 'scale(1.15)' : 'scale(1)'
                      }}
                    />

                    {/* Story Number Badge */}
                    <Box
                      sx={{
                        position: 'absolute',
                        top: 20,
                        right: 20,
                        width: 60,
                        height: 60,
                        borderRadius: '50%',
                        background: 'linear-gradient(135deg, #28a745 0%, #20c997 100%)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        zIndex: 2,
                        boxShadow: '0 8px 25px rgba(40,167,69,0.5)',
                        border: '3px solid rgba(255,255,255,0.3)',
                        transition: 'all 0.3s ease',
                        transform: hoveredCard === story.id ? 'scale(1.1) rotate(10deg)' : 'scale(1) rotate(0deg)'
                      }}
                    >
                      <Typography variant="h4" sx={{ fontWeight: 900, color: '#fff' }}>
                        {story.id}
                      </Typography>
                    </Box>

                    {/* Content Overlay */}
                    <Box
                      sx={{
                        position: 'absolute',
                        bottom: 0,
                        left: 0,
                        right: 0,
                        p: 4,
                        zIndex: 2,
                        transform: hoveredCard === story.id ? 'translateY(0)' : 'translateY(10px)',
                        opacity: hoveredCard === story.id ? 1 : 0.9,
                        transition: 'all 0.3s ease'
                      }}
                    >
                      <Typography 
                        variant="h5" 
                        sx={{ 
                          fontWeight: 800, 
                          color: '#fff',
                          mb: 1.5,
                          textShadow: '0 4px 15px rgba(0,0,0,0.8)',
                          lineHeight: 1.3
                        }}
                      >
                        {story.title}
                      </Typography>
                      <Typography 
                        variant="h6" 
                        sx={{ 
                          fontFamily: 'Noto Nastaliq Urdu, serif',
                          color: '#28a745',
                          fontWeight: 700,
                          mb: 2,
                          textShadow: '0 2px 10px rgba(0,0,0,0.8)',
                          lineHeight: 1.8
                        }}
                      >
                        {story.titleUrdu}
                      </Typography>
                      
                      {/* Read Story Button */}
                      <Box
                        sx={{
                          display: 'inline-flex',
                          alignItems: 'center',
                          px: 3,
                          py: 1.5,
                          borderRadius: 3,
                          background: hoveredCard === story.id 
                            ? 'linear-gradient(135deg, #28a745 0%, #20c997 100%)'
                            : 'rgba(40,167,69,0.3)',
                          backdropFilter: 'blur(10px)',
                          border: '2px solid rgba(255,255,255,0.3)',
                          transition: 'all 0.3s ease',
                          transform: hoveredCard === story.id ? 'translateX(5px)' : 'translateX(0)'
                        }}
                      >
                        <Typography 
                          sx={{ 
                            color: '#fff', 
                            fontWeight: 700,
                            fontSize: '0.95rem',
                            letterSpacing: '0.5px'
                          }}
                        >
                          {hoveredCard === story.id ? 'READ FULL STORY →' : 'Click to Read'}
                        </Typography>
                      </Box>
                    </Box>
                  </Card>
                </Zoom>
              </Grid>
            ))}
          </Grid>
        </Container>
      </Box>

      {/* Full Story Modal - GTA 6 Style */}
      {selectedStory && (
        <Fade in>
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
              background: 'rgba(0,0,0,0.95)',
              backdropFilter: 'blur(20px)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              p: { xs: 2, md: 4 },
              overflow: 'auto'
            }}
          >
            <Box
              sx={{
                position: 'relative',
                maxWidth: 1400,
                width: '100%',
                maxHeight: '90vh',
                overflow: 'auto',
                borderRadius: 4,
                background: 'linear-gradient(180deg, #0a1929 0%, #1a2332 100%)',
                boxShadow: '0 30px 90px rgba(0,0,0,0.9), 0 0 1px rgba(40,167,69,0.5)',
                border: '1px solid rgba(40,167,69,0.2)',
                '&::-webkit-scrollbar': {
                  width: '12px'
                },
                '&::-webkit-scrollbar-track': {
                  background: 'rgba(0,0,0,0.3)',
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
              {/* Hero Image Section */}
              <Box
                sx={{
                  position: 'relative',
                  height: { xs: 300, md: 500 },
                  overflow: 'hidden'
                }}
              >
                <CardMedia
                  component="img"
                  image={selectedStory.image}
                  alt={selectedStory.title}
                  sx={{
                    width: '100%',
                    height: '100%',
                    objectFit: 'cover'
                  }}
                />
                <Box
                  sx={{
                    position: 'absolute',
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    background: 'linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(10,25,41,0.95) 100%)'
                  }}
                />
                
                {/* Story Number */}
                <Box
                  sx={{
                    position: 'absolute',
                    top: 30,
                    left: 30,
                    width: 80,
                    height: 80,
                    borderRadius: '50%',
                    background: 'linear-gradient(135deg, #28a745 0%, #20c997 100%)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    boxShadow: '0 10px 40px rgba(40,167,69,0.6)',
                    border: '4px solid rgba(255,255,255,0.3)'
                  }}
                >
                  <Typography variant="h3" sx={{ fontWeight: 900, color: '#fff' }}>
                    {selectedStory.id}
                  </Typography>
                </Box>

                {/* Close Button */}
                <IconButton
                  onClick={() => setSelectedStory(null)}
                  sx={{
                    position: 'absolute',
                    top: 20,
                    right: 20,
                    background: 'rgba(0,0,0,0.7)',
                    backdropFilter: 'blur(10px)',
                    color: '#fff',
                    '&:hover': {
                      background: 'rgba(220,53,69,0.9)',
                      transform: 'scale(1.1) rotate(90deg)'
                    },
                    transition: 'all 0.3s ease',
                    border: '2px solid rgba(255,255,255,0.2)'
                  }}
                >
                  <Close sx={{ fontSize: 30 }} />
                </IconButton>

                {/* Navigation Arrows */}
                <IconButton
                  onClick={handlePrevStory}
                  sx={{
                    position: 'absolute',
                    top: '50%',
                    left: 20,
                    transform: 'translateY(-50%)',
                    background: 'rgba(0,0,0,0.7)',
                    backdropFilter: 'blur(10px)',
                    color: '#28a745',
                    '&:hover': {
                      background: 'rgba(40,167,69,0.9)',
                      color: '#fff',
                      transform: 'translateY(-50%) translateX(-5px)'
                    },
                    transition: 'all 0.3s ease',
                    border: '2px solid rgba(40,167,69,0.3)'
                  }}
                >
                  <ChevronLeft sx={{ fontSize: 40 }} />
                </IconButton>
                <IconButton
                  onClick={handleNextStory}
                  sx={{
                    position: 'absolute',
                    top: '50%',
                    right: 20,
                    transform: 'translateY(-50%)',
                    background: 'rgba(0,0,0,0.7)',
                    backdropFilter: 'blur(10px)',
                    color: '#28a745',
                    '&:hover': {
                      background: 'rgba(40,167,69,0.9)',
                      color: '#fff',
                      transform: 'translateY(-50%) translateX(5px)'
                    },
                    transition: 'all 0.3s ease',
                    border: '2px solid rgba(40,167,69,0.3)'
                  }}
                >
                  <ChevronRight sx={{ fontSize: 40 }} />
                </IconButton>

                {/* Title Overlay */}
                <Box
                  sx={{
                    position: 'absolute',
                    bottom: 0,
                    left: 0,
                    right: 0,
                    p: { xs: 3, md: 5 }
                  }}
                >
                  <Typography 
                    variant="h3" 
                    sx={{ 
                      fontWeight: 900, 
                      color: '#fff',
                      mb: 2,
                      textShadow: '0 4px 20px rgba(0,0,0,0.9)',
                      lineHeight: 1.2
                    }}
                  >
                    {selectedStory.title}
                  </Typography>
                  <Typography 
                    variant="h4" 
                    sx={{ 
                      fontFamily: 'Noto Nastaliq Urdu, serif',
                      color: '#28a745',
                      fontWeight: 700,
                      textShadow: '0 4px 20px rgba(0,0,0,0.9)',
                      lineHeight: 1.8
                    }}
                  >
                    {selectedStory.titleUrdu}
                  </Typography>
                </Box>
              </Box>

              {/* Story Content */}
              <Box sx={{ p: { xs: 3, md: 6 } }}>
                {/* English Story */}
                <Box sx={{ mb: 6 }}>
                  <Box 
                    sx={{ 
                      display: 'inline-flex',
                      px: 3,
                      py: 1,
                      borderRadius: 2,
                      background: 'linear-gradient(135deg, #28a745, #20c997)',
                      mb: 3,
                      boxShadow: '0 4px 15px rgba(40,167,69,0.3)'
                    }}
                  >
                    <Typography 
                      variant="h6" 
                      sx={{ 
                        fontWeight: 800,
                        color: '#fff',
                        letterSpacing: '1px'
                      }}
                    >
                      ENGLISH VERSION
                    </Typography>
                  </Box>
                  <Typography 
                    variant="body1" 
                    sx={{ 
                      color: 'rgba(255,255,255,0.9)',
                      lineHeight: 2,
                      fontSize: '1.1rem',
                      textAlign: 'justify',
                      whiteSpace: 'pre-line',
                      textShadow: '0 1px 2px rgba(0,0,0,0.5)'
                    }}
                  >
                    {selectedStory.storyEnglish}
                  </Typography>
                </Box>

                {/* Divider */}
                <Box
                  sx={{
                    height: 3,
                    background: 'linear-gradient(90deg, transparent, #28a745, #20c997, transparent)',
                    mb: 6,
                    borderRadius: 2
                  }}
                />

                {/* Urdu Story */}
                <Box>
                  <Box 
                    sx={{ 
                      display: 'inline-flex',
                      px: 3,
                      py: 1,
                      borderRadius: 2,
                      background: 'linear-gradient(135deg, #20c997, #17a2b8)',
                      mb: 3,
                      boxShadow: '0 4px 15px rgba(32,201,151,0.3)'
                    }}
                  >
                    <Typography 
                      variant="h6" 
                      sx={{ 
                        fontWeight: 800,
                        color: '#fff',
                        letterSpacing: '1px',
                        fontFamily: 'Noto Nastaliq Urdu, serif'
                      }}
                    >
                      اردو ترجمہ
                    </Typography>
                  </Box>
                  <Typography 
                    variant="body1" 
                    sx={{ 
                      fontFamily: 'Noto Nastaliq Urdu, serif',
                      color: 'rgba(255,255,255,0.9)',
                      lineHeight: 2.5,
                      fontSize: '1.3rem',
                      textAlign: 'right',
                      direction: 'rtl',
                      whiteSpace: 'pre-line',
                      textShadow: '0 1px 2px rgba(0,0,0,0.5)'
                    }}
                  >
                    {selectedStory.storyUrdu}
                  </Typography>
                </Box>

                {/* Story Navigation Footer */}
                <Box 
                  sx={{ 
                    mt: 6,
                    pt: 4,
                    borderTop: '2px solid rgba(40,167,69,0.2)',
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    flexWrap: 'wrap',
                    gap: 2
                  }}
                >
                  <Box
                    onClick={handlePrevStory}
                    sx={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: 1,
                      px: 3,
                      py: 1.5,
                      borderRadius: 3,
                      background: 'rgba(40,167,69,0.2)',
                      border: '2px solid rgba(40,167,69,0.3)',
                      cursor: 'pointer',
                      transition: 'all 0.3s ease',
                      '&:hover': {
                        background: 'linear-gradient(135deg, #28a745, #20c997)',
                        transform: 'translateX(-5px)',
                        boxShadow: '0 4px 20px rgba(40,167,69,0.4)'
                      }
                    }}
                  >
                    <ChevronLeft sx={{ color: '#fff' }} />
                    <Typography sx={{ color: '#fff', fontWeight: 700 }}>Previous Story</Typography>
                  </Box>

                  <Typography 
                    sx={{ 
                      color: 'rgba(255,255,255,0.6)',
                      fontWeight: 600,
                      fontSize: '0.9rem'
                    }}
                  >
                    Story {selectedStory.id} of {farmerStories.length}
                  </Typography>

                  <Box
                    onClick={handleNextStory}
                    sx={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: 1,
                      px: 3,
                      py: 1.5,
                      borderRadius: 3,
                      background: 'rgba(40,167,69,0.2)',
                      border: '2px solid rgba(40,167,69,0.3)',
                      cursor: 'pointer',
                      transition: 'all 0.3s ease',
                      '&:hover': {
                        background: 'linear-gradient(135deg, #20c997, #17a2b8)',
                        transform: 'translateX(5px)',
                        boxShadow: '0 4px 20px rgba(32,201,151,0.4)'
                      }
                    }}
                  >
                    <Typography sx={{ color: '#fff', fontWeight: 700 }}>Next Story</Typography>
                    <ChevronRight sx={{ color: '#fff' }} />
                  </Box>
                </Box>
              </Box>
            </Box>
          </Box>
        </Fade>
      )}
    </>
  );
};

export default FarmerStories;
