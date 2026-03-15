import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/model/conversation.dart';
import 'package:garage_management/src/model/message.dart';

String conversationIdFromBookingId(String bookingId) => bookingId;

String _conversationId(String bookingId) => bookingId;

Stream<List<Message>> messagesStreamProvider(String bookingId) {
  final convId = _conversationId(bookingId);
  return FirebaseFirestore.instance
      .collection('conversations')
      .doc(convId)
      .collection('messages')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => Message.fromFirestore(d.data(), d.id))
          .toList());
}

Future<void> ensureConversation(String bookingId, String clientId, String technicianId) async {
  final convId = _conversationId(bookingId);
  final ref = FirebaseFirestore.instance.collection('conversations').doc(convId);
  await ref.set({
    'bookingId': bookingId,
    'clientId': clientId,
    'technicianId': technicianId,
    'createdAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

Future<void> sendMessage(String bookingId, String text, String senderId, String? senderName) async {
  final convId = _conversationId(bookingId);
  final convRef = FirebaseFirestore.instance.collection('conversations').doc(convId);
  final now = FieldValue.serverTimestamp();
  await convRef.collection('messages').add({
    'text': text,
    'senderId': senderId,
    'senderName': senderName,
    'createdAt': now,
  });
  await convRef.set({
    'lastMessage': text.length > 80 ? '${text.substring(0, 80)}...' : text,
    'lastMessageAt': now,
  }, SetOptions(merge: true));
}

Stream<List<Conversation>> conversationsForUserStream(String uid) {
  if (uid.isEmpty) return Stream.value([]);
  final controller = StreamController<List<Conversation>>.broadcast();
  List<Conversation> lastClient = [];
  List<Conversation> lastTech = [];
  var clientDone = false;
  var techDone = false;

  void emit() {
    if (!clientDone || !techDone) return;
    final seen = <String>{};
    final merged = <Conversation>[];
    for (final c in lastClient) {
      if (seen.add(c.id)) merged.add(c);
    }
    for (final c in lastTech) {
      if (seen.add(c.id)) merged.add(c);
    }
    merged.sort((a, b) => (b.lastMessageAt ?? b.createdAt ?? DateTime(0))
        .compareTo(a.lastMessageAt ?? a.createdAt ?? DateTime(0)));
    controller.add(merged);
  }

  final sub1 = FirebaseFirestore.instance
      .collection('conversations')
      .where('clientId', isEqualTo: uid)
      .snapshots()
      .listen((s) {
    lastClient = s.docs.map((d) => Conversation.fromFirestore(d.data(), d.id)).toList();
    clientDone = true;
    emit();
  });
  final sub2 = FirebaseFirestore.instance
      .collection('conversations')
      .where('technicianId', isEqualTo: uid)
      .snapshots()
      .listen((s) {
    lastTech = s.docs.map((d) => Conversation.fromFirestore(d.data(), d.id)).toList();
    techDone = true;
    emit();
  });

  controller.onCancel = () {
    sub1.cancel();
    sub2.cancel();
  };
  return controller.stream;
}
