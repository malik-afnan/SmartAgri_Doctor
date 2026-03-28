import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 2 seconds go to onboarding
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/onboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5D7BB),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           Image.asset('assets/images/1.png', width: 220, height: 220,),
            
           const Text(
              'Smart Agri-Doctor',
              style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Helping farmers diagnose crop disease', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
