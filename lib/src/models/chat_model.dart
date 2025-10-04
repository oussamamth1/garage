import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  final String? imageUrl;
  final String? audioUrl;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.imageUrl,
    this.audioUrl,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      sender: map['sender'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.parse(map['timestamp']),
      imageUrl: map['imageUrl'],
      audioUrl: map['audioUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }
}

class ChatModel {
  final String id;
  final String? bookingId; // optional for non-booking chats
  final String? orderId; // optional for sales chats
  final String? serviceType; // optional for inquiry chats
  final List<String> participants;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final String type; // 'booking', 'sales', 'inquiry'
  final String? status; // optional, e.g., 'open' or 'closed'
  final String? chatKey; // unique key to prevent duplicates per customer+item

  ChatModel({
    required this.id,
    this.bookingId,
    this.orderId,
    this.serviceType,
    required this.participants,
    required this.messages,
    required this.createdAt,
    this.lastMessageAt,
    required this.type,
    this.status,
    this.chatKey,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      id: doc.id,
      bookingId: data['bookingId'],
      orderId: data['orderId'],
      serviceType: data['serviceType'],
      participants: List<String>.from(data['participants'] ?? []),
      messages: (data['messages'] as List? ?? [])
          .map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessageAt: data['lastMessageAt'] != null
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : null,
      type: data['type'] ?? 'inquiry',
      status: data['status'],
      chatKey: data['chatKey'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'orderId': orderId,
      'serviceType': serviceType,
      'participants': participants,
      'messages': messages.map((m) => m.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageAt': lastMessageAt != null
          ? Timestamp.fromDate(lastMessageAt!)
          : null,
      'type': type,
      'status': status,
      'chatKey': chatKey,
    };
  }
}
