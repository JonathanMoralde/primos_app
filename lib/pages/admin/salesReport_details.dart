import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/admin/salesObject.dart';
import 'package:primos_app/providers/filter/mode_provider.dart';
import 'package:primos_app/providers/filter/selectedDate_provider.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';

class SalesReportDetails extends ConsumerWidget {
  final String date;
  // final List<String> orderKey;
  // final AsyncValue<Map<dynamic, dynamic>> ordersStream;
  SalesReportDetails({
    super.key,
    required this.date,
    // required this.orderKey,
    // required this.ordersStream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);
    final viewMode = ref.watch(modeProvider);

    final dateRange1 = ref.watch(selectedDate1Provider);
    final dateRange2 = ref.watch(selectedDate2Provider);

    // TODO SPLIT DATE RANGE 1 & 2 AND GET [0] to GRAB THE DATE, THEN USE IT TO GRAB THE ORDER DETAILS FOR DATES IN RANGE

    String formattedDate = '';

    if (viewMode == "Individual") {
      DateTime originalDate = DateTime.parse(date);

      formattedDate = DateFormat('MMMM dd, yyyy').format(originalDate);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () {
            ref.refresh(ordersProvider);
            Navigator.of(context).pop();
          },
        ),
        title: Text(viewMode == "Summary" ? date : formattedDate),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ordersStream.when(
              data: (ordersMap) {
                final orderEntries = ordersMap.entries.toList();
                List<Map<Object?, Object?>> orderData = [];

                if (viewMode == "Summary") {
                  final String stringDate1 =
                      dateRange1.toString().split(" ")[0];
                  final String stringDate2 =
                      dateRange2.toString().split(" ")[0];

                  print(stringDate1);
                  print(stringDate2);

                  return Center(
                    child: const Text("This section is under maintenance"),
                  );
                }

                for (final entry in orderEntries) {
                  final entryDate =
                      entry.value['order_date'].toString().split(' ')[0];
                  if (entryDate == date) {
                    for (final order in entry.value['order_details']) {
                      orderData.add(order);
                    }
                  }
                }

                // after getting each order details, its time to merge those with the same values for product name & variation
                Map<String, Map<String, dynamic>> mergedData = {};

                for (var entry in orderData) {
                  String key = "${entry['productName']}_${entry['variation']}";

                  if (!mergedData.containsKey(key)) {
                    mergedData[key] = {
                      "productName": entry["productName"],
                      "variation": entry["variation"],
                      "quantity": entry["quantity"],
                    };
                  } else {
                    mergedData[key]!["quantity"] += entry["quantity"];
                  }
                }

                List<Map<String, dynamic>> result = mergedData.values.toList();
                // print(orderData);
                // print("merged DATA:");
                // print(result);

                return Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              "NAME",
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "QUANTITY",
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "VARIATION",
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 0,
                      color: Color(0xFF252525),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    for (final order in result)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (order['productName'] as String),
                                  style: TextStyle(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  order['quantity'].toString(),
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  order['variation'] != null
                                      ? order['variation'] as String
                                      : "-",
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          Divider(
                            height: 0,
                          ),
                          const SizedBox(
                            height: 3,
                          )
                        ],
                      ),
                  ],
                );
              },
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFE2B563),
                  ))),
        ),
      )),
    );
  }
}
