// lib/models/author_model.dart
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show UniqueKey;

class Author {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? avatarUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Author({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.avatarUrl,
    this.isActive = false, // Default value, but prefer to parse from API
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory Author.fromJson(Map<String, dynamic> json) {
    bool parsedIsActive = false;
    // Handle parsing isActive, as it might come in various types
    if (json['isActive'] is bool) {
      parsedIsActive = json['isActive'];
    } else if (json['isActive'] is String) {
      parsedIsActive = (json['isActive'] as String).toLowerCase() == 'true';
    } else if (json['isActive'] is int) {
      parsedIsActive = json['isActive'] == 1;
    }

    DateTime? parseDate(dynamic dateValue) {
      // Accept dynamic to handle null or non-string values gracefully
      if (dateValue == null) return null;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          print('Error parsing date string: $dateValue, $e');
          return null;
        }
      }
      return null;
    }

    return Author(
      id:
          json['id'] as String? ??
          UniqueKey()
              .toString(), // Use UniqueKey as a fallback ID if API doesn't provide
      email: json['email'] as String? ?? '',
      firstName: json['firstname'] as String? ?? '',
      lastName: json['lastname'] as String? ?? '',
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isActive: parsedIsActive,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
