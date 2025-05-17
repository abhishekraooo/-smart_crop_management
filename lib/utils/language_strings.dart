abstract class LanguageStrings {
  // Common strings
  String get okButton;
  String get errorTitle;

  // Prediction Screen strings
  String get appTitle;
  String get pageTitle;
  String get nitrogen;
  String get phosphorus;
  String get potassium;
  String get temperature;
  String get humidity;
  String get ph;
  String get rainfall;
  String get predictButton;
  String get validationEmpty;
  String get validationNumber;
  String get validationRange;

  // Result Screen strings
  String get resultTitle;
  String get mainCropLabel;
  String get sideCropsLabel;
  String get probabilityUnit;
}

// English
class EnglishStrings implements LanguageStrings {
  @override
  String get okButton => "OK";
  @override
  String get errorTitle => "Error";
  @override
  String get appTitle => "Crop Prediction";
  @override
  String get pageTitle => "Provide the values and We'll recommend the crops";
  @override
  String get nitrogen => "Nitrogen (N)";
  @override
  String get phosphorus => "Phosphorus (P)";
  @override
  String get potassium => "Potassium (K)";
  @override
  String get temperature => "Temperature";
  @override
  String get humidity => "Humidity";
  @override
  String get ph => "pH";
  @override
  String get rainfall => "Rainfall";
  @override
  String get predictButton => "Predict Crop";
  @override
  String get validationEmpty => "Please enter a value for";
  @override
  String get validationNumber => "must be a number";
  @override
  String get validationRange => "must be between";
  @override
  String get resultTitle => "Crop Prediction Results";
  @override
  String get mainCropLabel => "Main Crop";
  @override
  String get sideCropsLabel => "Suggested Side Crops";
  @override
  String get probabilityUnit => "%";
}

// Hindi
class HindiStrings implements LanguageStrings {
  @override
  String get okButton => "ठीक है";
  @override
  String get errorTitle => "त्रुटि";
  @override
  String get appTitle => "फसल भविष्यवाणी";
  @override
  String get pageTitle => "मान दर्ज करें और हम फसलों की सिफारिश करेंगे";
  @override
  String get nitrogen => "नाइट्रोजन (N)";
  @override
  String get phosphorus => "फॉस्फोरस (P)";
  @override
  String get potassium => "पोटेशियम (K)";
  @override
  String get temperature => "तापमान";
  @override
  String get humidity => "नमी";
  @override
  String get ph => "पीएच";
  @override
  String get rainfall => "वर्षा";
  @override
  String get predictButton => "फसल भविष्यवाणी करें";
  @override
  String get validationEmpty => "कृपया इसके लिए एक मान दर्ज करें";
  @override
  String get validationNumber => "एक संख्या होनी चाहिए";
  @override
  String get validationRange => "के बीच होना चाहिए";
  @override
  String get resultTitle => "फसल भविष्यवाणी परिणाम";
  @override
  String get mainCropLabel => "मुख्य फसल";
  @override
  String get sideCropsLabel => "सुझाई गई अन्य फसलें";
  @override
  String get probabilityUnit => "%";
}

// Bengali
class BengaliStrings implements LanguageStrings {
  @override
  String get okButton => "ঠিক আছে";
  @override
  String get errorTitle => "ত্রুটি";
  @override
  String get appTitle => "ফসল পূর্বাভাস";
  @override
  String get pageTitle => "মানগুলি প্রদান করুন এবং আমরা ফসল সুপারিশ করব";
  @override
  String get nitrogen => "নাইট্রোজেন (N)";
  @override
  String get phosphorus => "ফসফরাস (P)";
  @override
  String get potassium => "পটাশিয়াম (K)";
  @override
  String get temperature => "তাপমাত্রা";
  @override
  String get humidity => "আর্দ্রতা";
  @override
  String get ph => "পিএইচ";
  @override
  String get rainfall => "বৃষ্টিপাত";
  @override
  String get predictButton => "ফসল ভবিষ্যদ্বাণী করুন";
  @override
  String get validationEmpty => "এর জন্য একটি মান লিখুন দয়া করে";
  @override
  String get validationNumber => "একটি সংখ্যা হতে হবে";
  @override
  String get validationRange => "এর মধ্যে হতে হবে";
  @override
  String get resultTitle => "ফসল পূর্বাভাস ফলাফল";
  @override
  String get mainCropLabel => "প্রধান ফসল";
  @override
  String get sideCropsLabel => "প্রস্তাবিত পার্শ্ব ফসল";
  @override
  String get probabilityUnit => "%";
}

