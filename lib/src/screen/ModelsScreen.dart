import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/MotoModel.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/EditScreen/EditModelScreen.dart';
import 'package:garage_management/src/screen/EditScreen/EditPartScreen.dart';
import 'package:garage_management/src/screen/PartsScreen.dart';

class ModelsScreen extends ConsumerWidget {
  final String brandId;
  final String brandName;

  const ModelsScreen({
    super.key,
    required this.brandId,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(
      userProfileProvider(FirebaseAuth.instance.currentUser?.uid ?? ''),
    );

    final modelsStream = FirebaseFirestore.instance
        .collection('models')
        .where('brandId', isEqualTo: brandId)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brandName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Models',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: modelsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading models...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bike_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No models found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first model to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final models = snapshot.data!.docs
              .map(
                (doc) => MotoModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ModelCard(
                  model: model,
                  brandId: brandId,
                  userAsync: userAsync,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: userAsync.when(
        data: (user) {
          if (user != null && user.role == 'admin') {
            return FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddEditModelScreen(brandId: brandId, model: null),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Model'),
              elevation: 4,
            );
          }
          return null;
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final MotoModel model;
  final String brandId;
  final AsyncValue userAsync;

  const _ModelCard({
    required this.model,
    required this.brandId,
    required this.userAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PartsScreen(modelId: model.id, modelName: model.name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container
                      CachedNetworkImage(
                  imageUrl: model.logo ?? "",
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.motorcycle,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
     
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            model.year.toString()??'',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (model.color != null) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.palette,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              model.color!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Action button
                userAsync.when(
                  data: (user) {
                    if (user != null && user.role == 'admin') {
                      return IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                        onPressed: () => _showOptionsMenu(context),
                      );
                    }
                    return const SizedBox(width: 8);
                  },
                  loading: () => const SizedBox(width: 8),
                  error: (_, __) => const SizedBox(width: 8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Model'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddEditModelScreen(model: model, brandId: brandId),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete Model',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text("Delete Model"),
                    content: Text(
                      "Are you sure you want to delete ${model.name}? This action cannot be undone.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseFirestore.instance
                      .collection('models')
                      .doc(model.id)
                      .delete();
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
