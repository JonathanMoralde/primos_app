// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          style: TextStyle(
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
              borderRadius: BorderRadius.all(
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
                          // textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Var.",
                          // textAlign: TextAlign.end,
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
                              padding: EdgeInsets.only(right: 10),
                              constraints: BoxConstraints(),
                              onPressed: () {
                                // TODO ADD A MODAL TO CONFIRM BEFORE UPDATING ITEM STATUS
                                // TODO ADD WAITER PUSH NOTIF
                                DatabaseReference productRef = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child('orders')
                                    .child(orderEntry.key)
                                    .child('order_details')
                                    .child('$index');

                                productRef.update({
                                  'serve_status': 'Served'
                                }); // Change 'Served' to the desired status
                              },
                              icon:
                                  Icon(Icons.check_box_outline_blank_rounded)),
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
