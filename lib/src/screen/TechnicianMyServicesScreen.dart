import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/service.dart';
import 'package:garage_management/src/provider/servicesProvider.dart';
import 'package:garage_management/src/screen/CreateChoiceScreen.dart';
import 'package:garage_management/src/screen/AddEditServicePage.dart';

class TechnicianMyServicesScreen extends ConsumerWidget {
  const TechnicianMyServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    if (uid.isEmpty) {
      return const Center(child: Text('Not logged in'));
    }

    final servicesAsync = ref.watch(technicianServicesProvider(uid));

    return servicesAsync.when(
      data: (services) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: () => CreateChoiceScreen.open(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create (service or item)'),
                ),
              );
            }
            final service = services[index - 1];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: service.imageUrl.isNotEmpty
                    ? Image.network(service.imageUrl, width: 48, height: 48, fit: BoxFit.cover)
                    : const Icon(Icons.build_circle),
                title: Text(service.name),
                subtitle: Text('${service.type} - ${service.price.toStringAsFixed(2)} OMR'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      _openEditService(context, uid, service);
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete service'),
                          content: Text('Delete "${service.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await FirebaseFirestore.instance
                            .collection('services')
                            .doc(service.id)
                            .delete();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Service deleted')),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _openAddService(BuildContext context, String technicianId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditServicePage(technicianId: technicianId),
      ),
    );
  }

  void _openEditService(BuildContext context, String technicianId, Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditServicePage(
          technicianId: technicianId,
          existing: service,
        ),
      ),
    );
  }
}
