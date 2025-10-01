import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/Part.dart';
import 'package:garage_management/src/provider/partProvider.dart';
import 'package:garage_management/src/provider/service/firebaseProviderservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:garage_management/src/provider/authProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartsScreen extends ConsumerWidget {
  final String modelId;
  final String modelName;

  const PartsScreen({
    super.key,
    required this.modelId,
    required this.modelName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(
      userProfileProvider(FirebaseAuth.instance.currentUser?.uid ?? ''),
    );

    final partsAsync = ref.watch(partsProvider(modelId));

    return Scaffold(
      appBar: AppBar(title: Text("$modelName Parts")),
      body: partsAsync.when(
        data: (parts) {
          if (parts.isEmpty) return const Center(child: Text("No parts found"));

          return ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];

              return ListTile(
                title: Text(part.name),
                subtitle: Text(
                  "Price: \$${part.price.toStringAsFixed(2)} | Stock: ${part.stock} | ${part.isOriginal ? "Original" : "Aftermarket"}",
                ),
                trailing: userAsync.when(
                  data: (user) {
                    if (user != null && user.role == 'admin') {
                      return PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            // TODO: Open add/edit part screen
                          } else if (value == 'delete') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Part"),
                                content: Text(
                                  "Are you sure you want to delete ${part.name}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('parts')
                                  .doc(part.id)
                                  .delete();
                            }
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text("Edit")),
                          PopupMenuItem(value: 'delete', child: Text("Delete")),
                        ],
                      );
                    }
                    return null;
                  },
                  loading: () => null,
                  error: (_, __) => null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      floatingActionButton: userAsync.when(
        data: (user) {
          if (user != null && user.role == 'admin') {
            return FloatingActionButton(
              onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditPartScreen(modelId: modelId, part: null)));
                // TODO: Open Add/Edit Part screen in add mode
              },
              child: const Icon(Icons.add),
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

class AddEditPartScreen extends ConsumerStatefulWidget {
  final Part? part; // null = add mode
  final String modelId; // each part belongs to a MotoModel

  const AddEditPartScreen({super.key, this.part, required this.modelId});

  @override
  ConsumerState<AddEditPartScreen> createState() => _AddEditPartScreenState();
}

class _AddEditPartScreenState extends ConsumerState<AddEditPartScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  bool _isOriginal = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.part?.name ?? '');
    _priceController = TextEditingController(
      text: widget.part?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.part?.stock.toString() ?? '',
    );
    _isOriginal = widget.part?.isOriginal ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = ref.read(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.part == null ? "Add Part" : "Edit Part"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Part Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: "Stock"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Original Part"),
                  Switch(
                    value: _isOriginal,
                    onChanged: (v) => setState(() => _isOriginal = v),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final part = Part(
                    id: widget.part?.id ?? '',
                    name: _nameController.text.trim(),
                    price: double.tryParse(_priceController.text) ?? 0,
                    stock: int.tryParse(_stockController.text) ?? 0,
                    modelId: widget.modelId,
                    isOriginal: _isOriginal,
                  );

                  if (widget.part == null) {
                    // Add new part
                    await firestoreService.addPart(part);
                  } else {
                    // Update existing part
                    await firestoreService.updatePart(widget.part!.id, part);
                  }

                  if (mounted) Navigator.pop(context);
                },
                child: Text(widget.part == null ? "Add Part" : "Update Part"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
