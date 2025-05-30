import 'package:flutter/material.dart';
import 'package:newshive/utils/helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Widget NavLink
class NavLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;

  const NavLink({
    super.key,
    required this.text,
    this.onTap,
    this.isActive = false,
    this.activeColor,
    this.inactiveColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          text,
          style: TextStyle(
            color:
                isActive
                    ? (activeColor ?? Colors.white)
                    : (inactiveColor ?? Colors.grey[400]),
            fontSize: fontSize ?? 14,
            fontWeight:
                isActive ? (fontWeight ?? FontWeight.w600) : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeIndex = 0;
  int _navBarIndex = 0;

  // Data navigation items
  final List<String> _navItems = ['Home', 'Technology', 'Sports', 'Business'];

  void _onNavTap(int index) {
    setState(() {
      _activeIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        print('Navigate to Home');
        break;
      case 1:
        print('Navigate to Technology');
        break;
      case 2:
        print('Navigate to Sports');
        break;
      case 3:
        print('Navigate to Business');
        break;
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _navBarIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        print('Navigate to Home');
        break;
      case 1:
        print('Navigate to Technology');
        break;
      case 2:
        print('Navigate to Sports');
        break;
      case 3:
        print('Navigate to Business');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cSecondary,
      body: Center(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('images/logo_dark.png', width: 100),
                  vsMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children:
                        _navItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return NavLink(
                            text: item,
                            isActive: _activeIndex == index,
                            onTap: () => _onNavTap(index),
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            vsMedium,
            SizedBox(
              height: 300,
              child: CarouselView(
                scrollDirection: Axis.horizontal,
                backgroundColor: cSmokeWhite,
                itemExtent: 400,
                itemSnapping: true,
                enableSplash: true,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Slide 1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Slide 2',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Slide 3',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Slide 4',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Slide 5',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: cBlack,
        unselectedItemColor: cBlack,
        selectedFontSize: 12,
        currentIndex: _navBarIndex,
        onTap: _onBottomNavTap,
        items: [
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIcons.house(), size: 14),
            label: 'Beranda',
            backgroundColor: cPrimary,
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIcons.newspaper(), size: 14),
            label: 'Kategori',
            backgroundColor: cPrimary,
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIcons.magnifyingGlass(), size: 14),
            label: 'Cari',
            backgroundColor: cPrimary,
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIcons.user(), size: 14),
            label: 'Profil',
            backgroundColor: cPrimary,
          ),
        ],
      ),
    );
  }
}
