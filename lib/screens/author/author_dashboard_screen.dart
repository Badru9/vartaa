// lib/screens/author/author_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; // Import PhosphorIcons
import 'package:vartaa/models/author_news_controller.dart';
// HAPUS BARIS INI: import 'package:vartaa/models/author_news_controller.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/screens/author/news_form_screen.dart';
import 'package:vartaa/utils/helper.dart'; // Untuk getCategoryColor, cPrimary, subtitle1, caption, dll.

class AuthorDashboardScreen extends StatefulWidget {
  const AuthorDashboardScreen({super.key});

  @override
  State<AuthorDashboardScreen> createState() => _AuthorDashboardScreenState();
}

class _AuthorDashboardScreenState extends State<AuthorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthorNewsController>(
        context,
        listen: false,
      ).fetchAuthorNews();
    });
  }

  Future<void> _refreshNews() async {
    await Provider.of<AuthorNewsController>(
      context,
      listen: false,
    ).fetchAuthorNews();
  }

  void _navigateToCreateNews() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewsFormScreen()))
        .then((result) {
          if (result == true) {
            _refreshNews();
          }
        });
  }

  void _navigateToEditNews(NewsArticle article) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => NewsFormScreen(article: article),
          ),
        )
        .then((result) {
          if (result == true) {
            _refreshNews();
          }
        });
  }

  Future<void> _confirmDelete(BuildContext context, NewsArticle article) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Konfirmasi Hapus',
              style: headline4.copyWith(
                fontWeight: bold,
                color: cBlack,
              ), // Menggunakan TextStyle dari helper
            ),
            content: Text(
              'Apakah Anda yakin ingin menghapus berita "${article.title}"?',
              style: subtitle1.copyWith(
                color: cTextBlue,
              ), // Menggunakan TextStyle dari helper
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'Batal',
                  style: subtitle2.copyWith(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                // Menggunakan ElevatedButton untuk aksi utama
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cError, // Warna merah untuk aksi hapus
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Hapus',
                  style: subtitle2.copyWith(color: cWhite, fontWeight: bold),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await Provider.of<AuthorNewsController>(
        context,
        listen: false,
      ).deleteNews(article.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berita berhasil dihapus',
              style: subtitle2.copyWith(color: cWhite),
            ),
            backgroundColor: cSuccess,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus berita: ${Provider.of<AuthorNewsController>(context, listen: false).errorMessage}',
              style: subtitle2.copyWith(color: cWhite),
            ),
            backgroundColor: cError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cSmokeWhite, // Background cerah sesuai keinginan
      appBar: AppBar(
        title: Text(
          'Kelola Berita Saya', // Judul lebih jelas
          style: headline4.copyWith(fontWeight: bold, color: cBlack),
        ),
        backgroundColor: cWhite,
        elevation: 1, // Shadow halus
        centerTitle: true, // Pusatkan judul
        actions: [
          IconButton(
            icon: PhosphorIcon(
              PhosphorIcons.plusCircle(PhosphorIconsStyle.regular),
            ), // Ikon tambah yang lebih modern
            color: cPrimary, // Warna primary untuk ikon
            onPressed: _navigateToCreateNews,
            tooltip: 'Tambah Berita Baru',
          ),
          const SizedBox(width: 8), // Sedikit spasi
        ],
      ),
      body: Consumer<AuthorNewsController>(
        builder: (context, controller, child) {
          if (controller.status == AuthorNewsStatus.loading &&
              controller.authorArticles.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: cPrimary,
              ), // Warna primary
            );
          } else if (controller.status == AuthorNewsStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: cError,
                      size: 48,
                    ), // Ikon error
                    vsMedium, // Menggunakan vsMedium dari helper
                    Text(
                      'Terjadi kesalahan: ${controller.errorMessage}\nKetuk untuk refresh.',
                      textAlign: TextAlign.center,
                      style: subtitle1.copyWith(color: cTextBlue),
                    ),
                    vsMedium, // Menggunakan vsMedium dari helper
                    ElevatedButton(
                      onPressed: _refreshNews,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Coba Lagi',
                        style: subtitle1.copyWith(
                          color: cWhite,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (controller.authorArticles.isEmpty &&
              controller.status == AuthorNewsStatus.loaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.fileText(PhosphorIconsStyle.light),
                      size: 60,
                      color: Colors.grey,
                    ),
                    vsMedium, // Menggunakan vsMedium dari helper
                    Text(
                      'Anda belum membuat berita apa pun.\nBuat berita pertama Anda sekarang!',
                      textAlign: TextAlign.center,
                      style: headline4.copyWith(
                        color: cTextBlue,
                        fontWeight: medium,
                      ),
                    ),
                    vsLarge, // Menggunakan vsLarge dari helper
                    ElevatedButton.icon(
                      onPressed: _navigateToCreateNews,
                      icon: Icon(Icons.add, color: cWhite),
                      label: Text(
                        'Buat Berita Baru',
                        style: subtitle1.copyWith(
                          color: cWhite,
                          fontWeight: bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshNews,
            color: cPrimary, // Warna indicator refresh
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount:
                  controller.authorArticles.length +
                  (controller.status == AuthorNewsStatus.loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.authorArticles.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: cPrimary,
                      ), // Loading more indicator
                    ),
                  );
                }

                final article = controller.authorArticles[index];
                return GestureDetector(
                  // Membuat seluruh card bisa diklik
                  onTap:
                      () =>
                          _navigateToEditNews(article), // Klik card untuk edit
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 4, // Shadow lebih dalam
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: cWhite, // Background card putih
                    child: Padding(
                      padding: const EdgeInsets.all(
                        16.0,
                      ), // Padding lebih besar
                      child: Column(
                        // Gunakan Column untuk struktur vertikal
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar Berita
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    (article.featuredImageUrl != null &&
                                            article
                                                .featuredImageUrl!
                                                .isNotEmpty)
                                        ? Image.network(
                                          article.featuredImageUrl!,
                                          width:
                                              100, // Ukuran gambar lebih besar
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: cGrey,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey[400],
                                                size: 30,
                                              ),
                                            );
                                          },
                                        )
                                        : Container(
                                          width: 100,
                                          height: 100,
                                          color: cGrey,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey[400],
                                            size: 30,
                                          ),
                                        ),
                              ),
                              hsMedium, // Spasi horizontal medium
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getCategoryColor(
                                          article.category,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        article.category,
                                        style: caption.copyWith(
                                          color: cWhite,
                                          fontWeight: medium,
                                        ), // Style caption
                                      ),
                                    ),
                                    vsSmall,
                                    // Judul Berita
                                    Text(
                                      article.title,
                                      style: subtitle1.copyWith(
                                        fontWeight: bold,
                                        color: cTextBlue,
                                      ), // Style subtitle1
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    vsTiny,
                                    Text(
                                      article.summary ??
                                          article.content.substring(
                                            0,
                                            article.content.length.clamp(0, 70),
                                          ), // Summary atau potongan content
                                      style: caption.copyWith(
                                        color: Colors.grey[600],
                                      ), // Style caption
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    vsSmall, // Spasi vertikal kecil
                                    // Kategori dan Tanggal
                                    // Spasi horizontal kecil
                                    Text(
                                      article.formattedDate,
                                      style: caption.copyWith(
                                        color: Colors.grey[500],
                                      ), // Style caption
                                    ),
                                    vsSmall, // Spasi vertikal kecil
                                    // Status Draft/Published
                                    Row(
                                      children: [
                                        Icon(
                                          article.isPublished
                                              ? PhosphorIcons.checkCircle(
                                                PhosphorIconsStyle.fill,
                                              )
                                              : PhosphorIcons.clockCounterClockwise(
                                                PhosphorIconsStyle.regular,
                                              ),
                                          color:
                                              article.isPublished
                                                  ? cSuccess
                                                  : cPrimary,
                                          size: 16,
                                        ),
                                        hsTiny,
                                        Text(
                                          article.isPublished
                                              ? 'Published'
                                              : 'Draft',
                                          style: caption.copyWith(
                                            color:
                                                article.isPublished
                                                    ? cSuccess
                                                    : cPrimary,
                                            fontWeight: medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          vsMedium, // Spasi sebelum tombol aksi
                          // Tombol Aksi (Edit & Delete)
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // Tombol di kanan
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _navigateToEditNews(article),
                                icon: Icon(Icons.edit, size: 18, color: cBlack),
                                label: Text(
                                  'Edit',
                                  style: caption.copyWith(
                                    color: cBlack,
                                    fontWeight: bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors
                                          .grey[200], // Background abu-abu muda
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                              hsSmall, // Spasi antara tombol
                              ElevatedButton.icon(
                                onPressed:
                                    () => _confirmDelete(context, article),
                                icon: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: cWhite,
                                ),
                                label: Text(
                                  'Hapus',
                                  style: caption.copyWith(
                                    color: cWhite,
                                    fontWeight: bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      cError, // Warna merah untuk hapus
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
