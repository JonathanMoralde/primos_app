import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/kitchen/models.dart';

import 'package:flutter/material.dart';

class OrderCardDropdown extends ConsumerWidget {
  final String orderID;
  final List<Order> orders;

  OrderCardDropdown({
    required this.orderID,
    required this.orders,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color backgroundColor = Color(0xFFD9D9D9); // Equivalent to #D9D9D9
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9), // Set the background color for the container
        border: Border.all(
          color: Color.fromARGB(255, 209, 209, 209),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: 200,
      child: ExpansionTile(
        backgroundColor:
            Color(0xFFD9D9D9), // Set the background color for the ExpansionTile
        title: Text(
          'TABLE 1',
          style: TextStyle(letterSpacing: 1, fontSize: 20),
        ),
        subtitle: Text(
          "DINE-IN",
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Row(
                    children: [
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
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Var.",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final order in orders)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(order.name)),
                        Expanded(
                          child: Text(order.quantity.toString()),
                        ),
                        Expanded(child: Text(order.variation)),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StyledButton(
                    btnText: "DONE",
                    onClick: () {},
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
