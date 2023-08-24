import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesReportDetails extends ConsumerWidget {
  final String date;
  final List<String> orderKey;
  final AsyncValue<Map<dynamic, dynamic>> ordersStream;
  const SalesReportDetails(
      {super.key,
      required this.date,
      required this.orderKey,
      required this.ordersStream});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime originalDate = DateTime.parse(date);

    String formattedDate = DateFormat('MMMM dd, yyyy').format(originalDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ordersStream.when(
              data: (ordersMap) {
                final orderEntries = ordersMap.entries.toList();

                final List<Map<Object?, Object?>> orderData = [];

                for (final entry in orderEntries) {
                  final entryDate =
                      entry.value['order_date'].toString().split(' ')[0];
                  if (entryDate == date) {
                    // orderData.add(entry.value['order_details']);
                    for (final order in entry.value['order_details']) {
                      orderData.add(order);
                    }
                  }
                }

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
                    for (final order in orderData)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              (order['productName'] as String).toUpperCase(),
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
                                  : "No Variation",
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )
                  ],
                );
              },
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => CircularProgressIndicator()),
        ),
      )),
    );
  }
}
