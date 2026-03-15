import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/item_order.dart';

/// Orders where current user is the buyer (client).
final clientOrdersProvider = StreamProvider.family<List<ItemOrder>, String>((ref, clientId) {
  if (clientId.isEmpty) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('orders')
      .where('clientId', isEqualTo: clientId)
      .snapshots()
      .map((snap) {
        final list = snap.docs.map((d) => ItemOrder.fromFirestore(d.data(), d.id)).toList();
        list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        return list;
      });
});

/// Orders where current user is the seller.
final sellerOrdersProvider = StreamProvider.family<List<ItemOrder>, String>((ref, sellerId) {
  if (sellerId.isEmpty) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('orders')
      .where('sellerId', isEqualTo: sellerId)
      .snapshots()
      .map((snap) {
        final list = snap.docs.map((d) => ItemOrder.fromFirestore(d.data(), d.id)).toList();
        list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        return list;
      });
});

Future<void> updateOrderStatus(String orderId, String status) async {
  await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
    'status': status,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
