import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vartaa/controllers/bookmark_controller.dart';
import 'package:vartaa/controllers/news_controller.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/screens/author/profile_screen.dart';
import 'package:vartaa/screens/home_screen_content.dart';
import 'package:vartaa/screens/saved_news_screen.dart';
import 'package:vartaa/utils/helper.dart';
import 'package:vartaa/screens/news_detail_screen.dart';

// Widget NewsCard (Diperbarui untuk menerima objek NewsArticle)
class NewsCard extends StatelessWidget {
  final NewsArticle newsItem; // Menerima objek NewsArticle
  final bool isSmall;

  const NewsCard({super.key, required this.newsItem, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (newsItem.slug != null && newsItem.slug!.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(slug: newsItem.slug!),
            ),
          );
        } else {
          // Handle case where slug is missing/empty
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Detail berita tidak tersedia (slug kosong).'),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(25),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child:
                  (newsItem.featuredImageUrl != null &&
                          newsItem.featuredImageUrl!.isNotEmpty)
                      ? Image.network(
                        newsItem.featuredImageUrl!,
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
                      )
                      : Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getCategoryColor(
                          newsItem.category,
                        ), // Menggunakan category dari NewsArticle
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        newsItem
                            .category, // Menggunakan category dari NewsArticle
                        style: const TextStyle(
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
  // int _activeIndex = 0;
  // String queryString = 'home'; // Tidak lagi digunakan untuk filtering API

  // final _navScrollController = ScrollController();
  // late NewsController _newsController; // Gunakan Provider.of<NewsController>
  int _currentBottomNavIndex = 0;

  // final List<String> _navItems = [
  //   'All',
  //   'Business',
  //   'Tech',
  //   'Sports',
  //   'Health',
  //   'Science',
  //   'Entertainment',
  //   'General',
  // ];

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const SavedNewsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Memanggil fetchHeadlines dan fetchGeneralNews saat initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Menggunakan Provider.of untuk memanggil method controller
      // Karena API tidak mendukung kategori/search, kita hanya panggil fetchNews umum
      Provider.of<NewsController>(
        context,
        listen: false,
      ).fetchHeadlines(limit: 5); // Untuk carousel
      Provider.of<NewsController>(
        context,
        listen: false,
      ).fetchGeneralNews(page: 2, limit: 6); // Untuk daftar berita
    });
  }

  // void _scrollToNavItem(int index) {
  //   // Implementasi ini masih berguna untuk pengalaman pengguna meskipun tidak memfilter API
  //   final double itemWidth = 100; // Approximate width of a NavLink item
  //   final double screenWidth = MediaQuery.of(context).size.width;
  //   final double scrollOffset =
  //       (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

  //   _navScrollController.animateTo(
  //     scrollOffset.clamp(0.0, _navScrollController.position.maxScrollExtent),
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(child: _pages[_currentBottomNavIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIcons.house(PhosphorIconsStyle.regular)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(
              PhosphorIcons.bookmarks(PhosphorIconsStyle.regular),
            ),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: PhosphorIcon(PhosphorIcons.user(PhosphorIconsStyle.regular)),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          // Jika berpindah ke Saved tab, paksa refresh data bookmark
          if (index == 1) {
            Provider.of<BookmarkController>(
              context,
              listen: false,
            ).refreshBookmarks();
          }
        },
      ),
    );
  }
}