// Marathi
class MarathiStrings implements LanguageStrings {
  @override
  String get okButton => "ठीक आहे";
  @override
  String get errorTitle => "त्रुटी";
  @override
  String get appTitle => "पीक अंदाज";
  @override
  String get pageTitle => "मूल्ये प्रदान करा आणि आम्ही पिकांची शिफारस करू";
  @override
  String get nitrogen => "नायट्रोजन (N)";
  @override
  String get phosphorus => "फॉस्फरस (P)";
  @override
  String get potassium => "पोटॅशियम (K)";
  @override
  String get temperature => "तापमान";
  @override
  String get humidity => "आर्द्रता";
  @override
  String get ph => "पीएच";
  @override
  String get rainfall => "पाऊस";
  @override
  String get predictButton => "पीक अंदाज करा";
  @override
  String get validationEmpty => "कृपया यासाठी मूल्य प्रविष्ट करा";
  @override
  String get validationNumber => "संख्या असणे आवश्यक आहे";
  @override
  String get validationRange => "दरम्यान असणे आवश्यक आहे";
  @override
  String get resultTitle => "पीक अंदाज निकाल";
  @override
  String get mainCropLabel => "मुख्य पीक";
  @override
  String get sideCropsLabel => "शिफारस केलेली इतर पिके";
  @override
  String get probabilityUnit => "%";
}

// Telugu
class TeluguStrings implements LanguageStrings {
  @override
  String get okButton => "సరే";
  @override
  String get errorTitle => "లోపం";
  @override
  String get appTitle => "పంట అంచనా";
  @override
  String get pageTitle =>
      "విలువలు అందించండి మరియు మేము పంటలను సిఫార్సు చేస్తాము";
  @override
  String get nitrogen => "నత్రజని (N)";
  @override
  String get phosphorus => "భాస్వరం (P)";
  @override
  String get potassium => "పొటాషియం (K)";
  @override
  String get temperature => "ఉష్ణోగ్రత";
  @override
  String get humidity => "తేమ";
  @override
  String get ph => "pH";
  @override
  String get rainfall => "వర్షపాతం";
  @override
  String get predictButton => "పంటను అంచనా వేయండి";
  @override
  String get validationEmpty => "దయచేసి దీని కోసం విలువను నమోదు చేయండి";
  @override
  String get validationNumber => "సంఖ్య అయి ఉండాలి";
  @override
  String get validationRange => "మధ్య ఉండాలి";
  @override
  String get resultTitle => "పంట అంచనా ఫలితాలు";
  @override
  String get mainCropLabel => "ప్రధాన పంట";
  @override
  String get sideCropsLabel => "సూచించిన ఇతర పంటలు";
  @override
  String get probabilityUnit => "%";
}

// Tamil
class TamilStrings implements LanguageStrings {
  @override
  String get okButton => "சரி";
  @override
  String get errorTitle => "பிழை";
  @override
  String get appTitle => "பயிர் முன்னறிவிப்பு";
  @override
  String get pageTitle =>
      "மதிப்புகளை வழங்கவும், நாங்கள் பயிர்களை பரிந்துரைக்கிறோம்";
  @override
  String get nitrogen => "நைட்ரஜன் (N)";
  @override
  String get phosphorus => "பாஸ்பரஸ் (P)";
  @override
  String get potassium => "பொட்டாசியம் (K)";
  @override
  String get temperature => "வெப்பநிலை";
  @override
  String get humidity => "ஈரப்பதம்";
  @override
  String get ph => "pH";
  @override
  String get rainfall => "மழைப்பொழிவு";
  @override
  String get predictButton => "பயிரை கணிக்கவும்";
  @override
  String get validationEmpty => "தயவு செய்து இதற்கான மதிப்பை உள்ளிடவும்";
  @override
  String get validationNumber => "ஒரு எண்ணாக இருக்க வேண்டும்";
  @override
  String get validationRange => "இடையே இருக்க வேண்டும்";
  @override
  String get resultTitle => "பயிர் முன்னறிவிப்பு முடிவுகள்";
  @override
  String get mainCropLabel => "முதன்மை பயிர்";
  @override
  String get sideCropsLabel => "பரிந்துரைக்கப்பட்ட பக்க பயிர்கள்";
  @override
  String get probabilityUnit => "%";
}

// Kannada
class KannadaStrings implements LanguageStrings {
  @override
  String get okButton => "ಸರಿ";
  @override
  String get errorTitle => "ದೋಷ";
  @override
  String get appTitle => "ಬೆಳೆ ಊಹೆ";
  @override
  String get pageTitle =>
      "ಮೌಲ್ಯಗಳನ್ನು ನೀಡಿ ಮತ್ತು ನಾವು ಬೆಳೆಗಳನ್ನು ಶಿಫಾರಸು ಮಾಡುತ್ತೇವೆ";
  @override
  String get nitrogen => "ಸಾರಜನಕ (N)";
  @override
  String get phosphorus => "ಫಾಸ್ಫರಸ್ (P)";
  @override
  String get potassium => "ಪೊಟ್ಯಾಶಿಯಂ (K)";
  @override
  String get temperature => "ತಾಪಮಾನ";
  @override
  String get humidity => "ಆರ್ದ್ರತೆ";
  @override
  String get ph => "pH";
  @override
  String get rainfall => "ಮಳೆ";
  @override
  String get predictButton => "ಬೆಳೆ ಊಹಿಸಿ";
  @override
  String get validationEmpty => "ದಯವಿಟ್ಟು ಇದಕ್ಕೆ ಮೌಲ್ಯವನ್ನು ನಮೂದಿಸಿ";
  @override
  String get validationNumber => "ಸಂಖ್ಯೆಯಾಗಿರಬೇಕು";
  @override
  String get validationRange => "ನಡುವೆ ಇರಬೇಕು";
  @override
  String get resultTitle => "ಬೆಳೆ ಊಹೆ ಫಲಿತಾಂಶಗಳು";
  @override
  String get mainCropLabel => "ಮುಖ್ಯ ಬೆಳೆ";
  @override
  String get sideCropsLabel => "ಸೂಚಿಸಲಾದ ಇತರೆ ಬೆಳೆಗಳು";
  @override
  String get probabilityUnit => "%";
}

