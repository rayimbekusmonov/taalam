import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class Word extends HiveObject {
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
  final String audioUrl;

  Word({
    required this.id,
    required this.categoryId,
    required this.arabic,
    required this.transliteration,
    required this.uzbek,
    required this.audioUrl,
  });
}
