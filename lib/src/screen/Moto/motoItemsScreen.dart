import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/service.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/screen/BookingScreen.dart';
class MotoItemsScreen extends StatelessWidget {
  final String motoType;

  const MotoItemsScreen({super.key, required this.motoType});

  Stream<List<SupplierItem>> _getItems() {
    return FirebaseFirestore.instance
        .collection("suppliersItems")
        .where("motoType", isEqualTo: motoType)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SupplierItem.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$motoType Items")),
      body: StreamBuilder<List<SupplierItem>>(
        stream: _getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(
              child: Text("No items found for this moto type"),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.network(item.imageUrl, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(item.model),
                    Text(
                      "\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
