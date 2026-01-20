import 'package:flutter/material.dart';
import '../../models/clothing_item.dart';
import 'dart:math';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class OutfitSuggestionScreen extends StatefulWidget {
  const OutfitSuggestionScreen({super.key});

  @override
  State<OutfitSuggestionScreen> createState() => _OutfitSuggestionScreenState();
}
class _OutfitSuggestionScreenState extends State<OutfitSuggestionScreen> {
  ClothingItem? selectedTop;
  ClothingItem? selectedBottom;
  ClothingItem? selectedDress;

  void _generateOutfit(){
    final box = Hive.box<ClothingItem>('clothingItems');
    final items = box.values.toList();

    final tops = items.where((item)=> item.category == 'Tops').toList();
    final bottoms = items.where((item)=> item.category == 'Trousers' || item.category == 'Skirts').toList();
    final dresses = items.where((item)=> item.category == 'Dresses').toList();

    final random = Random();
    final useDress = random.nextBool();

    setState(() {
      selectedTop = null;
      selectedBottom = null;
      selectedDress = null;

      if (useDress && dresses.isNotEmpty) {
        selectedDress = dresses[random.nextInt(dresses.length)];
      } else if(tops.isNotEmpty && bottoms.isNotEmpty) {
          selectedTop = tops[random.nextInt(tops.length)];
          selectedBottom = bottoms[random.nextInt(bottoms.length)];
      }
    });
  }

  Widget _buildSuggestionCard({
    required String label,
    ClothingItem? item,
  }){
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 180,
        child: Column(
          children: [
            Expanded(
              child: item != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.file(
                        File(item.imagePath),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        color: Colors.blue[100],
                      ),
                      child: const Icon(Icons.image, size: 80, color: Colors.indigo),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                item?.name ?? label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
            )
          ]
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Suggestions'),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Today\'s Outfit Suggestions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Generate an outfit based on items in your wardrobe.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.indigo),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSuggestionCard(label: 'Top', item: selectedTop),
                    const SizedBox(height: 16),
                    _buildSuggestionCard(label: 'Bottom', item: selectedBottom),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSuggestionCard(label: 'Dress', item: selectedDress),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateOutfit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.indigo[700],
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Generate Outfit',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
