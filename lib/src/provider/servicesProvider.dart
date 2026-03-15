import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/service.dart';

final servicesProvider = StreamProvider<List<Service>>((ref) {
  return FirebaseFirestore.instance
      .collection('services')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Service.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});

final technicianServicesProvider =
    StreamProvider.family<List<Service>, String>((ref, technicianId) {
  if (technicianId.isEmpty) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('services')
      .where('technicianId', isEqualTo: technicianId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Service.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});
