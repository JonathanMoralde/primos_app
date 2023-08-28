import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/waiter/orderDetails.dart';
import 'package:primos_app/providers/isAdditionalOrder/existingOrderId_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/existingOrder_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/isAdditionalOrder_provider.dart';
import 'package:primos_app/providers/session/user_provider.dart';
import 'package:primos_app/providers/waiter_menu/currentOrder_provider.dart';
import 'package:primos_app/providers/waiter_menu/orderName_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/itemCard.dart';
import 'package:primos_app/widgets/orderObject.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../../providers/waiter_menu/subtotal_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class WaiterMenuCart extends ConsumerWidget {
  // final List<OrderObject> orderData;

  const WaiterMenuCart({
    Key? key,
    // required this.orderData,
  }) : super(key: key);

  double calculateSubtotal(List<OrderObject> orders) {
    return orders.fold(0, (double sum, OrderObject order) {
      return sum + (order.price * order.quantity);
    });
  }

  void updateSubtotal(WidgetRef ref) {
    final currentOrders = ref.watch(currentOrdersProvider);
    // final subtotalState = ref.watch(subtotalProvider);
    // subtotalState.state = calculateSubtotal(currentOrders);
    ref.read(subtotalProvider.notifier).state =
        calculateSubtotal(currentOrders);
  }

  void insertData(
      List<OrderObject> orderData, WidgetRef ref, BuildContext context) async {
    final databaseReference = FirebaseDatabase.instance;

    // Get the current date in the desired format
    final String currentDate = DateTime.now().toString();
    final String tableName = ref.watch(orderNameProvider).toString();
    final double totalAmount = ref.watch(subtotalProvider);
    final waiterName = ref.watch(userNameProvider);

    // Generate a new unique key for the order
    final newOrderRef = databaseReference.ref().child('orders').push();

    // Prepare order details in the required format
    List<Map<String, dynamic>> orderDetails = orderData
        .map((order) => {
              'productId': order.id,
              'productName': order.name,
              'productPrice': order.price,
              'quantity': order.quantity,
              'variation': order.variation,
              'serve_status': "Pending",
            })
        .toList();

    // Prepare the order object
    Map<String, dynamic> order = {
      'order_name': tableName,
      'order_date': currentDate,
      'total_amount': 0.0,
      'order_details': orderDetails,
      'served_by': waiterName,
      'order_status': 'Pending',
      'payment_status': 'Unpaid',
      'bill_amount': 0,
      'discount': 0.0,
      'vat': 0.0
    };

    // Insert the order data using the generated key
    await newOrderRef.set(order);

    // Retrieve the generated key
    final String generatedKey = newOrderRef.key!;

    // Clear the current orders after successful insertion
    ref.read(currentOrdersProvider.notifier).state = [];

    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return OrderDetailsPage(
          // orderData: orderData,
          // totalAmount: totalAmount,
          orderKey: generatedKey,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdditionalOrder = ref.watch(isAdditionalOrderProvider);
    final orderData = ref.watch(currentOrdersProvider);
    double totalAmount = calculateSubtotal(orderData);

    return Scaffold(
      backgroundColor: const Color(0xfff8f8f7),
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("CURRENT ORDERS"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: orderData.length,
            itemBuilder: (BuildContext context, int index) {
              OrderObject order = orderData[index];

              return Column(
                children: [
                  ItemCard(
                    productId: order.id,
                    productName: order.name,
                    productPrice: order.price,
                    imageUrl: order.imageUrl,
                    isRow: true,
                    cardHeight: order.variation != null ? 150 : 130,
                    footerSection: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          order.variation != null
                              ? Text("Variation: ${order.variation}")
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Quantity: ${order.quantity.toString()}"),
                              IconButton(
                                onPressed: () {
                                  orderData.removeAt(index);
                                  ref
                                      .read(currentOrdersProvider.notifier)
                                      .state = orderData;
                                  updateSubtotal(ref);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TOTAL AMOUNT: ",
                    style: TextStyle(letterSpacing: 1),
                  ),
                  Text(
                    "PHP ${ref.watch(subtotalProvider)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, letterSpacing: 1),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: StyledButton(
                      btnIcon: Icon(Icons.subdirectory_arrow_right_rounded),
                      btnColor: const Color(0xfff8f8f7),
                      btnText: "CONFIRM ORDER",
                      onClick: () {
                        if (orderData.isNotEmpty) {
                          if (isAdditionalOrder) {
                            final existingOrder =
                                ref.watch(existingOrderProvider);
                            final existingOrderId =
                                ref.watch(existingOrderIdProvider);
                            final String currentDate =
                                DateTime.now().toString();

                            List<dynamic>? orderDetails =
                                existingOrder!['order_details'];

                            List<Map<String, dynamic>> newOrder = orderData
                                .map((order) => {
                                      'productId': order.id,
                                      'productName': order.name,
                                      'productPrice': order.price,
                                      'quantity': order.quantity,
                                      'variation': order.variation,
                                      'serve_status': "Pending",
                                    })
                                .toList();

                            // Convert the existing fixed-length list to a mutable list
                            if (orderDetails != null) {
                              orderDetails = List.from(orderDetails);
                              // Merge the two lists
                              orderDetails.addAll(newOrder);

                              // Now 'orderDetails' contains both the existing order details and the new order details
                              print(orderDetails);

                              DatabaseReference orderRef = FirebaseDatabase
                                  .instance
                                  .ref()
                                  .child('orders')
                                  .child(existingOrderId!);

                              orderRef.update({'order_date': currentDate});
                              orderRef.update({'order_details': orderDetails});
                              orderRef.update({'order_status': 'Pending'});
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OrderDetailsPage(
                                          orderKey: existingOrderId),
                                ),
                              );
                            }
                          } else {
                            insertData(orderData, ref, context);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "You currently don't have an order",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
