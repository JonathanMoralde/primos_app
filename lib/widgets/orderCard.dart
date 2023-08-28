// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/kitchen/models.dart';

import 'package:flutter/material.dart';

class OrderCardDropdown extends ConsumerWidget {
  final MapEntry<dynamic, dynamic> orderEntry;

  OrderCardDropdown({
    required this.orderEntry,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color backgroundColor = Color(0xFFD9D9D9); // Equivalent to #D9D9D9

    // Extract the order details from orderEntry.value
    final orderDetails = orderEntry.value['order_details'] as List<dynamic>?;
    final orderName = orderEntry.value['order_name'] as String?;

    if (orderDetails == null || orderName == null) {
      return SizedBox.shrink(); // Handle if the data is missing
    }

    final List<Order> ordersList = orderDetails.map<Order>((orderDetail) {
      final name = orderDetail['productName'] ?? 'No Name';
      final quantity = orderDetail['quantity'] ?? 0;
      final variation = orderDetail['variation'] ?? 'No Variation';
      final serveStatus = orderDetail['serve_status'] ?? 'Pending';

      return Order(
        name: name,
        quantity: quantity,
        variation: variation,
        serveStatus: serveStatus,
      );
    }).toList();

    Future checkboxModal(String dishName, int index) async {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        dishName,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Divider(height: 0),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text("Is this dish ready to be served?"),
                          const SizedBox(
                            height: 5,
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  "Confirming this will remove it from display",
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
                                      DatabaseReference productRef =
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child('orders')
                                              .child(orderEntry.key)
                                              .child('order_details')
                                              .child('$index');

                                      productRef.update({
                                        'serve_status': 'Served'
                                      }); // Change 'Served' to the desired status

                                      Navigator.of(context).pop();
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
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        border: Border.all(
          color: Color.fromARGB(255, 209, 209, 209),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: 380,
      child: ExpansionTile(
        backgroundColor: Color(0xFFD9D9D9),
        title: Text(
          orderName,
          style: TextStyle(letterSpacing: 1, fontSize: 20),
        ),
        subtitle: Text(
          orderName.contains("Takeout") ? "TAKEOUT" : "DINE-IN",
          style: const TextStyle(
            color: Color(0xFFFE3034),
            letterSpacing: 1,
            fontSize: 20,
          ),
        ),
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE2B563).withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Divider(
                  height: 0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(right: 10),
                        constraints: BoxConstraints(),
                        onPressed: null, icon: Icon(Icons.check_circle_outline),
                        color: Colors.transparent, // Make the icon transparent
                        disabledColor: Colors
                            .transparent, // Make the icon transparent when disabled
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Name",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Qty.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Var.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final (index, order) in ordersList.indexed)
                  if (order.serveStatus != 'Served')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.only(right: 10),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              checkboxModal(order.name, index);
                            },
                            icon: const Icon(
                                Icons.check_box_outline_blank_rounded),
                          ).animate().scale(),
                          Expanded(flex: 2, child: Text(order.name)),
                          Expanded(
                            flex: 1,
                            child: Text(order.quantity.toString()),
                          ),
                          Expanded(flex: 1, child: Text(order.variation)),
                        ],
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StyledButton(
                    btnIcon: const Icon(Icons.check),
                    btnText: "DONE",
                    onClick: () {
                      final List<Object?> orderDetails =
                          orderEntry.value['order_details'];
                      DatabaseReference orderRef = FirebaseDatabase.instance
                          .ref()
                          .child('orders')
                          .child(orderEntry.key);

                      // Inside the onClick function
                      for (int i = 0; i < orderDetails.length; i++) {
                        DatabaseReference productRef = FirebaseDatabase.instance
                            .ref()
                            .child('orders')
                            .child(orderEntry.key)
                            .child('order_details')
                            .child('$i');

                        // Update the serve_status for the specific order item
                        productRef.update({
                          'serve_status': 'Served'
                        }); // Change 'Served' to the desired status
                      }
                      orderRef.update({'order_status': 'DONE'});
                      // print(orderDetails);
                      // print(orderEntry.value['order_date']);
                    },
                    btnWidth: double.infinity,
                    noShadow: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
