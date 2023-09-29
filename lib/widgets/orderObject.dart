class OrderObject {
  final dynamic id;
  final String name;
  final double price;
  final String? variation;
  int quantity;
  final String imageUrl;
  final String? status;

  OrderObject(
      {required this.id,
      required this.name,
      required this.price,
      this.variation,
      required this.quantity,
      required this.imageUrl,
      this.status});
}
