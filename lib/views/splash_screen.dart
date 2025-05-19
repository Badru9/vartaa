import 'package:flutter/material.dart';
import 'dart:async';
import '../views/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroductionScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                width: 160,
                height: 180,
              ),
            ),
            const Spacer(flex: 2),
            // Loading animation
            RotationTransition(
              turns: _controller,
              child: Center(
                child: Image.asset('images/loading.png', width: 50, height: 50),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
