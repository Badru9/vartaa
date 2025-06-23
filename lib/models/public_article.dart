// ignore_for_file: public_member_api_docs, sort_constructors_first

class PublicArticle {
  String id;
  String? title;
  String? slug;
  String? summary;
  String? content;
  String? featuredImageUrl;
  String category;
  List<String> tags;
  String? publishedAt;
  int viewCount;
  DateTime createdAt;
  DateTime updatedAt;
  String? authorName;
  String? authorBio;
  String? authorAvatar;

  PublicArticle({
    required this.id,
    this.title,
    this.slug,
    this.summary,
    this.content,
    this.featuredImageUrl,
    required this.category,
    required this.tags,
    this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    this.authorName,
    this.authorBio,
    this.authorAvatar,
  });

  factory PublicArticle.fromJson(Map<String, dynamic> json) {
    return PublicArticle(
      id: json['id'] ?? '',
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'],
      content: json['content'],
      featuredImageUrl: json['featured_image_url'],
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      publishedAt: json['published_at'],
      viewCount: json['view_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      authorName: json['author_name'],
      authorBio: json['author_bio'],
      authorAvatar: json['author_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'category': category,
      'tags': tags,
      'published_at': publishedAt,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author_name': authorName,
      'author_bio': authorBio,
      'author_avatar': authorAvatar,
    };
  }

  // Helper method untuk mendapatkan nama author dengan fallback
  String get displayAuthorName => authorName ?? 'Unknown Author';

  // Helper method untuk check apakah author memiliki avatar
  bool get hasAuthorAvatar => authorAvatar != null && authorAvatar!.isNotEmpty;
}
