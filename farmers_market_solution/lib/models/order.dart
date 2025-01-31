class Order {
  final String id;
  final String customerName;
  final List<String> products;
  final double totalAmount;
  final String status;

  Order({
    required this.id,
    required this.customerName,
    required this.products,
    required this.totalAmount,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customerName'],
      products: List<String>.from(json['products']),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'products': products,
      'totalAmount': totalAmount,
      'status': status,
    };
  }
}
