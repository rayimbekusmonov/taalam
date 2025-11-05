import 'package:hive/hive.dart';

part 'category_model.g.dart'; // Hive generator uchun

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nameUz;

  @HiveField(2)
  final String nameAr;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final int order;

  @HiveField(5)
  final DateTime lastUpdated;

  Category({
    required this.id,
    required this.nameUz,
    required this.nameAr,
    required this.icon,
    required this.order,
    required this.lastUpdated,
  });

  // Firestore'dan JSON convert
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      nameUz: json['name_uz'] ?? '',
      nameAr: json['name_ar'] ?? '',
      icon: json['icon'] ?? '📚',
      order: json['order'] ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  // Firestore'ga JSON convert
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_uz': nameUz,
      'name_ar': nameAr,
      'icon': icon,
      'order': order,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Firestore Document snapshot'dan yaratish
  factory Category.fromFirestore(Map<String, dynamic> data) {
    return Category.fromJson(data);
  }

  // Copy with method (state update uchun)
  Category copyWith({
    String? id,
    String? nameUz,
    String? nameAr,
    String? icon,
    int? order,
    DateTime? lastUpdated,
  }) {
    return Category(
      id: id ?? this.id,
      nameUz: nameUz ?? this.nameUz,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, nameUz: $nameUz, nameAr: $nameAr)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}