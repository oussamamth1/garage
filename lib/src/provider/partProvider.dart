import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/Brand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/MotoModel.dart';
import 'package:garage_management/src/model/Part.dart';
final partsProvider = StreamProvider.family<List<Part>, String>((ref, modelId) {
  return FirebaseFirestore.instance
      .collection('parts') // flat parts collection
      .where('modelId', isEqualTo: modelId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Part.fromMap(doc.id, doc.data()))
            .toList(),
      );
});
final AllpartsProvider = StreamProvider<List<Part>>((ref) {
  return FirebaseFirestore.instance
      .collection('parts')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Part.fromMap(doc.id,doc.data(), ))
            .toList(),
      );
});
final AllmodelsProvider = StreamProvider<List<MotoModel>>((
  ref,
) {
  return FirebaseFirestore.instance
      .collection('models')
     
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => MotoModel.fromMap(doc.id, doc.data()))
            .toList(),
      );
});
