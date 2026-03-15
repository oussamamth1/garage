import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:garage_management/src/model/booking.dart';
import 'package:garage_management/src/provider/bookingProvider.dart';
import 'package:garage_management/src/screen/ChatScreen.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  Future<void> _updateBooking(
    BuildContext context,
    String bookingId,
    DateTime? currentPreferred,
  ) async {
    final newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      initialDate: currentPreferred ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate == null || !context.mounted) return;

    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentPreferred ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newTime == null || !context.mounted) return;

    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'clientPreferredDateTime': Timestamp.fromDate(newDateTime),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking updated successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _cancelBooking(BuildContext context, String bookingId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this booking?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking cancelled"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    final preferred = booking.clientPreferredDateTime ?? booking.clientRequestedAt;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(booking.serviceName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (preferred != null)
                Text(
                  "Requested: ${DateFormat('dd/MM/yyyy HH:mm').format(preferred)}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(height: 8),
              Text(
                "Status: ${booking.status}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: booking.status == "pending"
                          ? Colors.orange
                          : booking.status == "rejected" || booking.status == "cancelled"
                              ? Colors.red
                              : Colors.green,
                    ),
              ),
              if (booking.estimatedReadyAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  "Ready by: ${DateFormat('dd/MM/yyyy HH:mm').format(booking.estimatedReadyAt!)}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                "Description:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                booking.description ?? "No description",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Please log in to see your bookings",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    final bookingsAsync = ref.watch(clientBookingsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          final active = bookings.where((b) => b.status != 'cancelled' && b.status != 'rejected').toList();
          if (active.isEmpty) {
            return Center(
              child: Text(
                "No bookings found",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: active.length,
            itemBuilder: (context, index) {
              final booking = active[index];
              final preferred = booking.clientPreferredDateTime ?? booking.clientRequestedAt;
              final status = booking.status;

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _showBookingDetails(context, booking),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.build_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.serviceName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  if (preferred != null)
                                    Text(
                                      "Requested: ${DateFormat('dd/MM/yyyy HH:mm').format(preferred)}",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (booking.estimatedReadyAt != null)
                                    Text(
                                      "Ready by: ${DateFormat('dd/MM/yyyy HH:mm').format(booking.estimatedReadyAt!)}",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                    ),
                                  const SizedBox(height: 4),
                                  Chip(
                                    label: Text(
                                      status,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: status == "pending"
                                        ? Colors.orange.withOpacity(0.2)
                                        : status == "accepted" || status == "in_progress"
                                            ? Colors.blue.withOpacity(0.2)
                                            : status == "completed"
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.grey.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            if (status != 'rejected' && status != 'cancelled')
                              IconButton(
                                icon: const Icon(Icons.chat),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        bookingId: booking.id,
                                        otherPartyName: 'Technician',
                                        currentUserId: user.uid,
                                        clientId: booking.clientId,
                                        technicianId: booking.technicianId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == "edit" && status == "pending") {
                                  await _updateBooking(
                                    context,
                                    booking.id,
                                    booking.clientPreferredDateTime ?? booking.clientRequestedAt,
                                  );
                                } else if (value == "cancel" && status != "completed") {
                                  await _cancelBooking(context, booking.id);
                                }
                              },
                              itemBuilder: (context) => [
                                if (booking.status == "pending")
                                  const PopupMenuItem(value: "edit", child: Text("Edit preferred time")),
                                if (booking.status != "completed")
                                  const PopupMenuItem(value: "cancel", child: Text("Cancel")),
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
