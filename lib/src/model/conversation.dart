import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String bookingId;
  final String clientId;
  final String technicianId;
  final DateTime? createdAt;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  Conversation({
    required this.id,
    required this.bookingId,
    required this.clientId,
    required this.technicianId,
    this.createdAt,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory Conversation.fromFirestore(Map<String, dynamic> data, String id) {
    return Conversation(
      id: id,
      bookingId: data['bookingId'] ?? '',
      clientId: data['clientId'] ?? '',
      technicianId: data['technicianId'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: data['lastMessageAt'] is Timestamp
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'clientId': clientId,
      'technicianId': technicianId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
