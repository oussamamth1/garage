import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/l10n/app_localizations.dart';
import 'package:garage_management/screens/chat_screen.dart';
import 'package:garage_management/src/models/chat_model.dart';
import 'package:garage_management/src/provider/chatServiceProvider.dart';
import 'package:garage_management/src/service/chat_service.dart';
import 'package:intl/intl.dart';
class ChatsListScreen extends ConsumerWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) return Center(child: Text("No chats yet"));

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return 
ListTile(
                title: Text(chat.serviceType ?? "U/K"),
                subtitle: Text(
                  chat.messages.isNotEmpty
                      ? chat.messages.last.text
                      : "No messages yet",
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(chat.status ?? ''),
                    const SizedBox(height: 4),
                if (chat.lastMessageAt != null)
                      Text(
                        _formatLocalizedDate(chat.lastMessageAt!, context),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.right,
                      ),
                  ],
                ),
                onTap: () {
                  // Navigate to ChatScreen with chatId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatId: chat.id, // <-- use chatKey
                      ),
                    ),
                  );
                },
              );         },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
String _formatLocalizedDate(DateTime date, BuildContext context) {
  final locale = AppLocalizations.of(context)?.localeName ?? 'en';
  final formatter = DateFormat('EEEE, d MMMM yyyy, HH:mm', locale);
  return formatter.format(date);
}
