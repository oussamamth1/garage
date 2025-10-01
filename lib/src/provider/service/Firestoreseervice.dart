  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/Brand.dart';
import 'package:garage_management/src/model/MotoModel.dart';
import 'package:garage_management/src/model/Part.dart';


class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // 🔹 BRANDS
  Future<void> addBrand(Brand brand) async {
    await _db.collection('categories').add(brand.toMap());
  }

  Future<void> updateBrand(String id, Brand brand) async {
    await _db.collection('categories').doc(id).update(brand.toMap());
  }

  // 🔹 MODELS
  Future<void> addModel(MotoModel model) async {
    await _db.collection('models').add(model.toMap());
  }

  Future<void> updateModel(String id, MotoModel model) async {
    await _db.collection('models').doc(id).update(model.toMap());
  }

  // 🔹 PARTS
  Future<void> addPart(Part part) async {
    await _db.collection('parts').add(part.toMap());
  }

  Future<void> updatePart(String id, Part part) async {
    await _db.collection('parts').doc(id).update(part.toMap());
  }
}
