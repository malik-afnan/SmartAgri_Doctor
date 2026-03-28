import 'package:flutter/material.dart';
import '../../services/weather_service.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  String temp = '--';
  String desc = 'Loading...';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final w = await WeatherService.fetchWeather('Mianwali');
      setState(() {
        temp = '${w['temp']?.round() ?? '--'}°C';
        desc = (w['desc'] ?? 'Clear').toString();
        loading = false;
      });
    } catch (e) {
      setState(() {
        temp = '37°C';
        desc = 'Cloudy';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4E5BB), // Sukhiya tone
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Weather info at top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🌍 Mianwali',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        temp,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(desc, style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Title
              Text(
                'اسمارٹ ایگری ڈاکٹر میں خوش آمدید', // Welcome to Smart Agri-Doctor
                style: const TextStyle(
                  fontSize: 27, 
                  fontWeight: FontWeight.w900,
                  color: Colors.black,),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Text(
                'گندم کی بیماریوں کی فوری تشخیص کریں', // Identify Wheat Crop Diseases In Seconds
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(179, 0, 0, 0),
                  fontSize: 18,
                  height: 1.4,
                ),
              ),


               const Spacer(),
              // Center Image
              Image.asset(
                'assets/images/2.png',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

             

              const Spacer(),

              // Get Started Button
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'شروع کریں', // Get Started
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
