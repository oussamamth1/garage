import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_management/src/model/MotoModel.dart';
import 'package:garage_management/src/provider/partProvider.dart';

// Provider that gives all model names
// final allModelNamesProvider = StreamProvider<List<MotoModel>>((ref) {
//   return FirebaseFirestore.instance
//       .collection('models')
//       .snapshots()
//       .map(
//         (snapshot) =>
//             snapshot.docs.map((d) => d.data()).toList(),
//       );
// });

class BookingScreen extends ConsumerStatefulWidget {
  final String itemId;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String itemImage;
  final String itemType; // "service" or "part"

  const BookingScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemImage,
    required this.itemType,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedMotoType;
  bool isLoading = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _bookItem() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please log in to book.")));
      return;
    }

    if (selectedMotoType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a moto type.")),
      );
      return;
    }

    if (widget.itemType == "service" &&
        (selectedDate == null || selectedTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time.")),
      );
      return;
    }

    setState(() => isLoading = true);

    DateTime? bookingDateTime;
    if (widget.itemType == "service" &&
        selectedDate != null &&
        selectedTime != null) {
      bookingDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }

    final bookingRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("bookings")
        .doc();

    await bookingRef.set({
      "itemId": widget.itemId,
      "itemName": widget.itemName,
      "itemType": widget.itemType,
      "motoType": selectedMotoType,
      "dateTime": bookingDateTime,
      "price": widget.itemPrice,
      "createdAt": FieldValue.serverTimestamp(),
    });

    setState(() => isLoading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Booking confirmed!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isService = widget.itemType == "service";
    final modelsAsync = ref.watch(AllmodelsProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Book ${widget.itemName}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image
            if (widget.itemImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.itemImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, size: 50),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            Text(
              widget.itemName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (widget.itemDescription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(widget.itemDescription),
              ),
            Text(
              "Price: \$${widget.itemPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 16),

            // Moto type dropdown from provider
        
     modelsAsync.when(
              data: (models) {
                // Reset selectedMotoType if its id is no longer in the list
                if (selectedMotoType != null &&
                    !models.any((m) => m.id == selectedMotoType)) {
                  selectedMotoType = null;
                }

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Moto Type",
                  ),
                  initialValue: selectedMotoType, // the model id
                  items: models
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id, // use id as value
                          child: Text(m.name), // display name
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => selectedMotoType = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error loading models"),
            ),

            const SizedBox(height: 16),

            // Date/time pickers only for services
            if (isService)
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      selectedDate == null
                          ? "Pick Date"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                    onTap: _pickDate,
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      selectedTime == null
                          ? "Pick Time"
                          : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                    ),
                    onTap: _pickTime,
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _bookItem,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
