class Brand {
  final String id;
  final String name;
  final String? logo;

  Brand({required this.id, required this.name, this.logo});

  factory Brand.fromMap(String id, Map<String, dynamic> data) {
    return Brand(id: id, name: data['name'] ?? '', logo: data['logo']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'logo': logo};
  }
  factory Brand.fromFirestore(Map<String, dynamic> data, String id) {
    return Brand(
      id: id,
      name: data['name'] ?? '',
      // motoType: data['motoType'] ?? '',
      // model: data['model'] ?? '',
      // price: (data['price'] ?? 0).toDouble(),
      // imageUrl: data['imageUrl'] ?? '',
logo: data['logo'] ?? '',
      
    );
  }

}
