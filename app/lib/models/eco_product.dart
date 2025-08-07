class EcoProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  EcoProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  factory EcoProduct.fromMap(Map<String, dynamic> data, String documentId) {
    return EcoProduct(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
