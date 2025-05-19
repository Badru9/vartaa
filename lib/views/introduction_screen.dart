import 'package:flutter/material.dart';
import 'package:newshive/views/auth/login_screen.dart';
import 'package:newshive/views/utils/helper.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  // Using PageController for simpler implementation
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> pageList = [
    {
      'imageAsset': 'images/img intro 1.png',
      'title': 'The World at Your Fingertips',
      'subtitle':
          'Get 24/7 updates on global news – from breaking politics to cultural trends, all in one place',
    },
    {
      'imageAsset': 'images/img intro 2.png',
      'title': 'Tailored to Your Curiosity',
      'subtitle':
          'Select your interests and receive handpicked stories. Technology, sports, or entertainment – we\'ve got you covered',
    },
    {
      'imageAsset': 'images/img intro 3.png',
      'title': 'Trusted Updates in Real-Time',
      'subtitle':
          'Instant alerts for breaking news, rigorously fact-checked by our editors before they reach you',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button
            PageView.builder(
              controller: _pageController,
              itemCount: pageList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = pageList[index];
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Image.asset(page['imageAsset'], width: 292, height: 349),
                      const SizedBox(height: 120),
                      Text(
                        page['title'],
                        style: headline3.copyWith(
                          color: cPrimary,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        page['subtitle'],
                        style: subtitle1.copyWith(color: cPrimary),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Page content
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text('Get Started'),
              ),
            ),

            // Page indicators
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageList.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? cPrimary
                              : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
