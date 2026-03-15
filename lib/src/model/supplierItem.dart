class SupplierItem {
  final String id;
  final String name;
  final String motoType;
  final String model;
  final double price;
  final String imageUrl;
  final String logoUrl;
  final String sellerId; // uid of who added the item (seller)

  SupplierItem({
    required this.id,
    required this.name,
    required this.motoType,
    required this.model,
    required this.price,
    required this.imageUrl,
    required this.logoUrl,
    this.sellerId = '',
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
      sellerId: data['sellerId'] ?? '',
    );
  }
}
