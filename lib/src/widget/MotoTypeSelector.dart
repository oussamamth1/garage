import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/provider/motoTypesProvider.dart';

/// Dropdown of existing moto types + option to create a new one.
class MotoTypeSelector extends ConsumerWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final bool required;

  const MotoTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelText = 'Moto Type',
    this.required = true,
  });

  static const String _addNewKey = '__add_new__';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(motoTypesProvider);

    return typesAsync.when(
      data: (types) {
        final items = List<String>.from(types);
        if (value != null && value!.isNotEmpty && !items.contains(value)) {
          items.insert(0, value!);
        }
        return DropdownButtonFormField<String>(
          value: value != null && value!.isNotEmpty ? value : null,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          hint: Text(types.isEmpty ? 'No types yet — add one below' : 'Select or add new'),
          items: [
            ...items.map((t) => DropdownMenuItem(value: t, child: Text(t))),
            const DropdownMenuItem(
              value: _addNewKey,
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, size: 20, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Create new moto type...', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
          onChanged: (val) async {
            if (val == _addNewKey) {
              final newName = await _showAddMotoTypeDialog(context);
              if (newName != null && newName.trim().isNotEmpty) {
                await addMotoType(newName.trim());
                if (context.mounted) onChanged(newName.trim());
              }
              return;
            }
            onChanged(val);
          },
          validator: required
              ? (v) => (v == null || v.isEmpty) ? 'Please select or add a moto type' : null
              : null,
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      )),
      error: (e, _) => Text('Error loading moto types: $e'),
    );
  }

  Future<String?> _showAddMotoTypeDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New moto type'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Moto type name',
            hintText: 'e.g. Yamaha, Honda',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (_) => Navigator.pop(context, controller.text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
