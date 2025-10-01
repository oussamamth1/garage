import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/provider/service/Firestoreseervice.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
