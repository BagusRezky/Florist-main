import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddFlower extends StatefulWidget {
  const AddFlower({super.key});

  @override
  State<AddFlower> createState() => _AddFlowerState();
}

class _AddFlowerState extends State<AddFlower> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final permission = await Permission.camera;
    if (await permission.isDenied) {
      await permission.request();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String name = _nameController.text;
      String description = _descriptionController.text;
      double price = double.tryParse(_priceController.text) ?? 0.0;
      int stock = int.tryParse(_stockController.text) ?? 0;

      String imageUrl = await _uploadImage(); // Upload image and get URL

      // Save flower data to Firestore
      await FirebaseFirestore.instance.collection('flowers').add({
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'image': imageUrl, // Image path
      });

      // Clear the form after submission
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _stockController.clear();
      setState(() {
        _imageFile = null;
      });

      // Optionally show a success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Flower added successfully")));
    }
  }

  // Upload image and get image URL (or path)
  Future<String> _uploadImage() async {
    if (_imageFile != null) {
      // Get the app's temporary directory
      Directory appDocDir = await getTemporaryDirectory();

      // Create a new file path within the app's temporary directory
      String fileName = path.basename(_imageFile!.path);
      String localFilePath = '${appDocDir.path}/$fileName';

      // Copy the picked image to the new location
      File newImage = await _imageFile!.copy(localFilePath);

      // Return the local file path
      return newImage.path;
    } else {
      // Return a default image path if no image is selected
      return 'No image selected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flower')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Flower Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter flower name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile == null
                      ? Center(child: Icon(Icons.camera_alt, size: 50))
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Flower'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
