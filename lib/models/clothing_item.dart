import 'package:hive/hive.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
class ClothingItem {
  @HiveField(0)
  String name;

  @HiveField(1)
  String color;

  @HiveField(2)
  String dateAdded;

  @HiveField(3)
  String category;

  @HiveField(4)
  String season;

  @HiveField(5)
  String imagePath;

  ClothingItem({
    required this.name,
    required this.color,
    required this.dateAdded,
    required this.category,
    required this.season,
    required this.imagePath,
  });
}