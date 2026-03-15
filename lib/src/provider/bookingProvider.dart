import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_management/src/model/booking.dart';

final bookingProvider = Provider<CollectionReference>((ref) {
  return FirebaseFirestore.instance.collection('bookings');
});

final clientBookingsProvider =
    StreamProvider.family<List<Booking>, String>((ref, clientId) {
  if (clientId.isEmpty) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('clientId', isEqualTo: clientId)
      .snapshots()
      .map((snap) {
        final list = snap.docs
            .map((d) => Booking.fromFirestore(d.data(), d.id))
            .toList();
        list.sort((a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        return list;
      });
});

final technicianBookingsProvider =
    StreamProvider.family<List<Booking>, String>((ref, technicianId) {
  if (technicianId.isEmpty) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('technicianId', isEqualTo: technicianId)
      .snapshots()
      .map((snap) {
        final list = snap.docs
            .map((d) => Booking.fromFirestore(d.data(), d.id))
            .toList();
        list.sort((a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        return list;
      });
});

Future<void> createBooking(WidgetRef ref, Map<String, dynamic> data) async {
  final bookings = ref.read(bookingProvider);
  await bookings.add(data);
}
