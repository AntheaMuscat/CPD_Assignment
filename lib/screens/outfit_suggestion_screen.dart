import 'package:flutter/material.dart';

class OutfitSuggestionScreen extends StatelessWidget {
  const OutfitSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Suggestions'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Today\'s Outfit Suggestions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: const [
                  _PlaceholderCard(label: 'Top'),
                  SizedBox(height: 16),
                  _PlaceholderCard(label: 'Bottom'),
                  SizedBox(height: 16),
                  Text('OR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _PlaceholderCard(label: 'Dress'),
                ]
              ),
            ),
            ElevatedButton(
              onPressed: null //will implement later
            , child: const Text('Generate Outfit')),
          ],
        )
      )
    );
  }

}

class _PlaceholderCard extends StatelessWidget {
  final String label;

  const _PlaceholderCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 120,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
