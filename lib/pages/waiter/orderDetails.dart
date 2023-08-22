import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/providers/waiter_menu/orderName_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../../providers/kitchen/orderDetails_Provider.dart';
import '../../widgets/orderObject.dart';

// * issues encountered: using ListView.builder inside a column or singleChildScrollView() causes an error
// * solution: used map instead

class OrderDetailsPage extends ConsumerWidget {
  // final List<OrderObject> orderData;
  // final double totalAmount;
  final String orderKey;
  const OrderDetailsPage({super.key, required this.orderKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);

    final orderName = ref.watch(orderNameProvider);
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // TODO REMOVE BACK BUTTON TO PREVENT GOING BACK TO CART
        title: Text("ORDER DETAILS $orderName"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ordersStream.when(
                    data: (ordersMap) {
                      final orderEntries = ordersMap.entries.toList();

                      // Assuming orderEntries is a list of MapEntry<dynamic, dynamic>
                      final singleOrderEntry = orderEntries.firstWhere(
                        (entry) => entry.key == orderKey,
                      );

                      final waiterName = singleOrderEntry.value['served_by'];
                      final orderDate =
                          DateTime.parse(singleOrderEntry.value['order_date']);

                      String formattedDate = DateFormat('dd-MM-yyyy hh:mm a')
                          .format(orderDate.toLocal());

                      // TODO EXTRACT THE ORDER DETAILS AND CALCULATE THE TOTAL AMOUNT
                      // TODO RESET THE STATES WHEN BACK TO TABLES IS CLICKED

                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "WAITER",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(waiterName ?? "Waiter")
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ORDER DATE & TIME",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(formattedDate)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "BILL AMOUNT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    // TODO CHANGE TO ACTUAL
                                    Text("PHP total amount")
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
                                    color: const Color(0xff252525),
                                    width: 0.5)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () => CircularProgressIndicator()),
                //     // ORDER DETAILS

                // ...orderData.map((OrderObject order) {
                //   return Row(
                //     children: [
                //       Expanded(flex: 2, child: Text(order.name)),
                //       Expanded(
                //         flex: 1,
                //         child: Text(
                //           order.variation ?? "",
                //           textAlign: TextAlign.end,
                //         ),
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Text(
                //           order.quantity.toString(),
                //           textAlign: TextAlign.end,
                //         ),
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Text(
                //           order.price.toString(),
                //           textAlign: TextAlign.end,
                //         ),
                //       ),
                //     ],
                //   );
                // }).toList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: StyledButton(
                  btnText: "BACK TO TABLES",
                  onClick: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => WaiterTablePage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  btnColor: Color(0xfff8f8f7),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
