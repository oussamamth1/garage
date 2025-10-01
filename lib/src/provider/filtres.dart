import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/screen/Accuile.dart';

final selectedMotoTypeProvider = StateProvider<String?>((ref) => null);
final selectedModelProvider = StateProvider<String?>((ref) => null);
final filteredSuppliersItemsProvider = Provider<List<SupplierItem>>((ref) {
  final itemsAsync = ref.watch(suppliersItemsProvider);
  final selectedType = ref.watch(selectedMotoTypeProvider); // current moto type
  final selectedModel = ref.watch(selectedModelProvider); // optional

  return itemsAsync.maybeWhen(
    data: (items) {
      return items.where((item) {
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
