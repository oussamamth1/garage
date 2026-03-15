import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String clientId;
  final String technicianId;
  final String serviceId;
  final String serviceName;
  final String serviceType; // 'repair' | 'sale'
  final double price;
  final String status; // pending, accepted, rejected, in_progress, completed
  final String? description;
  final String? motoType;
  final DateTime? clientRequestedAt;
  final DateTime? clientPreferredDateTime;
  final DateTime? technicianAcceptedAt;
  final DateTime? estimatedReadyAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.clientId,
    required this.technicianId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceType,
    required this.price,
    required this.status,
    this.description,
    this.motoType,
    this.clientRequestedAt,
    this.clientPreferredDateTime,
    this.technicianAcceptedAt,
    this.estimatedReadyAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      clientId: data['clientId'] ?? '',
      technicianId: data['technicianId'] ?? '',
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      serviceType: data['serviceType'] == 'sale' ? 'sale' : 'repair',
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      description: data['description'] as String?,
      motoType: data['motoType'] as String?,
      clientRequestedAt: _parseDateTime(data['clientRequestedAt']),
      clientPreferredDateTime: _parseDateTime(data['clientPreferredDateTime']),
      technicianAcceptedAt: _parseDateTime(data['technicianAcceptedAt']),
      estimatedReadyAt: _parseDateTime(data['estimatedReadyAt']),
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
    );
  }

  static DateTime? _parseTimestamp(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    return null;
  }

  static DateTime? _parseDateTime(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }
}
