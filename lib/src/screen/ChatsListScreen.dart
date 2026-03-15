import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:garage_management/src/model/conversation.dart';
import 'package:garage_management/src/provider/chatProvider.dart';
import 'package:garage_management/src/screen/ChatScreen.dart';

class ChatsListScreen extends ConsumerWidget {
  final bool isTechnician;

  const ChatsListScreen({super.key, required this.isTechnician});

  String _formatLastMessageTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return DateFormat('HH:mm').format(dt);
    }
    if (dt.year == now.year) return DateFormat('MMM d').format(dt);
    return DateFormat('MMM d, yyyy').format(dt);
  }

  Future<String> _getUserDisplayName(String uid) async {
    if (uid.isEmpty) return 'Unknown';
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return 'Unknown';
    final d = doc.data()!;
    final first = d['firstName'] ?? '';
    final last = d['lastName'] ?? '';
    return '$first $last'.trim().isEmpty ? (d['email'] ?? 'Unknown') : '$first $last'.trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in to see chats.'));
    }

    return StreamBuilder<List<Conversation>>(
      stream: conversationsForUserStream(user.uid),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return const Center(
            child: Text('No conversations yet. Chat from a booking.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final conv = list[index];
            final otherId = user.uid == conv.clientId ? conv.technicianId : conv.clientId;
            final otherLabel = user.uid == conv.clientId ? 'Technician' : 'Client';
            return FutureBuilder<String>(
              future: _getUserDisplayName(otherId),
              builder: (context, nameSnap) {
                final name = nameSnap.data ?? otherLabel;
                final lastPreview = conv.lastMessage != null && conv.lastMessage!.isNotEmpty
                    ? conv.lastMessage!
                    : 'No messages yet';
                final timeStr = _formatLastMessageTime(conv.lastMessageAt);
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.chat)),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lastPreview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: conv.lastMessage != null ? Colors.black87 : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      if (timeStr.isNotEmpty)
                        Text(
                          timeStr,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          bookingId: conv.bookingId,
                          otherPartyName: name,
                          currentUserId: user.uid,
                          clientId: conv.clientId,
                          technicianId: conv.technicianId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
