import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddMotoScreen extends StatefulWidget {
  const AddMotoScreen({super.key});

  @override
  State<AddMotoScreen> createState() => _AddMotoScreenState();
}

class _AddMotoScreenState extends State<AddMotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController motoTypeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? imageFile;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // Future<String> uploadImage(File file) async {
  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   final ref = FirebaseStorage.instance.ref().child('moto_images/$fileName');
  //   await ref.putFile(file);
  //   return await ref.getDownloadURL();
  // }

  Future<void> addMoto() async {
    if (_formKey.currentState!.validate()) {
      // String? imageUrl;
      // if (imageFile != null) {
      //   imageUrl = await uploadImage(imageFile!);
      // }

      await FirebaseFirestore.instance.collection('suppliers').add({
        'name': nameController.text,
        'motoType': motoTypeController.text,
        'model': modelController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'imageUrl':  '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Moto added successfully!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Moto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: motoTypeController,
                decoration: const InputDecoration(labelText: "Moto Type"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(labelText: "Model"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : const Center(child: Text("Tap to select image")),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: addMoto, child: const Text("Add Moto")),
            ],
          ),
        ),
      ),
    );
  }
}
