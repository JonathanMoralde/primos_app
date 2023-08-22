import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/providers/isAdditionalOrder/existingOrderId_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/existingOrder_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/isAdditionalOrder_provider.dart';
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

    ordersStream.when(
        data: (ordersMap) {
          final orderEntries = ordersMap.entries.toList();
          for (final entry in orderEntries) {
            if (tableName == entry.value['order_name'] &&
                entry.value['payment_status'] == 'Unpaid') {
              isOccupied = true;
              tableEntry = entry.value;
              tableEntryId = entry.key;

              break;
            }
          }
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => CircularProgressIndicator());

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
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        StyledButton(
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
                        StyledButton(
                          btnText: "View Order",
                          onClick: () {},
                          btnWidth: double.infinity,
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

    print(isOccupied);

    return GestureDetector(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color:
              isOccupied ? Color.fromARGB(208, 254, 48, 51) : Color(0xFFE2B563),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tableName,
              style: TextStyle(
                  fontSize: 16, letterSpacing: 1, fontWeight: FontWeight.w600),
            ),
            isOccupied
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Occupied",
                    ))
                : const SizedBox(),
          ],
        ),
      ),
      onTap: () {
        if (isOccupied) {
          tableModal();
          return;
        }
        ref.read(orderNameProvider.notifier).state = tableName;
        print(ref.watch(orderNameProvider));
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return WaiterMenu();
          }),
        );
      },
    );
  }
}
