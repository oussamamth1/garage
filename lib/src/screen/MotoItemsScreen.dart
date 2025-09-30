import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:garage_management/src/provider/filtres.dart';
import 'package:garage_management/src/screen/AddMotoScreen.dart';
import 'package:garage_management/src/screen/BuyItemScreen.dart';
import 'package:garage_management/src/screen/MotoItemCard.dart';

class MotoItemsScreen extends ConsumerWidget {
  const MotoItemsScreen({super.key});
Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredSuppliersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Moto Items")),
      body: items.isEmpty
          ? const Center(child: Text("No items found"))
          :ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return MotoItemCard(item: item);
// ListTile(
//       leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
//       title: Text(item.name),
//       subtitle: Text("${item.motoType} - ${item.model}"),
//       trailing: ElevatedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => BuyItemScreen(item: item)),
//           );
//         },
//         child: const Text("Buy"),
//       ),
//     );
 },
)
,floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddMotoScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMotoScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: "Add Moto",
      ),
    );
  }
}
