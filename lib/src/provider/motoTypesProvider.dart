import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final motoTypesProvider = StreamProvider<List<String>>((ref) {
  return FirebaseFirestore.instance
      .collection('motoTypes')
      .snapshots()
      .map((snap) {
        final list = snap.docs
            .map((d) => (d.data()['name'] ?? d.id).toString().trim())
            .where((s) => s.isNotEmpty)
            .toSet()
            .toList();
        list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
        return list;
      });
});

Future<void> addMotoType(String name) async {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return;
  final id = trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  if (id.isEmpty) return;
  await FirebaseFirestore.instance.collection('motoTypes').doc(id).set({
    'name': trimmed,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
