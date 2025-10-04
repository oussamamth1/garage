// lib/models/job_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum JobStatus {
  pending,
  waitingApproval,
  approved,
  inProgress,
  completed,
  cancelled,
}

class JobTask {
  final String taskName;
  final String status;
  final String? notes;

  JobTask({required this.taskName, required this.status, this.notes});

  factory JobTask.fromMap(Map<String, dynamic> map) {
    return JobTask(
      taskName: map['taskName'] ?? '',
      status: map['status'] ?? 'pending',
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'taskName': taskName, 'status': status, 'notes': notes};
  }
}

class JobModel {
  final String id;
  final String bookingId;
  final String customerId;
  final String? assignedTechnicianId;
  final List<JobTask> tasks;
  final List<String> requiredParts;
  final JobStatus status;
  final double? estimatedCost;
  final bool supervisorApproval;
  final DateTime createdAt;
  final DateTime? completedAt;

  JobModel({
    required this.id,
    required this.bookingId,
    required this.customerId,
    this.assignedTechnicianId,
    required this.tasks,
    required this.requiredParts,
    required this.status,
    this.estimatedCost,
    this.supervisorApproval = false,
    required this.createdAt,
    this.completedAt,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      customerId: data['customerId'] ?? '',
      assignedTechnicianId: data['assignedTechnicianId'],
      tasks: (data['tasks'] as List? ?? [])
          .map((t) => JobTask.fromMap(t as Map<String, dynamic>))
          .toList(),
      requiredParts: List<String>.from(data['requiredParts'] ?? []),
      status: JobStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => JobStatus.pending,
      ),
      estimatedCost: data['estimatedCost']?.toDouble(),
      supervisorApproval: data['supervisorApproval'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'customerId': customerId,
      'assignedTechnicianId': assignedTechnicianId,
      'tasks': tasks.map((t) => t.toMap()).toList(),
      'requiredParts': requiredParts,
      'status': status.name,
      'estimatedCost': estimatedCost,
      'supervisorApproval': supervisorApproval,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
    };
  }
}

