// Example 4: Product/Item Details Screen with Chat
// lib/screens/item_details_screen.dart
import 'package:flutter/material.dart';
import 'package:garage_management/src/models/inventory_model.dart';

import '../widgets/chat_button.dart';

class ItemDetailsScreen extends StatelessWidget {
  final InventoryItem item;
  final String customerId;

  const ItemDetailsScreen({
    Key? key,
    required this.item,
    required this.customerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(
                Icons.inventory_2,
                size: 100,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description ?? 'No description available',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${item.sellingPrice?.toStringAsFixed(2) ?? item.unitPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stock: ${item.stockQty} available',
                    style: TextStyle(
                      color: item.stockQty > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: item.stockQty > 0
                              ? () {
                                  // Add to cart logic
                                }
                              : null,
                          child: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat button for item inquiry
                      ChatButton(
                        serviceType: 'Product: ${item.name}',
                        customerId: customerId,
                        buttonText: 'Ask',
                        icon: Icons.help_outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
