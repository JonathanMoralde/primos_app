import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/waiter/orderDetails.dart';
import 'package:primos_app/providers/waiter_menu/currentOrder_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/itemCard.dart';
import 'package:primos_app/widgets/orderObject.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../../providers/waiter_menu/subtotal_provider.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(currentOrdersProvider);
    // double totalAmount = orderData.fold(0, (double sum, OrderObject order) {
    //   return sum + (order.price * order.quantity);
    // });
    double totalAmount = calculateSubtotal(orderData);

    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("CURRENT ORDERS"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: orderData.length,
            itemBuilder: (BuildContext context, int index) {
              OrderObject order = orderData[index];

              print(order);
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
                              : SizedBox(),
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

                                  print(ref.watch(currentOrdersProvider));
                                  // setState(() {
                                  //   widget.onDelete(index);
                                  // });
                                },
                                icon: Icon(Icons.delete),
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
                  Text(
                    "TOTAL AMOUNT: ",
                    style: TextStyle(letterSpacing: 1),
                  ),
                  Text(
                    "PHP ${ref.watch(subtotalProvider)}",
                    style: TextStyle(
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
                      btnColor: Color(0xfff8f8f7),
                      btnText: "CONFIRM ORDER",
                      onClick: () {
                        // TODO SEND REAL TIME ORDER TO KITCHEN AND CASHIER

                        if (orderData.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return OrderDetailsPage(
                                orderData: orderData,
                                totalAmount: totalAmount,
                              );
                            }),
                          );
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
