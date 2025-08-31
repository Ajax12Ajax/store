class Product {
  final int id;
  final String category;
  final String name;
  final String brand;
  final Dimensions dimensions;
  final List<String> materials;
  final String fit;
  final String color;
  final double price;

  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.brand,
    required this.dimensions,
    required this.materials,
    required this.fit,
    required this.color,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      brand: json['brand'],
      dimensions: Dimensions.fromJson(json['dimensions']),
      materials: List<String>.from(json['materials']),
      fit: json['fit'],
      color: json['color'],
      price: json['price'].toDouble(),
    );
  }
}

class Dimensions {
  final double width;
  final double height;
  final double length;

  const Dimensions({required this.width, required this.height, required this.length});

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      length: json['length'].toDouble(),
    );
  }
}
