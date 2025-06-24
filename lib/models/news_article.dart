// lib/models/news_article.dart
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show UniqueKey;

class NewsArticle {
  final String id;
  final String title;
  final String? summary; // Menggunakan summary sebagai description
  final String content; // Konten lengkap berita
  final String? featuredImageUrl; // Nama field di API
  final String category;
  final List<String> tags; // List of strings
  final bool isPublished; // Status publish
  final DateTime publishedAt;
  final String? authorName; // Nama penulis dari API
  final String? slug;
  final int? viewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? url; // Jika ada URL artikel di luar

  NewsArticle({
    required this.id,
    required this.title,
    this.summary,
    required this.content,
    this.featuredImageUrl,
    required this.category,
    this.tags = const [],
    this.isPublished = false,
    required this.publishedAt,
    this.authorName,
    this.slug,
    this.viewCount,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // Pastikan casting aman dan berikan nilai default jika null
    final String id = json['id'] as String? ?? UniqueKey().toString();
    final String title = json['title'] as String? ?? 'No Title';
    final String content = json['content'] as String? ?? 'No Content';
    final String category = json['category'] as String? ?? 'General';
    final String featuredImageUrl = json['featured_image_url'] as String? ?? '';
    final String authorName = json['author_name'] as String? ?? 'Unknown';
    final String summary = json['summary'] as String? ?? '';
    final List<String> tags =
        (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

    DateTime publishedAt;
    try {
      publishedAt = DateTime.parse(json['published_at'] as String);
    } catch (e) {
      publishedAt = DateTime.now(); // Fallback jika parsing tanggal gagal
      print('Error parsing published_at: $e, value: ${json['published_at']}');
    }

    DateTime? createdAt;
    try {
      createdAt = DateTime.tryParse(json['created_at'] as String? ?? '');
    } catch (e) {
      print('Error parsing created_at: $e, value: ${json['created_at']}');
    }

    DateTime? updatedAt;
    try {
      updatedAt = DateTime.tryParse(json['updated_at'] as String? ?? '');
    } catch (e) {
      print('Error parsing updated_at: $e, value: ${json['updated_at']}');
    }

    return NewsArticle(
      id: id,
      title: title,
      summary:
          summary.isNotEmpty
              ? summary
              : content.substring(
                0,
                content.length.clamp(0, 100),
              ), // summary atau potongan content
      content: content,
      featuredImageUrl:
          featuredImageUrl.isNotEmpty &&
                  (featuredImageUrl.startsWith('http') ||
                      featuredImageUrl.startsWith('https'))
              ? featuredImageUrl
              : 'https://via.placeholder.com/150', // Fallback image
      category: category,
      tags: tags,
      isPublished: json['isPublished'] as bool? ?? false,
      publishedAt: publishedAt,
      authorName: authorName,
      slug: json['slug'] as String?,
      viewCount: json['view_count'] as int?,
      createdAt: createdAt,
      updatedAt: updatedAt,
      url: null, // Asumsi tidak ada URL spesifik di API ini
    );
  }

  String get formattedDate {
    return DateFormat(
      'dd MMM yyyy HH:mm',
    ).format(publishedAt.toLocal()); // Tambah jam juga
  }
}
