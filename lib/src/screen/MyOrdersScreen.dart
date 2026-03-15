import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:garage_management/src/model/item_order.dart';
import 'package:garage_management/src/provider/ordersProvider.dart';
import 'package:garage_management/src/screen/ChatScreen.dart';

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  Future<String> _getSellerName(String sellerId) async {
    if (sellerId.isEmpty) return 'Seller';
    final doc = await FirebaseFirestore.instance.collection('users').doc(sellerId).get();
    if (!doc.exists) return 'Seller';
    final d = doc.data()!;
    final first = d['firstName'] ?? '';
    final last = d['lastName'] ?? '';
    return '$first $last'.trim().isEmpty ? (d['email'] ?? 'Seller') : '$first $last'.trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Orders")),
        body: const Center(child: Text("Please log in to see your orders")),
      );
    }

    final ordersAsync = ref.watch(clientOrdersProvider(user.uid));

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), elevation: 0),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Items you buy from Moto Items will appear here",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final dateStr = order.createdAt != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
                  : '';
              return FutureBuilder<String>(
                future: _getSellerName(order.sellerId),
                builder: (context, nameSnap) {
                  final sellerName = nameSnap.data ?? 'Seller';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.shopping_cart, size: 40, color: Colors.blue),
                      title: Text(
                        order.itemName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("Sold by: $sellerName"),
                          Text("Qty: ${order.quantity} • ${order.totalPrice.toStringAsFixed(2)} OMR"),
                          if (dateStr.isNotEmpty)
                            Text(dateStr, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(order.status, style: const TextStyle(fontSize: 12)),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: _statusColor(order.status),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chat),
                        tooltip: 'Chat with seller',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                bookingId: order.id,
                                otherPartyName: sellerName,
                                currentUserId: user.uid,
                                clientId: order.clientId,
                                technicianId: order.sellerId,
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () => _showOrderDetails(context, order),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade100;
      case 'confirmed':
      case 'shipped':
        return Colors.blue.shade100;
      case 'completed':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  void _showOrderDetails(BuildContext context, ItemOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(order.itemName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("Item", order.itemName),
              _detailRow("Quantity", "${order.quantity}"),
              _detailRow("Unit price", "${order.price.toStringAsFixed(2)} OMR"),
              _detailRow("Total", "${order.totalPrice.toStringAsFixed(2)} OMR"),
              _detailRow("Status", order.status),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
