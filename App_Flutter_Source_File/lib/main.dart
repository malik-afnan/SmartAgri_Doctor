import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/upload_screen.dart';

void main() {
  runApp(const SmartAgriDoctorApp());
}

class SmartAgriDoctorApp extends StatelessWidget {
  const SmartAgriDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Agri-Doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboard': (context) => const OnboardScreen(),
        '/home': (context) => const DashboardScreen(),
        '/upload': (context) => const UploadScreen(),
        // Result screen is pushed with arguments (we use MaterialPageRoute)
      },
    );
  }
}