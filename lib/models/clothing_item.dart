import 'package:hive/hive.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
class ClothingItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String color;

  @HiveField(2)
  final String dateAdded;

  @HiveField(3)
  final String category;

  ClothingItem({
    required this.name,
    required this.color,
    required this.dateAdded,
    required this.category,
  });
}