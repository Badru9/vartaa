import 'package:flutter/material.dart';
import 'package:vartaa/utils/helper.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vartaa/controllers/news_controller.dart';
import 'package:vartaa/constants/constants.dart';

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
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isActive ? Colors.black : Colors.transparent,
            border: Border.all(color: Colors.grey.withAlpha(100), width: 1),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[700],
              fontSize: fontSize ?? 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> newsItem;
  final bool isSmall;

  const NewsCard({super.key, required this.newsItem, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              newsItem['imageUrl'],
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                );
              },
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem['title'],
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(newsItem['category']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      newsItem['category'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
  String queryString = 'home';

  final _navScrollController = ScrollController();
  late NewsController _newsController;

  final List<String> _navItems = [
    'All',
    'Business',
    'Tech',
    'Sports',
    'Health',
    'Science',
    'Entertainment',
    'General',
  ];

  void _onNavTap(int index) {
    setState(() {
      _activeIndex = index;
    });

    // Handle navigation logic
    switch (index) {
      case 0:
        queryString = 'home';
        print('Navigate to All');
        break;
      case 1:
        queryString = 'business';
        print('Navigate to Business');
        break;
      case 2:
        queryString = 'tech';
        print('Navigate to Technology');
        break;
      case 3:
        queryString = 'sport';
        print('Navigate to Sports');
        break;
      case 4:
        queryString = 'health';
        print('Navigate to Health');
        break;
      case 5:
        queryString = 'science';
        print('Navigate to Science');
        break;
      case 6:
        queryString = 'entertainment';
        print('Navigate to Entertainment');
        break;
      case 7:
        queryString = 'general';
        print('Navigate to General');
        break;
    }
  }

  List<Map<String, dynamic>> carouselData = [
    {
      'title': 'Ekonomi Indonesia Tumbuh 4,87% di Q1 2025',
      'description':
          'Pertumbuhan ekonomi Indonesia di kuartal pertama 2025 mencapai 4,87 persen ditopang sektor pertanian yang tumbuh double digit',
      'date': '25 Mei 2025',
      'category': 'Business',
      'writer': 'Redaksi BPS',
      'imageUrl':
          'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?w=400&h=300&fit=crop',
    },
    {
      'title': 'Inovasi Teknologi AI Terbaru 2025',
      'description':
          'Perkembangan teknologi artificial intelligence menunjukkan kemajuan pesat dalam berbagai sektor industri',
      'date': '24 Mei 2025',
      'category': 'Tech',
      'writer': 'Tim Teknologi',
      'imageUrl':
          'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=400&h=300&fit=crop',
    },
    {
      'title': 'Prestasi Olahraga Indonesia di Kancah Internasional',
      'description':
          'Atlet Indonesia meraih berbagai prestasi membanggakan di kompetisi internasional',
      'date': '23 Mei 2025',
      'category': 'Sports',
      'writer': 'Reporter Olahraga',
      'imageUrl':
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400&h=300&fit=crop',
    },
  ];

  List<Map<String, dynamic>> newsListData = [
    {
      'title': 'Kebijakan Energi Terbarukan Indonesia Menuju 2030',
      'category': 'Business',
      'imageUrl':
          'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=90&h=90&fit=crop',
    },
    {
      'title': 'Perkembangan Startup Teknologi di Asia Tenggara',
      'category': 'Tech',
      'imageUrl':
          'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=90&h=90&fit=crop',
    },
    {
      'title': 'Tips Menjaga Kesehatan di Musim Pancaroba',
      'category': 'Health',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=90&h=90&fit=crop',
    },
    {
      'title': 'Penelitian Terbaru tentang Perubahan Iklim',
      'category': 'Science',
      'imageUrl':
          'https://images.unsplash.com/photo-1569163139394-de4e4f43e4e5?w=90&h=90&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _newsController = NewsController();
    _loadNews(queryString);
  }

  void _loadNews(String query) {
    _newsController.fetchEverything(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan logo dan navigasi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'vartaa',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        Icon(
                          Icons.notifications_outlined,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Navigation tabs
                    SingleChildScrollView(
                      controller: _navScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            _navItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return NavLink(
                                text: item,
                                isActive: _activeIndex == index,
                                onTap: () => _onNavTap(index),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    // Featured carousel
                    SizedBox(
                      height: 320,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 320,
                          viewportFraction: 0.88,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 4),
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 800,
                          ),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items:
                            carouselData.map((newsItem) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Background image
                                      Image.network(
                                        newsItem['imageUrl'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey[500],
                                              size: 50,
                                            ),
                                          );
                                        },
                                      ),

                                      // Gradient overlay
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withAlpha(180),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Content overlay
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        right: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Category badge
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(
                                                  newsItem['category'],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                newsItem['category']
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12),

                                            // Title
                                            Text(
                                              newsItem['title'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),

                                            // Description
                                            Text(
                                              newsItem['description'],
                                              style: TextStyle(
                                                color: Colors.white.withAlpha(
                                                  220,
                                                ),
                                                fontSize: 13,
                                                height: 1.3,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 12),

                                            // Bottom info
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  newsItem['date'],
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withAlpha(180),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                Text(
                                                  newsItem['writer'],
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withAlpha(180),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: 30),

                    // News list section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Berita Terbaru',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          // News cards
                          ...newsListData.map(
                            (newsItem) => NewsCard(newsItem: newsItem),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'business':
      return Colors.green[600]!;
    case 'entertainment':
      return Colors.purple[600]!;
    case 'general':
      return Colors.blue[600]!;
    case 'health':
      return Colors.pink[600]!;
    case 'science':
      return Colors.orange[600]!;
    case 'sports':
      return Colors.red[600]!;
    case 'technology':
    case 'tech':
      return Colors.indigo[600]!;
    case 'life':
      return Colors.teal[600]!;
    default:
      return Colors.grey[600]!;
  }
}
