class Part {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String modelId; // Reference to MotoModel
  final String? imageUrl; // Reference to MotoModel
  final bool isOriginal;

  Part({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.modelId,
    this.isOriginal = true,
this.imageUrl
  });

  factory Part.fromMap(String id, Map<String, dynamic> data) {
    return Part(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      modelId: data['modelId'] ?? '',
      isOriginal: data['isOriginal'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'modelId': modelId,
      'isOriginal': isOriginal,
'imageUrl': imageUrl
    };
  }
}
