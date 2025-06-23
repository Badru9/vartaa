// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vartaa/models/author.dart';

class AuthorArticle {
  String id;
  String? title;
  String? slug;
  String? summary;
  String? content;
  String? featuredImageUrl;
  Author authorId;
  String category;
  List<String> tags;
  bool isPublished;
  String? publishedAt;
  int viewCount;
  DateTime createdAt;
  DateTime updatedAt;

  AuthorArticle({
    required this.id,
    this.title,
    this.slug,
    this.summary,
    this.content,
    this.featuredImageUrl,
    required this.authorId,
    required this.category,
    required this.tags,
    required this.isPublished,
    this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthorArticle.fromJson(Map<String, dynamic> json) {
    return AuthorArticle(
      id: json['id'] ?? '',
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'],
      content: json['content'],
      featuredImageUrl: json['featured_image_url'],
      authorId: Author.fromJson(
        json['author'] ?? {},
      ), // Asumsi Author memiliki fromJson
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      isPublished: json['is_published'] ?? false,
      publishedAt: json['published_at'],
      viewCount: json['view_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'author': authorId.toJson(), // Asumsi Author memiliki toJson
      'category': category,
      'tags': tags,
      'is_published': isPublished,
      'published_at': publishedAt,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
