import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/models/ChatItem.dart';
import 'package:garage_management/src/models/chat_model.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/service/chat_service.dart' show ChatService;

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final chatsStreamProvider = StreamProvider<List<ChatModel>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  final chatService = ref.watch(chatServiceProvider);

  if (user == null) return const Stream.empty();

  return user.role == 'admin'
      ? chatService.getAllChats()
      : chatService.getUserChatsCustomer(user.uid);
});
