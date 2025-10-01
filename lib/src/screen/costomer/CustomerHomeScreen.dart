import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/provider/brandProvider.dart';
import 'package:garage_management/src/screen/ModelsScreen.dart';


class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Moto Parts Catalog"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search brand...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: brandsAsync.when(
              data: (brands) {
                if (brands.isEmpty) {
                  return const Center(child: Text("No brands available"));
                }
         return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
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
                child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child:
                                  brand.logo != null && brand.logo!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: brand.logo!,
height: 80,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.motorcycle,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                    )
                                  : const Icon(
                                      Icons.motorcycle,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                            ),
                            Text(
                              brand.name,
                              style:  TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
    ),
                    );
                  },
                );
   },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),

      // 🔹 FAB only if user.role == "admin"
 floatingActionButton: ref
          .watch(authStateProvider)
          .when(
            data: (user) {
              if (user == null) return const SizedBox.shrink();

              return ref
                  .watch(userProfileProvider(user.uid))
                  .when(
                    data: (appUser) {
                      if (appUser != null && appUser.role == "admin") {
                        return FloatingActionButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final _controller = TextEditingController();
                                return AlertDialog(
                                  title: const Text("Add Brand"),
                                  content: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      hintText: "Enter brand name",
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final brandName = _controller.text
                                            .trim();
                                        if (brandName.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection("categories")
                                              .add({
                                                "name": brandName,
                                                "createdAt":
                                                    FieldValue.serverTimestamp(),
                                              });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Add"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.add),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
  );
  }
}
