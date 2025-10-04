// lib/models/inventory_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String? description;
  final String category;
  final int stockQty;
  final int reorderLevel;
  final double unitPrice;
  final double? sellingPrice;
  final bool availableForSale;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.stockQty,
    required this.reorderLevel,
    required this.unitPrice,
    this.sellingPrice,
    this.availableForSale = false,
    required this.createdAt,
    this.lastUpdated,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      category: data['category'] ?? '',
      stockQty: data['stockQty'] ?? 0,
      reorderLevel: data['reorderLevel'] ?? 0,
      unitPrice: data['unitPrice']?.toDouble() ?? 0.0,
      sellingPrice: data['sellingPrice']?.toDouble(),
      availableForSale: data['availableForSale'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'stockQty': stockQty,
      'reorderLevel': reorderLevel,
      'unitPrice': unitPrice,
      'sellingPrice': sellingPrice,
      'availableForSale': availableForSale,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': lastUpdated != null
          ? Timestamp.fromDate(lastUpdated!)
          : null,
    };
  }

  bool get needsReorder => stockQty <= reorderLevel;
}
