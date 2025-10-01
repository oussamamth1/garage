// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:garage_management/src/provider/partProvider.dart';


// class PartsScreen extends ConsumerWidget {
//   final String modelId;
//   final String modelName;

//   const PartsScreen({
//     super.key,
//     required this.modelId,
//     required this.modelName,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final partsAsync = ref.watch(partsProvider(modelId));

//     return Scaffold(
//       appBar: AppBar(title: Text("$modelName Parts")),
//       body: partsAsync.when(
//         data: (parts) {
//           if (parts.isEmpty) {
//             return const Center(child: Text("No parts found"));
//           }
//           return ListView.builder(
//             itemCount: parts.length,
//             itemBuilder: (context, index) {
//               final part = parts[index];
//               return ListTile(
//                 title: Text(part.name),
//                 subtitle: Text("Stock: ${part.stock}"),
//                 trailing: Text("\$${part.price.toStringAsFixed(2)}"),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//       ),
//     );
//   }
// }
