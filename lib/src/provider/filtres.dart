import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/screen/Accuile.dart';

final selectedMotoTypeProvider = StateProvider<String?>((ref) => null);
final selectedModelProvider = StateProvider<String?>((ref) => null);
final filteredSuppliersProvider = Provider<List<SupplierItem>>((ref) {
  final suppliersAsync = ref.watch(suppliersProvider);
  final selectedType = ref.watch(selectedMotoTypeProvider);
  final selectedModel = ref.watch(selectedModelProvider);

  return suppliersAsync.maybeWhen(
    data: (suppliers) {
      return suppliers.where((item) {
        final matchesType =
            selectedType == null || item.motoType == selectedType;
        final matchesModel =
            selectedModel == null || item.model == selectedModel;
        return matchesType && matchesModel;
      }).toList();
    },
    orElse: () => [],
  );
});
