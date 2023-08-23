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
                    for (final order in orderData)
                      Row(
                        children: [
                          Text(order['productName'] as String),
                          Text(order['quantity'].toString()),
                          Text(order['variation'] as String)
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
