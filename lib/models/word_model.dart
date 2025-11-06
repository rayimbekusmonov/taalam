import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class Word {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final String arabic;

  @HiveField(3)
  final String transliteration;

  @HiveField(4)
  final String meaningUz;

  @HiveField(5)
  final String meaningEn;

  @HiveField(6)
  final String? audioUrl; // Optional qilamiz

  @HiveField(7)
  final String? imageUrl; // Optional qilamiz

  @HiveField(8)
  final String? emoji; // Emoji uchun alohida field

  @HiveField(9)
  final String difficulty;

  @HiveField(10)
  final DateTime lastUpdated;

  @HiveField(11)
  bool isFavorite;

  @HiveField(12)
  bool isLearned;

  Word({
    required this.id,
    required this.categoryId,
    required this.arabic,
    required this.transliteration,
    required this.meaningUz,
    required this.meaningEn,
    this.audioUrl,
    this.imageUrl,
    this.emoji,
    this.difficulty = 'easy',
    required this.lastUpdated,
    this.isFavorite = false,
    this.isLearned = false,
  });

  // Firestore'dan JSON convert
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaningUz: json['meaning_uz'] ?? '',
      meaningEn: json['meaning_en'] ?? '',
      audioUrl: json['audio_url'],
      imageUrl: json['image_url'],
      emoji: json['emoji'],
      difficulty: json['difficulty'] ?? 'easy',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isFavorite: json['isFavorite'] ?? false,
      isLearned: json['isLearned'] ?? false,
    );
  }

  // Firestore'ga JSON convert
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'arabic': arabic,
      'transliteration': transliteration,
      'meaning_uz': meaningUz,
      'meaning_en': meaningEn,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'emoji': emoji,
      'difficulty': difficulty,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Firestore Document snapshot'dan yaratish
  factory Word.fromFirestore(Map<String, dynamic> data) {
    return Word.fromJson(data);
  }

  // Copy with method
  Word copyWith({
    String? id,
    String? categoryId,
    String? arabic,
    String? transliteration,
    String? meaningUz,
    String? meaningEn,
    String? audioUrl,
    String? imageUrl,
    String? emoji,
    String? difficulty,
    DateTime? lastUpdated,
    bool? isFavorite,
    bool? isLearned,
  }) {
    return Word(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      meaningUz: meaningUz ?? this.meaningUz,
      meaningEn: meaningEn ?? this.meaningEn,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      emoji: emoji ?? this.emoji,
      difficulty: difficulty ?? this.difficulty,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFavorite: isFavorite ?? this.isFavorite,
      isLearned: isLearned ?? this.isLearned,
    );
  }

  @override
  String toString() {
    return 'Word(id: $id, arabic: $arabic, meaningUz: $meaningUz)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}