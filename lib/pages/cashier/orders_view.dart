// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/providers/kitchen/models.dart';

// TODO REFACTOR HARD CODED TO USE DATA FROM DB
// TODO ADD BLUETOOTH FUNCTIONALITY IN PRINT BUTTON

class OrderViewPage extends StatelessWidget {
  final MapEntry<dynamic, dynamic> orderEntry;
  OrderViewPage({super.key, required this.orderEntry});

  final cashController = TextEditingController();
  final discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Extract the order details from orderEntry.value
    final orderDetails = orderEntry.value['order_details'] as List<dynamic>?;
    final orderName = orderEntry.value['order_name'] as String?;
    // final totalAmount = orderEntry.value['total_amount'] as int?;
    final orderDate = DateTime.parse(orderEntry.value['order_date']);
    final waiterName = orderEntry.value['served_by'] as String?;
    String formattedDate =
        DateFormat('dd-MM-yyyy hh:mm a').format(orderDate.toLocal());

    if (orderDetails == null || orderName == null) {
      return SizedBox.shrink(); // Handle if the data is missing
    }

    if (orderDetails == null || orderName == null) {
      return SizedBox.shrink(); // Handle if the data is missing
    }

    final List<Order> ordersList = orderDetails.map<Order>((orderDetail) {
      final name = orderDetail['productName'] ?? 'No Name';
      final quantity = orderDetail['quantity'] ?? 0;
      final variation = orderDetail['variation'] ?? 'No Variation';
      final price = orderDetail['productPrice'] ?? 0;

      return Order(
        name: name,
        quantity: quantity,
        variation: variation,
        price: price,
        // orderName: orderName,
      );
    }).toList();

    int totalAmount = ordersList.fold(0, (int sum, Order order) {
      return sum + (order.quantity * order.price!.toInt());
    });

    double calculateDiscountedPrice(
        double originalPrice, double discountPercentage) {
      return originalPrice - (originalPrice * (discountPercentage / 100));
    }

    Future nextModal(double discountedTotal) => showDialog(
          barrierDismissible: false, // Prevent dismissal by tapping outside
          barrierColor: Colors.black54.withOpacity(
              0), //prevent the background from becoming more darker
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Receipt:",
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(height: 0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount Received: "),
                          Text("PHP ${cashController.text}"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Bill Amount: "),
                          Text("PHP $totalAmount")
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "VAT 12% ",
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            (totalAmount! * 0.12).toStringAsFixed(2),
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount: "),
                          Text(discountController.text.isEmpty
                              ? "0%"
                              : "${discountController.text}%"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Amount: "),
                          Text(discountedTotal.toStringAsFixed(2)),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change: "),
                          Text(
                              "PHP ${(int.parse(cashController.text) - discountedTotal).toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledButton(
                              btnText: "Back",
                              onClick: () {
                                Navigator.of(context).pop();
                              }),
                          StyledButton(
                              btnText: "Confirm & Print",
                              onClick: () {
                                DatabaseReference orderRef = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child('orders')
                                    .child(orderEntry.key);

                                orderRef.update({'bill_amount': totalAmount});
                                orderRef
                                    .update({'total_amount': discountedTotal});
                                orderRef.update({
                                  'discount': (totalAmount *
                                      (double.parse(discountController.text) /
                                          100))
                                });
                                orderRef.update({
                                  'vat': (totalAmount * 0.12).toStringAsFixed(2)
                                });
                                orderRef.update({'payment_status': 'Paid'});

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return OrdersPage();
                                }), (route) => false);
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Future openModal() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Payment Method:",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
                Divider(height: 0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: cashController,
                          hintText: "Enter Amount Received",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: discountController,
                          hintText: "Enter Discount %",
                          obscureText: false),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Cancel",
                                onClick: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Next",
                                onClick: () {
                                  double discountedTotal =
                                      calculateDiscountedPrice(
                                          totalAmount.toDouble(),
                                          discountController.text.isEmpty
                                              ? 0
                                              : double.parse(
                                                  discountController.text));
                                  // print(discountedTotal);
                                  nextModal(discountedTotal);
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Future voidModal() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "WARNING!",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Are you sure you want to void this order?"),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                            ),
                            SizedBox(
                                width:
                                    4), // Adding a small gap between the icon and text
                            Flexible(
                              child: Text(
                                "Confirming this action can not be undone",
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Cancel",
                                  onClick: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Confirm",
                                  onClick: () {
                                    DatabaseReference orderRef =
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child('orders')
                                            .child(orderEntry.key);

                                    orderRef.remove().then((_) {
                                      print('Entry deleted successfully');
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  OrdersPage()),
                                          (route) => false);
                                    }).catchError((error) {
                                      print('Error deleting entry: $error');
                                    });
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: (Text("ORDER DETAILS $orderName")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ORDER DETAILS
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WAITER",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(waiterName ?? "Waiter")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER DATE & TIME",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          // Text("20 March 2023 03:43 PM")
                          Text(formattedDate)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SUBTOTAL",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("PHP $totalAmount")
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // ORDER ITEMS
                const Row(
                  children: [
                    Expanded(flex: 1, child: Text("ITEM")),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "QTY",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "VARIANT",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "UNIT PRICE",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "TOTAL PRICE",
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff252525), width: 0.5)),
                ),
                const SizedBox(
                  height: 10,
                ),

                // TODO CHANGE TO LISt OF ITEMS ORDERED
                // INDIV ITEMS

                for (final order in ordersList)
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text(order.name)),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.quantity.toString(),
                            textAlign: TextAlign.end,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.variation == "No Variation"
                                ? "N/A"
                                : order.variation,
                            textAlign: TextAlign.end,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.price.toString(),
                            textAlign: TextAlign.end,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            (order.price! * order.quantity).toString(),
                            textAlign: TextAlign.end,
                          )),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StyledButton(
                btnText: "PAYMENT",
                onClick: () {
                  openModal();
                },
                btnColor: const Color(0xFFf8f8f7),
                noShadow: true,
                btnWidth: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      btnText: "VOID",
                      onClick: () {
                        voidModal();
                      },
                      btnColor: const Color(0xFFf8f8f7),
                      noShadow: true,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      btnText: "PRINT",
                      onClick: () {},
                      btnColor: const Color(0xFFf8f8f7),
                      noShadow: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
