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
  final String uzbek;

  @HiveField(5)
  final String english;

  @HiveField(6)
  final String? audioUrl;

  @HiveField(7)
  final String? imageUrl;

  @HiveField(8)
  final String? emoji;

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
    required this.uzbek,
    required this.english,
    this.audioUrl,
    this.imageUrl,
    this.emoji,
    this.difficulty = 'easy',
    required this.lastUpdated,
    this.isFavorite = false,
    this.isLearned = false,
  });

  Word copyWith({
    String? id,
    String? categoryId,
    String? arabic,
    String? transliteration,
    String? uzbek,
    String? english,
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
      uzbek: uzbek ?? this.uzbek,
      english: english ?? this.english,
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
    return 'Word(id: $id, arabic: $arabic, uzbek: $uzbek)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
