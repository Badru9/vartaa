import 'package:flutter/material.dart';
import 'dart:async';
import '../views/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to introduction screen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroductionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Logo and title
            Center(
              child: Image.asset(
                'images/logo and title.png',
                width: 125,
                height: 148,
              ),
            ),
            const Spacer(flex: 2),
            // Static loading image
            Center(
              child: Image.asset('images/loading.png', width: 60, height: 60),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
