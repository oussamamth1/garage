import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/Brand.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/screen/Accuile.dart';

final brandsProvider = StreamProvider<List<Brand>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories') // collection for brands
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Brand.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});
// final suppliersProvider = StreamProvider<List<SupplierItem>>((ref) {
//   return FirebaseFirestore.instance
//       .collection('suppliers')
//       .snapshots()
//       .map(
//         (snapshot) => snapshot.docs
//             .map((doc) => SupplierItem.fromFirestore(doc.data(), doc.id))
//             .toList(),
//       );
// });
