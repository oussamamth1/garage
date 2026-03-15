import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:garage_management/src/widget/MotoTypeSelector.dart';

class AddMotoScreen extends ConsumerStatefulWidget {
  const AddMotoScreen({super.key});

  @override
  ConsumerState<AddMotoScreen> createState() => _AddMotoScreenState();
}

class _AddMotoScreenState extends ConsumerState<AddMotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String? selectedMotoType;
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
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      await FirebaseFirestore.instance.collection('suppliers').add({
        'name': nameController.text,
        'motoType': selectedMotoType ?? '',
        'model': modelController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'imageUrl': '',
        'sellerId': uid,
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
              const SizedBox(height: 16),
              MotoTypeSelector(
                value: selectedMotoType,
                onChanged: (v) => setState(() => selectedMotoType = v),
                labelText: "Moto Type",
                required: true,
              ),
              const SizedBox(height: 16),
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