// Malayalam
class MalayalamStrings implements LanguageStrings {
  @override
  String get okButton => "ശരി";
  @override
  String get errorTitle => "പിശക്";
  @override
  String get appTitle => "വിള പ്രവചനം";
  @override
  String get pageTitle => "മൂല്യങ്ങൾ നൽകുക, ഞങ്ങൾ വിളകൾ ശുപാർശ ചെയ്യും";
  @override
  String get nitrogen => "നൈട്രജൻ (N)";
  @override
  String get phosphorus => "ഫോസ്ഫറസ് (P)";
  @override
  String get potassium => "പൊട്ടാസ്യം (K)";
  @override
  String get temperature => "താപനില";
  @override
  String get humidity => "ആർദ്രത";
  @override
  String get ph => "pH";
  @override
  String get rainfall => "മഴ";
  @override
  String get predictButton => "വിള പ്രവചിക്കുക";
  @override
  String get validationEmpty => "ദയവായി ഇതിന് ഒരു മൂല്യം നൽകുക";
  @override
  String get validationNumber => "ഒരു നമ്പറായിരിക്കണം";
  @override
  String get validationRange => "നടുവിലായിരിക്കണം";
  @override
  String get resultTitle => "വിള പ്രവചന ഫലങ്ങൾ";
  @override
  String get mainCropLabel => "പ്രധാന വിള";
  @override
  String get sideCropsLabel => "ശുപാർശ ചെയ്യുന്ന ഇതര വിളകൾ";
  @override
  String get probabilityUnit => "%";
}

// Gujarati
class GujaratiStrings implements LanguageStrings {
  @override
  String get okButton => "ઠીક છે";
  @override
  String get errorTitle => "ભૂલ";
  @override
  String get appTitle => "પાક આગાહી";
  @override
  String get pageTitle => "મૂલ્યો પ્રદાન કરો અને અમે પાકની ભલામણ કરીશું";
  @override
  String get nitrogen => "નાઇટ્રોજન (N)";
  @override
  String get phosphorus => "ફોસ્ફરસ (P)";
  @override
  String get potassium => "પોટેશિયમ (K)";
  @override
  String get temperature => "તાપમાન";
  @override
  String get humidity => "આર્દ્રતા";
  @override
  String get ph => "pH";
  @override
  String get rainfall => "વરસાદ";
  @override
  String get predictButton => "પાકની આગાહી કરો";
  @override
  String get validationEmpty => "કૃપા કરીને આ માટે મૂલ્ય દાખલ કરો";
  @override
  String get validationNumber => "નંબર હોવો જોઈએ";
  @override
  String get validationRange => "વચ્ચે હોવો જોઈએ";
  @override
  String get resultTitle => "પાક આગાહી પરિણામો";
  @override
  String get mainCropLabel => "મુખ્ય પાક";
  @override
  String get sideCropsLabel => "ભલામણ કરેલ અન્ય પાક";
  @override
  String get probabilityUnit => "%";
}

// Urdu
class UrduStrings implements LanguageStrings {
  @override
  String get okButton => "ٹھیک ہے";
  @override
  String get errorTitle => "خرابی";
  @override
  String get appTitle => "فصل کی پیش گوئی";
  @override
  String get pageTitle => "قدروں کو فراہم کریں اور ہم فصلوں کی سفارش کریں گے";
  @override
  String get nitrogen => "نائٹروجن (N)";
  @override
  String get phosphorus => "فاسفورس (P)";
  @override
  String get potassium => "پوٹاشیم (K)";
  @override
  String get temperature => "درجہ حرارت";
  @override
  String get humidity => "نمی";
  @override
  String get ph => "پی ایچ";
  @override
  String get rainfall => "بارش";
  @override
  String get predictButton => "فصل کی پیش گوئی کریں";
  @override
  String get validationEmpty => "براہ کرم اس کے لیے ایک قدر درج کریں";
  @override
  String get validationNumber => "ایک نمبر ہونا چاہیے";
  @override
  String get validationRange => "کے درمیان ہونا چاہیے";
  @override
  String get resultTitle => "فصل کی پیش گوئی کے نتائج";
  @override
  String get mainCropLabel => "اہم فصل";
  @override
  String get sideCropsLabel => "تجویز کردہ دیگر فصلیں";
  @override
  String get probabilityUnit => "%";
}
