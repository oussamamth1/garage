import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/MotoModel.dart';
import 'package:garage_management/src/provider/service/firebaseProviderservice.dart';

class AddEditModelScreen extends ConsumerStatefulWidget {
  final MotoModel? model; // null = add mode
  final String brandId; // required because model belongs to a brand

  const AddEditModelScreen({super.key, this.model, required this.brandId});

  @override
  ConsumerState<AddEditModelScreen> createState() => _AddEditModelScreenState();
}

class _AddEditModelScreenState extends ConsumerState<AddEditModelScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _yearController;
  late TextEditingController _colorController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model?.name ?? '');
    _yearController = TextEditingController(
      text: widget.model?.year.toString() ?? '',
    );
    _colorController = TextEditingController(text: widget.model?.color ?? '');
    _imageUrlController = TextEditingController(
      text: widget.model?.imageUrl ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = ref.read(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.model == null ? "Add Moto Model" : "Edit Moto Model",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Model Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: "Year"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: "Color (optional)",
                ),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "Image URL (optional)",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.model == null ? "Add" : "Update"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final model = MotoModel(
                      id: widget.model?.id ?? '',
                      brandId: widget.brandId,
                      name: _nameController.text.trim(),
                      year: int.tryParse(_yearController.text.trim()) ?? 0,
                      color: _colorController.text.trim().isEmpty
                          ? null
                          : _colorController.text.trim(),
                      imageUrl: _imageUrlController.text.trim().isEmpty
                          ? null
                          : _imageUrlController.text.trim(),
                    );

                    if (widget.model == null) {
                      await firestoreService.addModel(model);
                    } else {
                      await firestoreService.updateModel(
                        widget.model!.id,
                        model,
                      );
                    }

                    if (mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
