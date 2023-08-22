// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    final totalAmount = orderEntry.value['total_amount'] as int?;
    final orderDate = orderEntry.value['order_date'];
    final waiterName = orderEntry.value['served_by'] as String?;

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

    Future nextModal() => showDialog(
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
                        children: [Text("Bill Amount: "), Text("PHP 69")],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount Paid: "),
                          Text("PHP ${cashController.text}"),
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
                          Text("Change: "),
                          Text("PHP 999"),
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
                              btnText: "Confirm & Print", onClick: () {}),
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
                          hintText: "Enter Amount",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: discountController,
                          hintText: "Enter Discount",
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
                                  nextModal();
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
                                  btnText: "Confirm", onClick: () {}),
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
                          Text(orderDate)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "BILL AMOUNT",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          // TODO CHANGE TO ACTUAL
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
                    Expanded(flex: 2, child: Text("ITEM")),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "VARIANT",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "QTY",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "PRICE",
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
                      Expanded(flex: 2, child: Text(order.name)),
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
                            order.quantity.toString(),
                            textAlign: TextAlign.end,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.price.toString(),
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
