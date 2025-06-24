import 'package:flutter/material.dart';
import 'package:vartaa/screens/auth/login_screen.dart';
import 'package:vartaa/utils/helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
      'title': 'News Without Borders',
      'subtitle': 'Stay informed globally. Breaking news in your pocket.',
    },
    {
      'imageAsset': 'images/img intro 2.png',
      'title': 'Your News, Your Way',
      'subtitle': 'Pick your interests. Get stories you love.',
    },
    {
      'imageAsset': 'images/img intro 3.png',
      'title': 'Fast and Verified',
      'subtitle': 'Instant breaking news. Editor-verified accuracy.',
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
      backgroundColor: cSmokeWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe ke kanan
                  if (_currentPage > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                } else if (details.primaryVelocity! < 0) {
                  // Swipe ke kiri
                  if (_currentPage < pageList.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pageList[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          cPrimary.withAlpha(50),
                          cPrimary.withAlpha(30),
                          cPrimary.withAlpha(10),
                          cPrimary.withAlpha(0),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 100),
                          Image.asset(
                            page['imageAsset'],
                            width: double.infinity,
                            height: 349,
                          ),
                          const SizedBox(height: 80),
                          Text(page['title']),
                          Text(page['subtitle']),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Page content
            if (_currentPage == pageList.length - 1)
              Positioned(
                top: 10,
                right: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cSecondary,
                    foregroundColor: cPrimary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text('Get Started'),
                ),
              ),

            if (_currentPage == 0)
              Positioned(
                top: 10,
                left: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cSecondary,
                    foregroundColor: cPrimary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text('Skip'),
                ),
              ),

            // Page indicators
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: pageList.length,
                  effect: WormEffect(
                    dotColor: cSecondary,
                    activeDotColor: cPrimary,
                    dotWidth: 10,
                    type: WormType.thinUnderground,
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
