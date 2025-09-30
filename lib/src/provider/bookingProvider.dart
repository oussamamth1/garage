import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
final bookingProvider = Provider<CollectionReference>((ref) {
  return FirebaseFirestore.instance.collection('bookings');
});

Future<void> createBooking(WidgetRef ref, Map<String, dynamic> data) async {
  final bookings = ref.read(bookingProvider);
  await bookings.add(data);
}
