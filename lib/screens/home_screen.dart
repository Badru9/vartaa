import 'package:flutter/material.dart';
import 'package:newshive/utils/helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  List<Map<String, dynamic>> carouselData = [
    {
      'title': 'Ekonomi Indonesia Tumbuh 4,87% di Q1 2025',
      'description':
          'Pertumbuhan ekonomi Indonesia di kuartal pertama 2025 mencapai 4,87 persen ditopang sektor pertanian yang tumbuh double digit',
      'date': '31 Mei 2025',
      'category': 'business',
      'writer': 'Redaksi BPS',
      'imageUrl':
          'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Kebakaran Hutan dan Lahan di Kalimantan Tengah',
      'description':
          'BPBD menangani kebakaran hutan dan lahan di Desa Kubu, Kecamatan Kumai, Kabupaten Kotawaringin Barat',
      'date': '31 Mei 2025',
      'category': 'health',
      'writer': 'Tim BNPB',
      'imageUrl':
          'https://images.unsplash.com/photo-1574263867128-c4b8e2536d24?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'TNI Klarifikasi Kerja Sama dengan Kampus',
      'description':
          'TNI menegaskan kerja sama dengan kampus sebatas wawasan kebangsaan, bela negara, dan kedisiplinan, bukan militerisasi',
      'date': '30 Mei 2025',
      'category': 'general',
      'writer': 'Redaksi Kompas',
      'imageUrl':
          'https://images.unsplash.com/photo-1577962917302-cd874c99e6d2?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Tren Desain Kamar Bayi 2025',
      'description':
          'Desain minimalis modern dengan sentuhan alami dan warna-warna menenangkan menjadi tren kamar bayi tahun 2025',
      'date': '30 Mei 2025',
      'category': 'entertainment',
      'writer': 'Redaksi Liputan6',
      'imageUrl':
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Sektor Transportasi Mengalami Pertumbuhan Solid',
      'description':
          'Aktivitas sektor transportasi menunjukkan kinerja yang kuat mendukung pertumbuhan ekonomi nasional',
      'date': '29 Mei 2025',
      'category': 'business',
      'writer': 'Statistik Indonesia',
      'imageUrl':
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Manufaktur Makanan dan Minuman Tumbuh Pesat',
      'description':
          'Sektor manufaktur makanan dan minuman mencatat kinerja solid di kuartal pertama 2025',
      'date': '29 Mei 2025',
      'category': 'technology',
      'writer': 'Analisis Ekonomi',
      'imageUrl':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Program Wawasan Kebangsaan di Perguruan Tinggi',
      'description':
          'Kementerian Pertahanan fokus pada program wawasan kebangsaan dan bela negara di kampus-kampus',
      'date': '28 Mei 2025',
      'category': 'science',
      'writer': 'Reporter Politik',
      'imageUrl':
          'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Ketidakpastian Global Tidak Pengaruhi Ekonomi RI',
      'description':
          'Ekonomi Indonesia tetap bertahan dan tumbuh positif meski menghadapi ketidakpastian ekonomi global',
      'date': '28 Mei 2025',
      'category': 'general',
      'writer': 'Kepala BPS',
      'imageUrl':
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Sektor Pertanian Catat Pertumbuhan Dua Digit',
      'description':
          'Sektor pertanian Indonesia mencatat pertumbuhan double digit yang menopang ekonomi nasional',
      'date': '27 Mei 2025',
      'category': 'general',
      'writer': 'Redaksi Ekonomi',
      'imageUrl':
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=200&fit=crop&crop=center',
    },
    {
      'title': 'Kinerja BUMN di Berbagai Sektor Meningkat',
      'description':
          'Badan Usaha Milik Negara menunjukkan kinerja positif di berbagai sektor strategis nasional',
      'date': '27 Mei 2025',
      'category': 'business',
      'writer': 'Kilas BUMN',
      'imageUrl':
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=200&fit=crop&crop=center',
    },
  ];
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
            vsXLarge,
            SizedBox(
              height: 320,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 320,
                  viewportFraction: 0.7,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items:
                    carouselData.map((newsItem) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(10),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image with category badge overlay
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    child: Image.network(
                                      newsItem['imageUrl'],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          height: 120,
                                          width: double.infinity,
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 120,
                                          width: double.infinity,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey[400],
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Category badge overlay
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(
                                          newsItem['category'],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        newsItem['category'].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: overline.fontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Content section
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Text(
                                        newsItem['title'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      vsSuperTiny,

                                      // Description
                                      Expanded(
                                        child: Text(
                                          newsItem['description'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            height: 1.3,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      vsTiny,

                                      // Bottom info (date and writer)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              newsItem['date'],
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              'By ${newsItem['writer']}',
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 10,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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

Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'business':
      return Colors.green;
    case 'entertainment':
      return Colors.blue;
    case 'general':
      return Colors.teal;
    case 'health':
      return Colors.pink;
    case 'science':
      return Colors.orange;
    case 'sports':
      return Colors.purple;
    case 'technology':
      return Colors.lightGreen;
    default:
      return cPrimary;
  }
}
