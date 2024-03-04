import 'package:get/get.dart';

class Trainer {
  final String id;
  final String name;
  final String profileImageUrl;
  final String? bio;
  final List<String> category;
  final List languages;
  final String gender;
  final String? firebaseToken;
  bool isSaved;
  double? rating;

  Trainer({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.category,
    required this.gender,
    required this.languages,
    this.isSaved = false,
    required this.bio,
    this.firebaseToken,
    this.rating,
  });

  factory Trainer.fromMap(Map<String, dynamic> map) {
    List<String> translatedCategories = [];

    if (map['categories'] != null) {
      List<String> arabicCategories = List<String>.from(map['categories']);
      for (String category in arabicCategories) {
        var i = category.tr;
        translatedCategories.add(i);
      }
    }
    return Trainer(
      id: map['id'],
      name: map['name'],
      profileImageUrl: map['profileImageUrl'],
      category: translatedCategories,
      gender: map['gender'] ?? '',
      languages: map['languages'] ?? [],
      firebaseToken: map['firebaseToken'] ?? '',
      bio: map['bio'] ?? '',
    );
  }
}
