import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fyp/services/ml_service.dart';

class ResultScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final String imageName;

  const ResultScreen({
    super.key,
    required this.imageBytes,
    required this.imageName,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _analyzing = true;
  Map<String, dynamic>? _analysis;
  final MLService _mlService = MLService();

  @override
  void initState() {
    super.initState();
    _runRealAnalysis();
  }

  Future<void> _runRealAnalysis() async {
    try {
      // Step 1: Load model if not already
      await _mlService.loadModel();

      // Step 2: Convert Uint8List -> File (TFLite requires a file)
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/${widget.imageName}';
      final imageFile = await File(imagePath).writeAsBytes(widget.imageBytes);

      // Step 3: Run prediction
      final result = await _mlService.predict(imageFile);

      // Step 4: Display results
      setState(() {
        _analysis = {
          'disease': result['label'],
          'confidence': result['confidence'],
          'advice': _getAdvice(result['label']),
        };
        _analyzing = false;
      });
    } catch (e) {
      setState(() {
        _analyzing = false;
        _analysis = {
          'disease': 'Error analyzing image',
          'confidence': '0',
          'advice': ['دوبارہ کوشش کریں یا اپنا ماڈل فائل چیک کریں۔'],
        };
      });
      debugPrint('Error running analysis: $e');
    }
  }

  // Step 5: Add some advice for each disease (customize these as you wish)
  List<String> _getAdvice(String diseaseLabel) {
    switch (diseaseLabel.toLowerCase()) {
      case 'aphid':
        return [
          'کھیت میں لیڈی برڈ بیٹل (دوست کیڑے) کی موجودگی یقینی بنائیں۔',
          'متاثرہ پودوں پر راکھ کا چھڑکاؤ کریں۔',
          'نائٹروجن کھاد کا استعمال کم کریں۔',
          'کھیت کو جڑی بوٹیوں سے پاک رکھیں۔',
          'امیڈاکلوپرڈ یا تھائیمتھوکسام کا اسپرے کریں۔'
        ];

      case 'black rust':
        return [
          'بیماری کے پھیلاؤ کو روکنے کے لیے متاثرہ پودے تلف کریں۔',
          'متوازن کھادیں استعمال کریں، خاص طور پر پوٹاش۔',
          'فصلوں کا ہیر پھیر (Crop Rotation) اپنائیں۔',
          'کھیت میں ہوا کے گزر کو یقینی بنائیں۔',
          'ٹیبوکونازول یا پروپیکونازول کا اسپرے کریں۔'
        ];

      case 'blast':
        return [
          'پانی کی سطح کو برقرار رکھیں (چاول کی صورت میں)۔',
          'یوریا کھاد کا استعمال کم کریں اور وقفوں میں دیں۔',
          'کھیت میں پودوں کا فاصلہ مناسب رکھیں۔',
          'بیماری سے پاک بیج استعمال کریں۔',
          'ٹرائی سائیکلازول یا آئسوپروتھیولین اسپرے کریں۔'
        ];

      case 'brown rust':
        return [
          'قوت مدافعت والی اقسام کاشت کریں۔',
          'کھیت میں جڑی بوٹیاں تلف کریں۔',
          'یوریا کا غیر ضروری استعمال نہ کریں۔',
          'بروقت کاشت یقینی بنائیں۔',
          'ایزوکسی سٹروبن یا ڈائفی نیکونازول اسپرے کریں۔'
        ];

      case 'common root rot':
        return [
          'بیج کو فنگس کش دوا لگا کر کاشت کریں۔',
          'کھیت میں پانی کھڑا نہ ہونے دیں۔',
          'فصلوں کا ہیر پھیر (Crop Rotation) کریں۔',
          'زمین کی تیاری کے وقت وتر کا خیال رکھیں۔',
          'بیج کو کاربینڈازم یا تھایوفینیٹ میتھائل لگائیں۔'
        ];

      case 'fusarium head blight':
        return [
          'مکئی کے بعد گندم کاشت کرنے سے گریز کریں۔',
          'پھول آنے کے مرحلے پر آبپاشی میں احتیاط کریں۔',
          'متاثرہ سٹوں کو کھیت سے نکال دیں۔',
          'گہری ہل چلا کر باقیات کو زمین میں دبائیں۔',
          'میٹالیکسل یا ٹیبوکونازول کا اسپرے کریں۔'
        ];

      case 'leaf blight':
        return [
          'متاثرہ پرانے پتوں کو ہٹا دیں۔',
          'کھیت میں نکاسی آب کا انتظام بہتر کریں۔',
          'پوٹاش کھاد کا استعمال بڑھائیں۔',
          'بیج کو دوائی لگا کر کاشت کریں۔',
          'مینکوزیب 2.5 گرام فی لیٹر پانی ملا کر اسپرے کریں۔'
        ];

      case 'mildew':
        return [
          'سایہ دار جگہوں پر بیماری کا حملہ زیادہ ہوتا ہے، خیال رکھیں۔',
          'پودوں کے درمیان ہوادار فاصلہ رکھیں۔',
          'نائٹروجن والی کھاد کم استعمال کریں۔',
          'متاثرہ حصے کاٹ دیں۔',
          'سلفر یا ٹاپسن ایم کا اسپرے کریں۔'
        ];

      case 'mite':
        return [
          'کھیت کے کناروں سے جڑی بوٹیاں ختم کریں۔',
          'پانی کی کمی نہ ہونے دیں (خشکی میں حملہ زیادہ ہوتا ہے)۔',
          'پودوں کو دھول مٹی سے صاف رکھیں۔',
          'شدید حملے کی صورت میں پتے توڑ دیں۔',
          'سپائیرومیسیفن یا ایبامیکٹن کا اسپرے کریں۔'
        ];

      case 'septoria':
        return [
          'فصل کی باقیات کو گہرا ہل چلا کر دبائیں۔',
          'فصلوں کا ادل بدل کریں۔',
          'گنجان کاشت سے گریز کریں۔',
          'زیادہ نمی والے موسم میں نگرانی سخت کریں۔',
          'کلوروتھالونیل یا ٹیبوکونازول کا اسپرے کریں۔'
        ];

      case 'smut':
        return [
          'یہ بیج سے پھیلنے والی بیماری ہے، اگلی بار نیا بیج لیں۔',
          'متاثرہ سٹوں کو احتیاط سے تھیلی میں ڈال کر تلف کریں۔',
          'کھیت میں بیج بکھرنے نہ دیں۔',
          'صحت مند بیج کا انتخاب کریں۔',
          'بیج کو ویٹا ویکس یا کاربوکسین لگا کر کاشت کریں۔'
        ];

      case 'stem fly':
        return [
          'متاثرہ پودے سوکھ جاتے ہیں، انہیں اکھاڑ پھینکیں۔',
          'بوائی میں تاخیر نہ کریں (وقت پر کاشت کریں)۔',
          'شرح بیج بڑھا دیں تاکہ پودوں کی تعداد پوری رہے۔',
          'نائٹروجن کا استعمال کم کریں۔',
          'کاربوفیوران دانے دار زہر یا ڈائیمتھوئیٹ استعمال کریں۔'
        ];

      case 'tan spot':
        return [
          'پچھلی فصل کی باقیات کو مکمل تلف کریں۔',
          'فصلوں کا ہیر پھیر (Crop Rotation) ضروری ہے۔',
          'بیج کو فنگس کش دوا لگا کر کاشت کریں۔',
          'کھیت کو جڑی بوٹیوں سے صاف رکھیں۔',
          'پروپیکونازول یا ایزوکسی سٹروبن کا اسپرے کریں۔'
        ];

      case 'yellow rust':
        return [
          'ٹھنڈے اور مرطوب موسم میں کھیت کا روزانہ معائنہ کریں۔',
          'قوت مدافعت رکھنے والی اقسام کاشت کریں۔',
          'بیماری نظر آتے ہی پیچ (Patch) میں اسپرے کریں۔',
          'یوریا کا استعمال روک دیں۔',
          'ٹرائی فلوکسیسٹروبن یا ٹیبوکونازول اسپرے کریں۔'
        ];

      case 'healthy':
        return [
          'ماشاءاللہ، آپ کی فصل بالکل تندرست ہے۔',
          'آبپاشی کا معمول برقرار رکھیں۔',
          'جڑی بوٹیوں کی تلفی پر توجہ دیں۔',
          'وقت پر کٹائی کی تیاری کریں۔',
          'پیداوار بڑھانے کے لیے این پی کے یا امائنو ایسڈ استعمال کریں۔'
        ];

      default:
        return [
          'اس بیماری کے لیے فی الحال کوئی خاص تجویز موجود نہیں ہے۔',
          'براہ کرم زرعی ماہر سے رجوع کریں۔'
        ];
    }
  }

  @override
  void dispose() {
    _mlService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color(0xFFF5D7BB);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('تجزیاتی نتیجہ'), // Analysis Result
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Image preview
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            Image.memory(widget.imageBytes, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_analyzing) const LinearProgressIndicator(),
                    const SizedBox(height: 10),

                    if (_analysis != null) ...[
                      Text(
                        'تشخیص: ${_analysis!['disease']}', // Detected
                        style: const TextStyle(
                            color: Colors.white, // Changed to white for dark bg
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'یقین: ${_analysis!['confidence']}%', // Confidence
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight, // Urdu alignment
                        child: Text(
                          'سفارشات:', // Recommendations
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (var tip in _analysis!['advice'])
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const Icon(Icons.check, color: Colors.white70),
                          title: Text(
                            tip,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.right, // Urdu text align
                          ),
                        ),
                    ] else if (!_analyzing) ...[
                      const Text('کوئی نتیجہ دستیاب نہیں', // No result available
                          style: TextStyle(color: Colors.white70)),
                    ] else
                      const SizedBox(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Inverted for contrast
                        foregroundColor: Colors.black),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'ہوم پر واپس جائیں', // Back to Home
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
