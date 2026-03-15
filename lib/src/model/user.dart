class AppUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String photoUrl;
  final String photoBase64;

  AppUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.photoUrl,
    required this.photoBase64,
  });

  /// Supported roles: admin, technician, client. Legacy 'customer' maps to client.
  static String _normalizeRole(dynamic role) {
    final r = role?.toString() ?? 'client';
    if (r == 'customer') return 'client';
    if (r == 'admin' || r == 'technician' || r == 'client') return r;
    return 'client';
  }

  bool get isAdmin => role == 'admin';
  bool get isTechnician => role == 'technician';
  bool get isClient => role == 'client';

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      role: _normalizeRole(data['role']),
      photoUrl: data['photoUrl'] ?? '',
      photoBase64: data['photoBase64'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'photoUrl': photoUrl,
'photoBase64':photoBase64,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
