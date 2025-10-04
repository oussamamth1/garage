// lib/screens/sales_order_screen.dart
import 'package:flutter/material.dart';
import 'package:garage_management/src/models/sales_order_model.dart';

import '../widgets/chat_button.dart';

class SalesOrderScreen extends StatelessWidget {
  final SalesOrderModel order;
  final String customerId;

  const SalesOrderScreen({
    Key? key,
    required this.order,
    required this.customerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.itemName),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                      '\$${item.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Chat button for order inquiries
                ChatButton(
                  orderId: order.id,
                  customerId: customerId,
                  buttonText: 'Chat about this order',
                  icon: Icons.chat_bubble_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
