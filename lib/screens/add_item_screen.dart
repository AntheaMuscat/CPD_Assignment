import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/clothing_item.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AddItemScreen extends StatefulWidget{
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameField = TextEditingController();
  final _colorField = TextEditingController();
  String seclectedCategory = 'Tops';
  String seclectedSeason = 'Summer';
  File? _selectedImage;

  final List<String> categories = ['Tops', 'Trousers', 'Skirts', 'Dresses'];
  final List<String> seasons = ['Summer', 'Winter', 'Spring', 'Autumn', 'All'];

  final String _autoDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try{
      final XFile? image = await _picker.pickImage(source: source, preferredCameraDevice: CameraDevice.rear);
      if (image != null){
        final directory = await getApplicationDocumentsDirectory();
        final String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String imagePath = '${directory.path}/$imageName';

        await File(image.path).copy(imagePath);

        setState(() {
          _selectedImage = File(imagePath);
        });
      }
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red,),
      );
    }
  }

  void _pickImageSource(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Photo'),
        content: const Text('Take a new photo or choose from gallery?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera')
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery')
          ),
        ],
      )
    );
  }

  bool get _canSave =>
      _nameField.text.trim().isNotEmpty &&
      _colorField.text.trim().isNotEmpty &&
      _selectedImage != null;

  Future<void> _saveItem() async{
    final name = _nameField.text.trim();
    final color = _colorField.text.trim();

    if(name.isEmpty || color.isEmpty || _selectedImage == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image.'), backgroundColor: Colors.red,),
      );
      return;
    }

    final newItem = ClothingItem(
      name: name,
      color: color,
      dateAdded: _autoDate,
      category: seclectedCategory,
      season: seclectedSeason,
      imagePath: _selectedImage!.path,
    );

    final box = Hive.box<ClothingItem>('clothingItems');
    await box.add(newItem);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully!'), backgroundColor: Colors.green,),
      );
    }
  }

  @override
  Widget build(BuildContext contect){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothing Item'),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImageSource,
              child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedImage == null ? Colors.red : Colors.indigo,
                          width: _selectedImage == null ? 2 : 1,
                        ),
                      ),
                      child: _selectedImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 60, color: Colors.red),
                          SizedBox(height: 12),
                          Text(
                            'Photo is required!',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Tap to take photo with camera or pick from gallery'),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      ),
              )
            ),
            const SizedBox(height: 8),
            if(_selectedImage == null)
              const Text(
                'Please add a photo before saving the item.',
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameField,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _colorField,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date Added (automatic)'),
              subtitle: Text(_autoDate),
              leading: const Icon(Icons.calendar_today),
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: seclectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  seclectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: seclectedSeason,
              decoration: const InputDecoration(
                labelText: 'Season',
                border: OutlineInputBorder(),
              ),
              items: seasons.map((season) {
                return DropdownMenuItem<String>(
                  value: season,
                  child: Text(season),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  seclectedSeason = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _canSave ? _saveItem : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _canSave ? Colors.indigo[600] : Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Save Clothing Item',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameField.dispose();
    _colorField.dispose();
    super.dispose();
  }
}