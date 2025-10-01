import 'package:flutter/material.dart';
import 'package:garage_management/src/model/supplierItem.dart';

import 'package:garage_management/src/screen/BuyItemScreen.dart';

class MotoCard extends StatelessWidget {
  final SupplierItem item;

  const MotoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        onTap: () {
          // Open BuyItemScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BuyItemScreen(item: item)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: Image.network(
              //     item.imageUrl,
              //     width: 30,
              //     height: 30,
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item.motoType} - ${item.model}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuyItemScreen(item: item),
                    ),
                  );
                },
                child: const Text("pick your suppliersItems"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
