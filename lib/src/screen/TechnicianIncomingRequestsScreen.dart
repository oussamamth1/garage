import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:garage_management/src/model/booking.dart';
import 'package:garage_management/src/provider/bookingProvider.dart';
import 'package:garage_management/src/screen/ChatScreen.dart';

class TechnicianIncomingRequestsScreen extends ConsumerWidget {
  const TechnicianIncomingRequestsScreen({super.key});

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
        final pending = allBookings.where((b) => b.status == 'pending').toList();
        if (pending.isEmpty) {
          return const Center(
            child: Text('No pending requests'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pending.length,
          itemBuilder: (context, index) {
            final booking = pending[index];
            return _RequestCard(
              booking: booking,
              onAccept: () => _acceptBooking(context, booking),
              onReject: () => _rejectBooking(context, booking),
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
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Future<void> _acceptBooking(BuildContext context, Booking booking) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !context.mounted) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedTime == null || !context.mounted) return;

    final estimatedReadyAt = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    await FirebaseFirestore.instance.collection('bookings').doc(booking.id).update({
      'status': 'accepted',
      'technicianAcceptedAt': FieldValue.serverTimestamp(),
      'estimatedReadyAt': Timestamp.fromDate(estimatedReadyAt),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _rejectBooking(BuildContext context, Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject request'),
        content: const Text('Reject this booking request?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('bookings').doc(booking.id).update({
      'status': 'rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected')),
      );
    }
  }
}

class _RequestCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onChat;

  const _RequestCard({
    required this.booking,
    required this.onAccept,
    required this.onReject,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final preferred = booking.clientPreferredDateTime ?? booking.clientRequestedAt;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                'Preferred: ${DateFormat('dd/MM/yyyy HH:mm').format(preferred)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (booking.motoType != null) Text('Moto: ${booking.motoType}', style: Theme.of(context).textTheme.bodySmall),
            if (booking.description != null && booking.description!.isNotEmpty)
              Text(booking.description!, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('Chat'),
                ),
                TextButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Reject'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Accept'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
