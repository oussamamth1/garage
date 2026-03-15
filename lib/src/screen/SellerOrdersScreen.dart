import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:garage_management/src/model/item_order.dart';
import 'package:garage_management/src/provider/ordersProvider.dart';
import 'package:garage_management/src/screen/ChatScreen.dart';

class SellerOrdersScreen extends ConsumerWidget {
  const SellerOrdersScreen({super.key});

  Future<String> _getBuyerName(String clientId) async {
    if (clientId.isEmpty) return 'Buyer';
    final doc = await FirebaseFirestore.instance.collection('users').doc(clientId).get();
    if (!doc.exists) return 'Buyer';
    final d = doc.data()!;
    final first = d['firstName'] ?? '';
    final last = d['lastName'] ?? '';
    return '$first $last'.trim().isEmpty ? (d['email'] ?? 'Buyer') : '$first $last'.trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Sales")),
        body: const Center(child: Text("Please log in to see your sales")),
      );
    }

    final ordersAsync = ref.watch(sellerOrdersProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Sales"),
        elevation: 0,
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No sales yet",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Orders from buyers will appear here",
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
                future: _getBuyerName(order.clientId),
                builder: (context, nameSnap) {
                  final buyerName = nameSnap.data ?? 'Buyer';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_bag, size: 40, color: Colors.green),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text("Buyer: $buyerName", style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                    Text(
                                      "Qty: ${order.quantity} • ${order.totalPrice.toStringAsFixed(2)} OMR",
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    if (dateStr.isNotEmpty)
                                      Text(dateStr, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chat),
                                tooltip: 'Chat with buyer',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        bookingId: order.id,
                                        otherPartyName: buyerName,
                                        currentUserId: user.uid,
                                        clientId: order.clientId,
                                        technicianId: order.sellerId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text("Status:", style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: order.status,
                                items: const [
                                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                                  DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                                  DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
                                  DropdownMenuItem(value: 'completed', child: Text('Completed')),
                                  DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                                ],
                                onChanged: (newStatus) async {
                                  if (newStatus == null) return;
                                  await updateOrderStatus(order.id, newStatus);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Status: $newStatus')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
