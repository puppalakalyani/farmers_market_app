class Product {
  final String id;
  final String farmerId;
  final String name;
  final String description;
  final double price;
  final String unit;
  final int quantity;
  final String imageUrl;
  final DateTime listedDate;

  Product({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.quantity,
    required this.imageUrl,
    required this.listedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'listedDate': listedDate.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      farmerId: json['farmerId'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      unit: json['unit'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      listedDate: DateTime.parse(json['listedDate']),
    );
  }
}
