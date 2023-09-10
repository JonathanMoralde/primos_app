import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/admin/salesObject.dart';
import 'package:primos_app/providers/filter/isDateRange_provider.dart';
import 'package:primos_app/providers/filter/isSingleDate_provider.dart';
import 'package:primos_app/providers/filter/selectedDate_provider.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:primos_app/providers/sales/allSales_provider.dart';
import 'package:primos_app/widgets/filterExpansion.dart';
import 'package:primos_app/widgets/salesCard.dart';

import 'package:primos_app/widgets/sideMenu.dart'; //side menu
import 'package:primos_app/widgets/pageObject.dart';

class SalesReportPage extends ConsumerWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);

// FILTERING
    final isDateRange = ref.watch(isDateRangeProvider);

    final dateRange1 = ref.watch(selectedDate1Provider);
    final dateRange2 = ref.watch(selectedDate2Provider);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      drawer: SideMenu(
        pages: adminPages,
      ),
      appBar: AppBar(
        title: const Text("SALES REPORT"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                FilterExpansion(),
                SizedBox(
                  height: 20,
                ),
                ordersStream.when(
                  data: (ordersMap) {
                    final orderEntries = ordersMap.entries.toList();

                    final Map<String, List<Map<Object?, Object?>>> salesData =
                        {};
                    final Map<String, List<String>> salesDataKey = {};

                    orderEntries.forEach((entry) {
                      final orderKey = entry.key;
                      final orderData = entry.value;
                      final orderDate =
                          orderData['order_date'].toString().split(' ')[0];

                      if (!salesData.containsKey(orderDate) &&
                          !salesDataKey.containsKey(orderDate)) {
                        salesData[orderDate] = [];
                        salesDataKey[orderDate] = [];
                      }

                      salesData[orderDate]!.add(orderData);
                      salesDataKey[orderDate]!.add(orderKey);
                    });

                    final List<SalesObject> salesObjects = [];

                    salesData.forEach((date, orders) {
                      int totalBillAmount = 0;
                      double totalDiscount = 0.0;
                      double totalVat = 0.0;
                      double grandTotal = 0.0;

                      for (final order in orders) {
                        final orderDiscount = order['discount'];
                        totalBillAmount += order['bill_amount'] as int;
                        totalDiscount += (order['discount'] as num).toDouble();
                        totalVat += (order['vat'] as num).toDouble();
                        grandTotal += (order['total_amount'] as num).toDouble();
                      }

                      salesObjects.add(SalesObject(
                        date: date,
                        totalBillAmount:
                            totalBillAmount, // calculate total bill amount,
                        totalDiscount:
                            totalDiscount, // calculate total discount,
                        totalAmount: grandTotal, // calculate total amount,
                        totalVat: totalVat, // calculate total VAT,
                        orderKey: salesDataKey[date]!,
                      ));
                    });

                    // Inside the ordersStream.when data callback
                    List<SalesObject> filteredSalesObjects = [];

                    if (isDateRange) {
                      // Display sales objects falling within the selected date range
                      filteredSalesObjects = salesObjects.where((object) {
                        final dateParsed = DateTime.parse(object.date);

                        return (dateParsed.isAfter(dateRange1!) ||
                                dateParsed.isAtSameMomentAs(dateRange1!)) &&
                            (dateParsed.isBefore(dateRange2!) ||
                                dateParsed.isAtSameMomentAs(dateRange2!));
                      }).toList();
                    } else {
                      // Display all sales objects
                      filteredSalesObjects = salesObjects;
                    }

                    // Sort the filteredSalesObjects list based on the date in descending order (most recent to older)
                    filteredSalesObjects.sort((a, b) {
                      final dateA = DateTime.parse(a.date);
                      final dateB = DateTime.parse(b.date);
                      return dateB
                          .compareTo(dateA); // Compare in descending order
                    });

                    return Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        for (final object in filteredSalesObjects)
                          SalesCard(
                              date: object.date,
                              totalBillAmount: object.totalBillAmount,
                              totalDiscount: object.totalDiscount,
                              totalAmount: object.totalAmount,
                              totalVat: object.totalVat,
                              orderKey: object.orderKey,
                              allOrders: ordersStream)
                      ],
                    );
                  },
                  loading: () => Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFE2B563),
                  )),
                  error: (error, stackTrace) => Text('Error: $error'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
