import 'package:hive/hive.dart';

part 'user_progress_model.g.dart';

@HiveType(typeId: 2)
class UserProgress extends HiveObject {
  @HiveField(0)
  final String wordId;

  @HiveField(1)
  final bool isKnown;

  UserProgress({required this.wordId, required this.isKnown});
}
