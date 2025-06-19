import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:vartaa/screens/home_screen.dart';
import 'package:vartaa/utils/helper.dart';
import 'dart:async';
import 'introduction_screen.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cPrimary,
      body: SafeArea(
        child: AnimatedSplashScreen(
          splash: 'images/logo_light.png',
          backgroundColor: cPrimary,
          splashIconSize: 80,
          centered: true,
          curve: Curves.bounceOut,
          splashTransition: SplashTransition.slideTransition,
          animationDuration: Duration(milliseconds: 1100),
          nextScreen: const IntroductionScreen(),
          // nextScreen: const HomeScreen(),
          duration: 3100,
        ),
      ),
    );
  }
}
