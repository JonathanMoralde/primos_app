class SalesObject {
  final String date;
  final int totalBillAmount;
  final double totalDiscount;
  final double totalAmount;
  final double totalVat;
  List<String> orderKey;

  SalesObject(
      {required this.date,
      required this.totalBillAmount,
      required this.totalDiscount,
      required this.totalAmount,
      required this.totalVat,
      required this.orderKey});
}
