class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final bool isOutOfStock;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.isOutOfStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['products_name'],
      imageUrl: json['image'],
      price: double.tryParse(json['MainPrice'].replaceAll(' EGP', '')) ?? 0.0,
      isOutOfStock: !json['is_available'],
    );
  }
}
