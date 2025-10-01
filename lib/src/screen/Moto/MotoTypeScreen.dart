import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/service.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/screen/BookingScreen.dart';
import 'package:garage_management/src/screen/Moto/motoItemsScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MotoTypeScreen extends StatefulWidget {
  const MotoTypeScreen({super.key});

  @override
  State<MotoTypeScreen> createState() => _MotoTypeScreenState();
}

class _MotoTypeScreenState extends State<MotoTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String? _selectedSupplierId; // stores supplierId
  String? _selectedSupplierName; // stores supplier name

  Future<void> _addItem() async {
    if (!_formKey.currentState!.validate() || _selectedSupplierName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    await FirebaseFirestore.instance.collection("suppliersItems").add({
      "name": _nameController.text.trim(),
      "motoType": _selectedSupplierName, // store supplier name as motoType
      "model": _modelController.text.trim(),
      "price": double.tryParse(_priceController.text.trim()) ?? 0,
      "imageUrl": _imageUrlController.text.trim(),
      "supplierId": _selectedSupplierId, // reference supplier
      "createdAt": FieldValue.serverTimestamp(),
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item added successfully")));
    }
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Moto Item"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Supplier Dropdown
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("suppliers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final suppliers = snapshot.data!.docs;
                    return DropdownButtonFormField<String>(
                      value: _selectedSupplierId,
                      decoration: const InputDecoration(
                        labelText: "Select Supplier",
                      ),
                      items: suppliers.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final supplierName = data['name'] ?? 'Unknown';
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(supplierName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierId = value;
                          _selectedSupplierName = suppliers
                              .firstWhere((doc) => doc.id == value)
                              .get("name");
                        });
                      },
                      validator: (v) =>
                          v == null ? "Please select a supplier" : null,
                    );
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Item Name"),
                  validator: (v) => v!.isEmpty ? "Enter item name" : null,
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(labelText: "Model"),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(onPressed: _addItem, child: const Text("Save")),
        ],
      ),
    );
  }

  Future<List<String>> getMotoTypes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("suppliersItems")
        .get();

    return snapshot.docs
        .map((doc) => doc["motoType"] as String)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Moto Type")),
      body: FutureBuilder<List<String>>(
        future: getMotoTypes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final motoTypes = snapshot.data!;
          return ListView.builder(
            itemCount: motoTypes.length,
            itemBuilder: (context, index) {
              final type = motoTypes[index];
              return ListTile(
                leading: const Icon(Icons.motorcycle, color: Colors.blue),
                title: Text(type),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MotoItemsScreen(motoType: type),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
