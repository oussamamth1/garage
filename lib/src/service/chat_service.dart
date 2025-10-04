import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String systemUid = 'system';
  // // Create or get existing chat for a booking
  // Future<String> createOrGetBookingChat({
  //   required String bookingId,
  //   required String customerId,
  //   String? technicianId,
  // }) async {
  //   try {
  //     // Check if chat already exists for this booking
  //     final existingChat = await _firestore
  //         .collection('chats')
  //         .where('bookingId', isEqualTo: bookingId)
  //         .limit(1)
  //         .get();

  //     if (existingChat.docs.isNotEmpty) {
  //       return existingChat.docs.first.id;
  //     }

  //     // Create new chat
  //     List<String> participants = [customerId];
  //     if (technicianId != null) {
  //       participants.add(technicianId);
  //     }

  //     final chatRef = await _firestore.collection('chats').add({
  //       'bookingId': bookingId,
  //       'participants': participants,
  //       'messages': [],
  //       'createdAt': Timestamp.now(),
  //       'lastMessageAt': Timestamp.now(),
  //       'type': 'booking',
  //     });

  //     // Send initial automated message
  //     await sendMessage(
  //       chatId: chatRef.id,
  //       senderId: 'system',
  //       text: 'Chat created for your booking. Feel free to ask any questions!',
  //     );

  //     return chatRef.id;
  //   } catch (e) {
  //     throw Exception('Failed to create chat: $e');
  //   }
  // }
  Future<String> createOrGetBookingChat({
    required String bookingId,
    required String customerId,
    String? technicianId,
  }) async {
    try {
      // Look for existing chat for this booking + same customer
      // final existingChat = await _firestore
      //     .collection('chats')
      //     .where('bookingId', isEqualTo: bookingId)
      //     .where('participants', arrayContains: customerId)
      //     .limit(1)
      //     .get();

      // if (existingChat.docs.isNotEmpty) {
      //   return existingChat.docs.first.id;
      // }
      final chatKey = 'item_${bookingId}_$customerId';
      final existingChat = await _firestore
          .collection('chats')
          .where('chatKey', isEqualTo: chatKey)
          .limit(1)
          .get();
      if (existingChat.docs.isNotEmpty) return existingChat.docs.first.id;

      if (existingChat.docs.isNotEmpty) {
        // return the existing chat id instead of making new one
        return existingChat.docs.first.id;
      }

      // // Create new chat
      // List<String> participants = [customerId];
      // if (technicianId != null) {
      //   participants.add(technicianId);
      // }
      List<String> participants = [customerId, systemUid];

      final chatRef = await _firestore.collection('chats').add({
        'chatKey': chatKey, // ✅ important
        'bookingId': bookingId,
        'participants': participants,
        'messages': [],
        'createdAt': Timestamp.now(),
        'lastMessageAt': Timestamp.now(),
        'type': 'booking',
      });

      await sendMessage(
        chatId: chatRef.id,
        senderId: 'system',
        text: 'Chat created for your booking. Feel free to ask any questions!',
      );

      return chatRef.id;
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  // Create chat for sales order
  Future<String> createOrGetSalesOrderChat({
    required String orderId,
    required String customerId,
  }) async {
    try {
      // final existingChat = await _firestore
      //     .collection('chats')
      //     .where('orderId', isEqualTo: orderId)
      //     .limit(1)
      //     .get();
      final chatKey = 'item_${orderId}_$customerId';
      final existingChat = await _firestore
          .collection('chats')
          .where('chatKey', isEqualTo: chatKey)
          .limit(1)
          .get();
      if (existingChat.docs.isNotEmpty) return existingChat.docs.first.id;

      if (existingChat.docs.isNotEmpty) {
        // return the existing chat id instead of making new one
        return existingChat.docs.first.id;
      }
      // final existingChat = await _firestore
      //     .collection('chats')
      //     .where('orderId', isEqualTo: orderId)
      //     .where('participants', arrayContains: customerId)
      //     .limit(1)
      //     .get();
      // if (existingChat.docs.isNotEmpty) {
      //   return existingChat.docs.first.id;
      // }

      final chatRef = await _firestore.collection('chats').add({
        'chatKey': chatKey, // ✅ important
        'orderId': orderId,
        'participants': [customerId, systemUid], // include system/admin
        'messages': [],
        'createdAt': Timestamp.now(),
        'lastMessageAt': Timestamp.now(),
        'type': 'sales',
      });

      await sendMessage(
        chatId: chatRef.id,
        senderId: 'system',
        text: 'Chat created for your order. We\'ll keep you updated!',
      );

      return chatRef.id;
    } catch (e) {
      throw Exception('Failed to create sales chat: $e');
    }
  }

  Stream<List<ChatModel>> getAllChats() {
    return _firestore
        .collection('chats')
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<ChatModel>> getUserChatsCustomer(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList(),
        );
  }

  Future<String> createServiceInquiryChat({
    required String customerId,
    required String serviceType,
  }) async {
    try {
      // 1️⃣ Check if chat already exists
      // final existingChat = await _firestore
      //     .collection('chats')
      //     .where('serviceType', isEqualTo: serviceType)
      //     .where('participants', arrayContains: customerId)
      //     .where('status', isEqualTo: 'open') // optional: only reuse open chats
      //     .limit(1)
      //     .get();
      final chatKey = 'item_${serviceType}_$customerId';
      final existingChat = await _firestore
          .collection('chats')
          .where('chatKey', isEqualTo: chatKey)
          .limit(1)
          .get();
      if (existingChat.docs.isNotEmpty) return existingChat.docs.first.id;

      if (existingChat.docs.isNotEmpty) {
        // return the existing chat id instead of making new one
        return existingChat.docs.first.id;
      }

      // 2️⃣ Otherwise, create new chat
      final chatRef = await _firestore.collection('chats').add({
        'chatKey': chatKey, // ✅ important
        'serviceType': serviceType,
        'participants': [customerId, systemUid],
        'messages': [],
        'createdAt': Timestamp.now(),
        'lastMessageAt': Timestamp.now(),
        'type': 'inquiry',
        'status': 'open',
      });

      await sendMessage(
        chatId: chatRef.id,
        senderId: 'system',
        text: 'Hello! How can we help you with $serviceType?',
      );

      return chatRef.id;
    } catch (e) {
      throw Exception('Failed to create inquiry chat: $e');
    }
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? imageUrl,
    String? audioUrl,
  }) async {
    try {
      final message = ChatMessage(
        sender: senderId,
        text: text,
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
        audioUrl: audioUrl,
      );

      await _firestore.collection('chats').doc(chatId).update({
        'messages': FieldValue.arrayUnion([message.toMap()]),
        'lastMessageAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get chat messages stream
  Stream<ChatModel> getChatStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) => ChatModel.fromFirestore(doc));
  }

  // Get all chats for a user
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList(),
        );
  }

  // Add participant to chat (e.g., when technician is assigned)
  Future<void> addParticipant(String chatId, String userId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });

      await sendMessage(
        chatId: chatId,
        senderId: 'system',
        text: 'A technician has joined the chat.',
      );
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  // Mark chat as resolved
  Future<void> closeChat(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'status': 'closed',
        'closedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to close chat: $e');
    }
  }
}
