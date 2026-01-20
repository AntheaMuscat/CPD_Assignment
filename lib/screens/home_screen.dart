import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/clothing_item.dart';
import 'add_item_screen.dart';
import 'dart:io';
import 'outfit_suggestion_screen.dart';

class WardrobeHomeScreen extends StatefulWidget {
  const WardrobeHomeScreen({super.key});

  @override
  State<WardrobeHomeScreen> createState() => _WardrobeHomeScreenState();
}

class _WardrobeHomeScreenState extends State<WardrobeHomeScreen> {
  late Box<ClothingItem> clothingBox;
  final List<String> categories = ['Tops', 'Trousers', 'Skirts', 'Dresses'];

  @override
  void initState() {
    super.initState();
    clothingBox = Hive.box<ClothingItem>('clothingItems');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
      ),
      body: DefaultTabController(
        length: categories.length,
        child: Column(
          children: [
            TabBar(
              tabs: categories
              .map((category) => Tab(text: category))
              .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: categories.map((category) {
                  final items = clothingBox.values.where((item) {
                    return item.category == category; 
                  }).toList();

                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No items in this category.'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( //Grid with fixed no of columns
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final key = clothingBox.keys.elementAt(clothingBox.values.toList().indexOf(item));
                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Item'),
                              content: Text(
                                'Are you sure you want to delete "${item.name}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    clothingBox.delete(key); // Delete from Hive
                                    Navigator.pop(context);
                                    setState(() {}); // Refresh grid
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Item deleted'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.blue[50],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                child:
                                    Image.file(
                                        File(item.imagePath),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.red,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                      )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo[800])),
                                  const SizedBox(height: 4),
                                  Text('Color: ${item.color}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.indigo[700])),
                                  Text('Added: ${item.dateAdded}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.indigo[700])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            label: 'Outfit Suggestions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.indigo[700],
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OutfitSuggestionScreen()),
            );
          } else
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            ).then((_) {
              setState(() {});
            });
          }
        },
      ),
    );
  }
}
