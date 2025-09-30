class SupplierItem {
  final String id;
  final String name;
  final String motoType; // e.g., "Yamaha", "Honda"
  final String model; // e.g., "R15", "CBR"
  final double price;
  final String imageUrl;
  final String logoUrl;

  SupplierItem({
    required this.id,
    required this.name,
    required this.motoType,
    required this.model,
    required this.price,
    required this.imageUrl,
    required this.logoUrl,
    
  });

  factory SupplierItem.fromFirestore(Map<String, dynamic> data, String id) {
    return SupplierItem(
      id: id,
      name: data['name'] ?? '',
      motoType: data['motoType'] ?? '',
      model: data['model'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
logoUrl: data['logoUrl'] ?? '',
      
    );
  }
}
