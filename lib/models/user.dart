/// Model untuk merepresentasikan data pengguna.
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? avatarUrl;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.avatarUrl,
    this.isActive = false,
  });

  /// Factory constructor untuk membuat instance [UserModel] dari JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    bool parsedIsActive = false;
    if (json['isActive'] is bool) {
      parsedIsActive = json['isActive'];
    } else if (json['isActive'] is String) {
      // Contoh: jika API mengirim "true" atau "false" sebagai string
      parsedIsActive = (json['isActive'] as String).toLowerCase() == 'true';
    } else if (json['isActive'] is int) {
      // Contoh: jika API mengirim 0 atau 1
      parsedIsActive = json['isActive'] == 1;
    }

    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['id'] ?? '',
      lastName: json['id'] ?? '',
      bio: json['id'] ?? '',
      avatarUrl: json['id'] ?? '',
      isActive: parsedIsActive,
    );
  }

  /// Mengonversi instance [UserModel] menjadi Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
    };
  }
}
