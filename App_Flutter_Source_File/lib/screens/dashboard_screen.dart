import 'package:flutter/material.dart';
import '../services/weather_service.dart'; // Make sure this path is correct

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _city = 'Mianwali';
  String _description = 'Loading...';
  double? _temperature;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = await WeatherService.fetchWeather(_city);
      setState(() {
        _temperature = weather['temp'];
        _description = weather['desc'];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _description = 'Failed to load';
        _loading = false;
      });
    }
  }

  // Optional: Tap to change city (very simple prompt)
  Future<void> _changeCity() async {
    final controller = TextEditingController(text: _city);
    final newCity = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مقام تبدیل کریں'), // Change Location
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'شہر کا نام درج کریں', // Enter city name
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ کریں')), // Cancel
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('ٹھیک ہے')), // OK
        ],
      ),
    );

    if (newCity != null && newCity.isNotEmpty && newCity != _city) {
      setState(() {
        _city = newCity;
        _loading = true;
      });
      _fetchWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFFF5D7BB);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 245, 215),
      appBar: AppBar(
        title: const Text(
          'اسمارٹ ایگری ڈاکٹر', // Smart Agri-Doctor
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        backgroundColor: primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🌤️ Weather Card
              GestureDetector(
                onTap: _changeCity, // Click to change city
                child: Card(
                  color: const Color(0xFFF4E5BB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🌍 $_city',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        _loading
                            ? const Text('Loading...', style: TextStyle(color: Colors.black))
                            : Text(
                                '${_temperature?.toStringAsFixed(1) ?? '--'}°  •  ${_description[0].toUpperCase()}${_description.substring(1)}',
                                style: const TextStyle(color: Colors.black),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Intro text
              const Text(
                'متاثرہ پتے کی صاف تصویر لیں۔ یقینی بنائیں کہ روشنی مناسب ہے۔', // Capture a clear photo...
                style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 16),
                textAlign: TextAlign.right, // Urdu alignment
              ),
              const SizedBox(height: 18),

              // Capture / Upload area
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/upload'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 177, 171, 171),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera_front_outlined, size: 64, color: Colors.white70),
                        SizedBox(height: 12),
                        Text('تصویر لینے یا اپ لوڈ کرنے کے لیے ٹیپ کریں', // Tap to Capture or Upload
                            style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Bottom button
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/upload'),
                icon: const Icon(Icons.camera_alt),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'تصویر لیں یا اپ لوڈ کریں', // Capture or Upload Image
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}
