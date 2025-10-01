import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/provider/brandProvider.dart';
import 'package:garage_management/src/screen/ModelsScreen.dart';


class BrandsScreen extends ConsumerWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Brands")),
      body: brandsAsync.when(
        data: (brands) {
          if (brands.isEmpty) {
            return const Center(child: Text("No brands found"));
          }
          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return ListTile(
                leading: brand.logo != null
                    ? Image.network(brand.logo!, width: 40, height: 40)
                    : const Icon(Icons.motorcycle),
                title: Text(brand.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModelsScreen(
                        brandId: brand.id,
                        brandName: brand.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
