import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/pages/waiter/takeout.dart';
import 'package:primos_app/providers/isAdditionalOrder/isAdditionalOrder_provider.dart';
import 'package:primos_app/providers/kitchen/models.dart';
import 'package:primos_app/providers/waiter_menu/currentOrder_provider.dart';
import 'package:primos_app/providers/waiter_menu/isTakeout_provider.dart';
import 'package:primos_app/providers/waiter_menu/orderName_provider.dart';
import 'package:primos_app/providers/waiter_menu/subtotal_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../../providers/kitchen/orderDetails_Provider.dart';
import '../../widgets/orderObject.dart';

class OrderDetailsPage extends ConsumerWidget {
  final String orderKey;
  const OrderDetailsPage({super.key, required this.orderKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);

    final orderName = ref.watch(orderNameProvider);
    final isTakeout = ref.watch(isTakeoutProvider);
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("ORDER DETAILS ${orderName?.toUpperCase()}"),
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

                      final singleOrderEntry = orderEntries.firstWhere(
                        (entry) => entry.key == orderKey,
                      );

                      final waiterName = singleOrderEntry.value['served_by'];
                      final orderDate =
                          DateTime.parse(singleOrderEntry.value['order_date']);
                      final orderData = singleOrderEntry.value['order_details']
                          as List<dynamic>?;

                      String formattedDate = DateFormat('dd-MM-yyyy hh:mm a')
                          .format(orderDate.toLocal());

                      final List<Order> ordersList =
                          orderData!.map<Order>((orderDetail) {
                        final name = orderDetail['productName'] ?? 'No Name';
                        final quantity = orderDetail['quantity'] ?? 0;
                        final variation =
                            orderDetail['variation'] ?? 'No Variation';
                        final serveStatus =
                            orderDetail['serve_status'] ?? 'Pending';
                        final price = orderDetail['productPrice'] as int;

                        return Order(
                          name: name,
                          quantity: quantity,
                          variation: variation,
                          serveStatus: serveStatus,
                          price: price,
                        );
                      }).toList();

                      int totalAmount =
                          ordersList.fold(0, (int sum, Order order) {
                        return sum + (order.quantity * order.price!.toInt());
                      });

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
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "ITEM",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "QTY",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "VARIANT",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "UNIT PRICE",
                                    textAlign: TextAlign.end,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    "TOTAL PRICE",
                                    textAlign: TextAlign.end,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
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

                          for (final order in ordersList)
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      order.name,
                                      style: TextStyle(
                                          color: order.serveStatus == "Served"
                                              ? Colors.green.shade700
                                              : Color.fromARGB(
                                                  255, 189, 151, 82)),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    order.quantity.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: order.serveStatus == "Served"
                                            ? Colors.green.shade700
                                            : Color.fromARGB(
                                                255, 189, 151, 82)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    order.variation == "No Variation"
                                        ? "-"
                                        : order.variation,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: order.serveStatus == "Served"
                                            ? Colors.green.shade700
                                            : Color.fromARGB(
                                                255, 189, 151, 82)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    order.price.toString(),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: order.serveStatus == "Served"
                                            ? Colors.green.shade700
                                            : Color.fromARGB(
                                                255, 189, 151, 82)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    (order.price! * order.quantity).toString(),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: order.serveStatus == "Served"
                                            ? Colors.green.shade700
                                            : Color.fromARGB(
                                                255, 189, 151, 82)),
                                  ),
                                ),
                              ],
                            )
                        ],
                      );
                    },
                    error: (error, stackTrace) => Text('Error: $error'),
                    loading: () => CircularProgressIndicator()),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration:
                                  BoxDecoration(color: Colors.green.shade700),
                            ).animate().scale(),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Read to be served"),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration:
                                  BoxDecoration(color: Color(0xFFE2B563)),
                            ).animate().scale(),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Preparing"),
                          ],
                        ),
                      ],
                    )
                  ],
                )
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
                  btnIcon: Icon(Icons.subdirectory_arrow_left_rounded),
                  btnText: isTakeout ? "BACK TO TAKEOUTS" : "BACK TO TABLES",
                  onClick: () {
                    // reset states
                    ref.read(currentOrdersProvider.notifier).state = [];
                    ref.read(isAdditionalOrderProvider.notifier).state = false;
                    ref.read(orderNameProvider.notifier).state = null;
                    ref.read(subtotalProvider.notifier).state = 0.0;

                    // Reset isTakeout to false
                    if (isTakeout) {
                      ref.read(isTakeoutProvider.notifier).state = false;
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        if (isTakeout) {
                          return TakeoutPage();
                        } else {
                          return WaiterTablePage();
                        }
                      }),
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
