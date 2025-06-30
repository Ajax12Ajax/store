class Item {
  final String id;
  final String name;
  final String brand;
  final Dimensions dimensions;
  final List<String> materials;
  final String fit;
  final String color;
  final String category;
  final String image;
  final double price;

  Item({
    required this.id,
    required this.name,
    required this.brand,
    required this.dimensions,
    required this.materials,
    required this.fit,
    required this.color,
    required this.category,
    required this.image,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      dimensions: Dimensions.fromJson(json['dimensions']),
      materials: List<String>.from(json['materials']),
      fit: json['fit'],
      color: json['color'],
      category: json['category'],
      image: json['image'],
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
