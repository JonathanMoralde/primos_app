class Order {
  final String? productId;
  final String name;
  final int quantity;
  final String variation;
  final int? price;
  final String? serveStatus;

  Order({
    this.productId,
    required this.name,
    required this.quantity,
    required this.variation,
    this.price,
    this.serveStatus,
  });
}
