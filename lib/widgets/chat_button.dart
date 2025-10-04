// lib/widgets/chat_button.dart
import 'package:flutter/material.dart';
import 'package:garage_management/screens/chat_screen.dart';
import 'package:garage_management/src/service/chat_service.dart';

class ChatButton extends StatelessWidget {
  final String? bookingId;
  final String? orderId;
  final String? serviceType;
  final String customerId;
  final String buttonText;
  final IconData icon;

  const ChatButton({
    Key? key,
    this.bookingId,
    this.orderId,
    this.serviceType,
    required this.customerId,
    this.buttonText = 'Chat with us',
    this.icon = Icons.chat_bubble_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          final chatService = ChatService();
          String chatId;

          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          // Create or get appropriate chat
          if (bookingId != null) {
            chatId = await chatService.createOrGetBookingChat(
              bookingId: bookingId!,
              customerId: customerId,
            );
          } else if (orderId != null) {
            chatId = await chatService.createOrGetSalesOrderChat(
              orderId: orderId!,
              customerId: customerId,
            );
          } else if (serviceType != null) {
            chatId = await chatService.createServiceInquiryChat(
              customerId: customerId,
              serviceType: serviceType!,
            );
          } else {
            throw Exception('No chat context provided');
          }

          // Close loading dialog
          Navigator.pop(context);

          // Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(chatId: chatId,),
            ),
          );
        } catch (e) {
          // Close loading dialog
          Navigator.pop(context);

          // Show error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to open chat: $e')));
        }
      },
      icon: Icon(icon),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
