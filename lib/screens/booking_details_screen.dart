import 'package:flutter/material.dart';
import 'package:garage_management/src/models/booking_model.dart';

import '../widgets/chat_button.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;
  final String currentUserId;

  const BookingDetailsScreen({
    Key? key,
    required this.booking,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bike: ${booking.bikeModel}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Plate: ${booking.plateNumber}'),
                    Text('Service: ${booking.serviceType ?? "N/A"}'),
                    Text('Status: ${booking.status.name}'),
                    const SizedBox(height: 16),

                    // Chat button for this booking
                    ChatButton(
                      bookingId: booking.id,
                      customerId: currentUserId,
                      buttonText: 'Chat about this booking',
                      icon: Icons.chat,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
