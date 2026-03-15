class Service {
  final String id;
  final String title;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  /// Owner of the service (technician uid).
  final String technicianId;
  /// 'repair' or 'sale'
  final String type;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    String? technicianId,
    String? type,
  })  : technicianId = technicianId ?? '',
        type = type == 'sale' ? 'sale' : 'repair';

  factory Service.fromFirestore(Map<String, dynamic> data, String id) {
    return Service(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      technicianId: data['technicianId'] ?? '',
      type: data['type'] == 'sale' ? 'sale' : 'repair',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'technicianId': technicianId,
      'type': type,
    };
  }
}
