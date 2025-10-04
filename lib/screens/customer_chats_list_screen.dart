// lib/screens/customer_chats_list_screen.dart
import 'package:flutter/material.dart';
import 'package:garage_management/src/models/chat_model.dart';
import 'package:garage_management/src/service/chat_service.dart';

import '../screens/chat_screen.dart';

class CustomerChatsListScreen extends StatelessWidget {
  final String customerId;

  const CustomerChatsListScreen({Key? key, required this.customerId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Chats')),
      body: StreamBuilder<List<ChatModel>>(
        stream: chatService.getUserChats(customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chats yet. Start a conversation!'),
            );
          }

          final chats = snapshot.data!;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final lastMessage = chat.messages.isNotEmpty
                  ? chat.messages.last
                  : null;

              return ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    chat.bookingId!.isNotEmpty
                        ? Icons.build
                        : Icons.shopping_bag,
                  ),
                ),
                title: Text(
                  chat.bookingId!.isNotEmpty ? 'Booking Chat' : 'Order Chat',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMessage?.text ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: lastMessage != null
                    ? Text(
                        _formatTime(lastMessage.timestamp),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chat.id,
                    
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return '${time.day}/${time.month}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
