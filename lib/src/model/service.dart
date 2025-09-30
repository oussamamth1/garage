class Service {
  final String id;
  final String title;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  Service({
    required this.id,
    required this.title,
    required this.description,
required this.imageUrl,
required this.name,
    required this.price,
  });

  factory Service.fromFirestore(Map<String, dynamic> data, String id) {
    return Service(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
}
