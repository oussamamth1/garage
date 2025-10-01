import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/Brand.dart';
import 'package:garage_management/src/provider/service/firebaseProviderservice.dart';


class AddEditBrandScreen extends ConsumerStatefulWidget {
  final Brand? brand; // null = add mode

  const AddEditBrandScreen({super.key, this.brand});

  @override
  ConsumerState<AddEditBrandScreen> createState() => _AddEditBrandScreenState();
}

class _AddEditBrandScreenState extends ConsumerState<AddEditBrandScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.brand?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = ref.read(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand == null ? "Add Brand" : "Edit Brand"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Brand Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.brand == null ? "Add" : "Update"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final brand = Brand(
                      id: widget.brand?.id ?? '',
                      name: _nameController.text,
                    );

                    if (widget.brand == null) {
                      await firestoreService.addBrand(brand);
                    } else {
                      await firestoreService.updateBrand(
                        widget.brand!.id,
                        brand,
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
