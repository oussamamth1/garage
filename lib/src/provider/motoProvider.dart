import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/Brand.dart';
import 'package:garage_management/src/model/MotoModel.dart';
final modelsProvider = StreamProvider.family<List<MotoModel>, String>((
  ref,
  brandId,
) {
  return FirebaseFirestore.instance
      .collection('models') // flat models collection
      .where('brandId', isEqualTo: brandId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => MotoModel.fromMap(doc.id, doc.data()))
            .toList(),
      );
});
