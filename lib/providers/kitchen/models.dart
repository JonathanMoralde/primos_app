class Order {
  final String name;
  final int quantity;
  final String variation;
  final int? price;

  Order({
    required this.name,
    required this.quantity,
    required this.variation,
    this.price,
  });
}
