import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:garage_management/src/model/booking.dart';
import 'package:garage_management/src/provider/bookingProvider.dart';
import 'package:garage_management/src/screen/ChatScreen.dart';

class TechnicianMyJobsScreen extends ConsumerWidget {
  const TechnicianMyJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    if (uid.isEmpty) {
      return const Center(child: Text('Not logged in'));
    }

    final bookingsAsync = ref.watch(technicianBookingsProvider(uid));

    return bookingsAsync.when(
      data: (allBookings) {
        final jobs = allBookings
            .where((b) => ['accepted', 'in_progress', 'completed'].contains(b.status))
            .toList();
        if (jobs.isEmpty) {
          return const Center(
            child: Text('No accepted jobs yet'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final booking = jobs[index];
            return _JobCard(
              booking: booking,
              onChat: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      bookingId: booking.id,
                      otherPartyName: 'Client',
                      currentUserId: uid,
                      clientId: booking.clientId,
                      technicianId: booking.technicianId,
                    ),
                  ),
                );
              },
              onUpdateStatus: (newStatus) => _updateStatus(context, booking.id, newStatus),
              onSetReadyAt: () => _setReadyAt(context, booking),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Future<void> _updateStatus(BuildContext context, String bookingId, String newStatus) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status: $newStatus')),
      );
    }
  }

  Future<void> _setReadyAt(BuildContext context, Booking booking) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: booking.estimatedReadyAt ?? DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: booking.estimatedReadyAt != null
          ? TimeOfDay.fromDateTime(booking.estimatedReadyAt!)
          : const TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedTime == null || !context.mounted) return;

    final dt = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    await FirebaseFirestore.instance.collection('bookings').doc(booking.id).update({
      'estimatedReadyAt': Timestamp.fromDate(dt),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ready time updated'), backgroundColor: Colors.green),
      );
    }
  }
}

class _JobCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onChat;
  final Function(String) onUpdateStatus;
  final VoidCallback onSetReadyAt;

  const _JobCard({
    required this.booking,
    required this.onChat,
    required this.onUpdateStatus,
    required this.onSetReadyAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.serviceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Chip(
                  label: Text(booking.status),
                  backgroundColor: booking.status == 'completed'
                      ? Colors.green.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                ),
              ],
            ),
            if (booking.estimatedReadyAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Ready by: ${DateFormat('dd/MM/yyyy HH:mm').format(booking.estimatedReadyAt!)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('Chat'),
                ),
                if (booking.serviceType == 'repair' && booking.status != 'completed')
                  TextButton.icon(
                    onPressed: onSetReadyAt,
                    icon: const Icon(Icons.schedule, size: 18),
                    label: const Text('Set ready time'),
                  ),
                if (booking.status == 'accepted')
                  ElevatedButton(
                    onPressed: () => onUpdateStatus('in_progress'),
                    child: const Text('Start'),
                  ),
                if (booking.status == 'in_progress')
                  ElevatedButton(
                    onPressed: () => onUpdateStatus('completed'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Complete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
