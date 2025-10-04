// lib/models/sales_order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum SalesOrderStatus { pending, paid, delivered, cancelled }

class SalesOrderItem {
  final String itemId;
  final String itemName;
  final int quantity;
  final double unitPrice;

  SalesOrderItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  factory SalesOrderItem.fromMap(Map<String, dynamic> map) {
    return SalesOrderItem(
      itemId: map['itemId'] ?? '',
      itemName: map['itemName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: map['unitPrice']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}

class SalesOrderModel {
  final String id;
  final String customerId;
  final List<SalesOrderItem> items;
  final double totalAmount;
  final SalesOrderStatus status;
  final DateTime createdAt;
  final String? invoiceId;

  SalesOrderModel({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.invoiceId,
  });

  factory SalesOrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SalesOrderModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      items: (data['items'] as List? ?? [])
          .map((i) => SalesOrderItem.fromMap(i as Map<String, dynamic>))
          .toList(),
      totalAmount: data['totalAmount']?.toDouble() ?? 0.0,
      status: SalesOrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => SalesOrderStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      invoiceId: data['invoiceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'items': items.map((i) => i.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'invoiceId': invoiceId,
    };
  }
}
