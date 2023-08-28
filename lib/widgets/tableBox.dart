import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primos_app/pages/waiter/orderDetails.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/providers/isAdditionalOrder/existingOrderId_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/existingOrder_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/isAdditionalOrder_provider.dart';
import 'package:primos_app/providers/kitchen/models.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:primos_app/providers/waiter_menu/orderName_provider.dart';
import 'package:primos_app/widgets/styledButton.dart';

// STATE MANAGEMENT
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableBox extends ConsumerWidget {
  final String tableName;
  TableBox({super.key, required this.tableName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isOccupied = false;
    final ordersStream = ref.watch(ordersProvider);
    Map<dynamic, dynamic>? tableEntry;
    String? tableEntryId;
    List<dynamic>? orderData;
    List<Order>? ordersList;
    String? orderStatus;
    int servedCount = 0;
    int pendingCount = 0;

    ordersStream.when(
        data: (ordersMap) {
          final orderEntries = ordersMap.entries.toList();
          for (final entry in orderEntries) {
            if (tableName == entry.value['order_name'] &&
                entry.value['payment_status'] == 'Unpaid') {
              isOccupied = true;
              tableEntry = entry.value;
              tableEntryId = entry.key;
              orderData = entry.value['order_details'];
              orderStatus = entry.value['order_status'];

              break;
            }
          }
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => CircularProgressIndicator());

    if (orderData != null) {
      ordersList = orderData!.map<Order>((orderDetail) {
        final name = orderDetail['productName'] ?? 'No Name';
        final quantity = orderDetail['quantity'] ?? 0;
        final variation = orderDetail['variation'] ?? 'No Variation';
        final serveStatus = orderDetail['serve_status'] ?? 'Pending';
        final price = orderDetail['productPrice'] as int;

        if (serveStatus == 'Served') {
          servedCount++;
        } else if (serveStatus == 'Pending') {
          pendingCount++;
        }

        return Order(
          name: name,
          quantity: quantity,
          variation: variation,
          serveStatus: serveStatus,
          price: price,
        );
      }).toList();
    }

    Future tableModal() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        StyledButton(
                          btnIcon: const Icon(Icons.add),
                          btnText: "Additional Order",
                          onClick: () {
                            ref.read(orderNameProvider.notifier).state =
                                tableName;
                            ref.read(isAdditionalOrderProvider.notifier).state =
                                true;
                            ref.read(existingOrderProvider.notifier).state =
                                tableEntry;
                            ref.read(existingOrderIdProvider.notifier).state =
                                tableEntryId;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => WaiterMenu(),
                              ),
                            );
                          },
                          btnWidth: double.infinity,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Badge(
                          backgroundColor: Color.fromARGB(208, 255, 66, 69),
                          offset: Offset(-35, -5),
                          label: Row(children: [
                            Row(
                              children: [
                                Text(
                                  servedCount.toString(),
                                  style: const TextStyle(
                                      color: Color(0xff252525),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Color(0xff252525),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  pendingCount.toString(),
                                  style: const TextStyle(
                                      color: Color(0xff252525),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                const Icon(
                                  Icons.more_horiz,
                                  size: 14,
                                  color: Color(0xff252525),
                                )
                              ],
                            )
                          ]),
                          child: StyledButton(
                            btnIcon: const Icon(Icons.remove_red_eye),
                            btnText: "View Order",
                            onClick: () {
                              ref.read(orderNameProvider.notifier).state =
                                  tableName;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OrderDetailsPage(orderKey: tableEntryId!),
                                ),
                              );
                            },
                            btnWidth: double.infinity,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));

    return GestureDetector(
      child: Badge(
        backgroundColor: orderStatus == "DONE"
            ? Colors.greenAccent
            : const Color(0xFFE2B563),
        largeSize: 20,
        offset: const Offset(0, -10),
        label: Icon(
          orderStatus == "DONE" ? Icons.check : Icons.more_horiz,
          size: 18,
        ).animate(target: orderStatus == "DONE" ? 1 : 0).shake(),
        isLabelVisible: isOccupied,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xff252525).withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
            color: isOccupied
                ? const Color.fromARGB(208, 255, 66, 69)
                : const Color(0xFFE2B563),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tableName,
                style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              isOccupied
                  ? const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Occupied",
                      ))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      onTap: () {
        if (isOccupied) {
          tableModal();
          return;
        }
        ref.read(orderNameProvider.notifier).state = tableName;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return WaiterMenu();
          }),
        );
      },
    );
  }
}
