import 'package:flutter/material.dart';

class WardrobeHomeScreen extends StatefulWidget {
  const WardrobeHomeScreen({super.key});

  @override
  State<WardrobeHomeScreen> createState() => _WardrobeHomeScreenState();
}

class _WardrobeHomeScreenState extends State<WardrobeHomeScreen> {
  final List<String> categories = ['Tops', 'Trousers', 'Skirts', 'Dresses'];

  final List<Map<String, String>> clothingItems = [
{'name': 'Long Sleeve Shirt', 'color': 'Blue', 'date': '21/01/2025'},
    {'name': 'Short Sleeve Shirt', 'color': 'White', 'date': '21/01/2025'},
    {'name': 'Long Sleeve Shirt', 'color': 'White', 'date': '21/01/2025'},
    {'name': 'Long Sleeve Shirt', 'color': 'Grey', 'date': '21/01/2025'},
    {'name': 'White Trousers', 'color': 'Blue', 'date': '21/01/2025'},
    {'name': 'Brown Trousers', 'color': 'Brown', 'date': '21/01/2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe')
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
                  final items = clothingItems.where((item) {
                    switch (category) {
                      case 'Tops':
                        return item['name']!.contains('Shirt');
                      case 'Trousers':
                        return item['name']!.contains('Trousers');
                      case 'Skirts':
                        return item['name']!.contains('Skirt');
                      case 'Dresses':
                        return item['name']!.contains('Dress');
                      default:
                        return false;
                    }
                  }).toList();

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
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image, color: Colors.white, size: 40),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name']!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Color: ${item['color']}', style: Theme.of(context).textTheme.bodySmall),
                                  Text('Added: ${item['date']}', style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
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
          // TODO
        },
      ),
    );
  }
}
