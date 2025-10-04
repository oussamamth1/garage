// lib/models/booking_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  readyForPickup,
  delivered,
  cancelled,
}

class BookingModel {
  final String id;
  final String customerId;
  final String bikeModel;
  final String plateNumber;
  final DateTime requestedDate;
  final String? serviceType;
  final String? description;
  final BookingStatus status;
  final DateTime createdAt;
  final int? mileage;
  final String? fuelLevel;
  final String? condition;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.bikeModel,
    required this.plateNumber,
    required this.requestedDate,
    this.serviceType,
    this.description,
    required this.status,
    required this.createdAt,
    this.mileage,
    this.fuelLevel,
    this.condition,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      bikeModel: data['bikeModel'] ?? '',
      plateNumber: data['plateNumber'] ?? '',
      requestedDate: (data['requestedDate'] as Timestamp).toDate(),
      serviceType: data['serviceType'],
      description: data['description'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      mileage: data['mileage'],
      fuelLevel: data['fuelLevel'],
      condition: data['condition'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'bikeModel': bikeModel,
      'plateNumber': plateNumber,
      'requestedDate': Timestamp.fromDate(requestedDate),
      'serviceType': serviceType,
      'description': description,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'mileage': mileage,
      'fuelLevel': fuelLevel,
      'condition': condition,
    };
  }
}
