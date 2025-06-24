// lib/screens/home_screen_content.dart
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vartaa/controllers/news_controller.dart';
import 'package:vartaa/screens/home_screen.dart';
import 'package:vartaa/utils/helper.dart';
// import 'package:vartaa/widgets/navigation_link.dart';
import 'package:vartaa/screens/news_detail_screen.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // int _activeIndex = 0;
  // final _navScrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();
    // Memanggil fetchHeadlines dan fetchGeneralNews saat initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsController>(
        context,
        listen: false,
      ).fetchHeadlines(limit: 5); // Untuk carousel
      Provider.of<NewsController>(
        context,
        listen: false,
      ).fetchGeneralNews(page: 1, limit: 10); // Untuk daftar berita
    });
  }

  // void _onNavTap(int index) {
  //   setState(() {
  //     _activeIndex = index;
  //   });
  //   // Karena API tidak mendukung filter kategori, tap pada NavLink hanya akan mengubah UI aktif
  //   // dan tidak akan memuat ulang data dari API dengan filter yang berbeda.
  //   // Data yang ditampilkan akan tetap sama, yaitu berita umum berdasarkan page/limit.
  //   print(
  //     'Navigated to: ${_navItems[index]}. API does not support category filtering.',
  //   );

  //   // Auto-scroll nav item to center if it's not fully visible
  //   _scrollToNavItem(index);
  // }

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
    return Column(
      // Ini adalah isi utama dari Home Screen
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
                offset: const Offset(0, 2),
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
                    Image.asset('images/logo_light.png', width: 100),
                    Icon(
                      PhosphorIcons.bell(
                        PhosphorIconsStyle.regular,
                      ), // Menggunakan PhosphorIcons.bell
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ],
                ),
                // const SizedBox(height: 20),

                // Navigation tabs
                // SingleChildScrollView(
                //   controller: _navScrollController,
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children:
                //         _navItems.asMap().entries.map((entry) {
                //           final index = entry.key;
                //           final item = entry.value;
                //           return NavLink(
                //             text: item,
                //             isActive: _activeIndex == index,
                //             onTap: () => _onNavTap(index),
                //           );
                //         }).toList(),
                //   ),
                // ),
              ],
            ),
          ),
        ),

        // Content area
        Expanded(
          child: Consumer<NewsController>(
            builder: (context, newsController, child) {
              // Tampilkan indikator loading jika salah satu sedang memuat
              if (newsController.headlinesStatus == NewsStatus.loading ||
                  newsController.generalNewsStatus == NewsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Tampilkan pesan error jika ada
              else if (newsController.headlinesStatus == NewsStatus.error) {
                return Center(
                  child: Text(
                    'Error Headlines: ${newsController.errorMessage}',
                  ),
                );
              } else if (newsController.generalNewsStatus == NewsStatus.error) {
                return Center(
                  child: Text(
                    'Error General News: ${newsController.errorMessage}',
                  ),
                );
              }
              // Tampilkan pesan jika tidak ada berita (setelah loading selesai)
              else if (newsController.headlinesStatus == NewsStatus.loaded &&
                  newsController.headlines.isEmpty) {
                return const Center(child: Text('No headlines available.'));
              } else if (newsController.generalNewsStatus ==
                      NewsStatus.loaded &&
                  newsController.generalNews.isEmpty) {
                return const Center(child: Text('No news available.'));
              }

              // Tampilkan konten setelah data dimuat
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Featured carousel
                    SizedBox(
                      height: 320,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 320,
                          viewportFraction: 0.88,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: newsController.headlines.map((newsItem) {
                          return GestureDetector(
                            onTap: () {
                              if (newsItem.slug != null &&
                                  newsItem.slug!.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                      slug: newsItem.slug!,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Detail berita tidak tersedia (slug kosong).',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(25),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Background image
                                    (newsItem.featuredImageUrl != null &&
                                            newsItem
                                                .featuredImageUrl!.isNotEmpty)
                                        ? Image.network(
                                            newsItem.featuredImageUrl!,
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
                                          )
                                        : Container(
                                            // Placeholder jika tidak ada gambar
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey[500],
                                              size: 50,
                                            ),
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getCategoryColor(
                                                newsItem.category,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              newsItem.category.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // Title
                                          Text(
                                            newsItem.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),

                                          // Bottom info
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                newsItem.formattedDate,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withAlpha(180),
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                newsItem.authorName ?? 'Vartaa',
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // News list section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Berita Terbaru',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement "Lihat Semua" functionality
                                  print('Lihat Semua Berita Diklik!');
                                },
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
                          const SizedBox(height: 15),

                          // News cards
                          ...newsController.generalNews.map(
                            (newsItem) => NewsCard(newsItem: newsItem),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
