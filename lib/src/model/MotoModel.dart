class MotoModel {
  final String id;
  final String name;
  final int? year;
  final String brandId; // Reference to Brand
  final String? color; // optional
  final String? imageUrl; // optional
  final String? logo; // optional

  MotoModel({
    required this.id,
    required this.name,
    required this.year,
    required this.brandId,
    this.color,
    this.imageUrl,this.logo
  });

  factory MotoModel.fromMap(String id, Map<String, dynamic> data) {
    return MotoModel(
      id: id,
      name: data['name'] ?? '',
      year: data['year'] ?? 0,
      brandId: data['brandId'] ?? '',
      color: data['color'], // null if missing
      imageUrl: data['imageUrl']??'', // null if missing
      logo: data['logo']??'', // null if missing
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'year': year,
      'brandId': brandId,
      if (color != null) 'color': color,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
