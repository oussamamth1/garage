import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class ChatItem {
  final String id;
  final String serviceType;
  final String status;
  final String lastMessage;
  final String customerId;
  final DateTime createdAt;
  final DateTime lastMessageAt;

  ChatItem({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.lastMessage,
    required this.customerId,
    required this.createdAt,
    required this.lastMessageAt,
  });

  factory ChatItem.fromMap(Map<String, dynamic> map, String id) {
    return ChatItem(
      id: id,
      serviceType: map['serviceType'] ?? '',
      status: map['status'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      customerId: map['customerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessageAt: (map['lastMessageAt'] as Timestamp).toDate(),
    );
  }
}
