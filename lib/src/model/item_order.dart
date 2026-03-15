import 'package:cloud_firestore/cloud_firestore.dart';

/// Top-level order (buyer + seller); used for item purchases.
class ItemOrder {
  final String id;
  final String clientId;
  final String sellerId;
  final String itemId;
  final String itemName;
  final int quantity;
  final double price;
  final double totalPrice;
  final String status; // pending, confirmed, shipped, completed, cancelled
  final DateTime? createdAt;

  ItemOrder({
    required this.id,
    required this.clientId,
    required this.sellerId,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.status,
    this.createdAt,
  });

  factory ItemOrder.fromFirestore(Map<String, dynamic> data, String id) {
    return ItemOrder(
      id: id,
      clientId: data['clientId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      quantity: ((data['quantity'] ?? 1) is int) ? (data['quantity'] as int) : (data['quantity'] as num).toInt(),
      price: (data['price'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
