import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/admin/salesObject.dart';
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

                      // print(orderDate);

                      if (!salesData.containsKey(orderDate) &&
                          !salesDataKey.containsKey(orderDate)) {
                        salesData[orderDate] = [];
                        salesDataKey[orderDate] = [];
                      }

                      salesData[orderDate]!.add(orderData);
                      salesDataKey[orderDate]!.add(orderKey);
                    });

                    // print(salesData);
                    // print(salesDataKey);

                    final List<SalesObject> salesObjects = [];

                    salesData.forEach((date, orders) {
                      int totalBillAmount = 0;
                      double totalDiscount = 0.0;
                      double totalVat = 0.0;
                      double grandTotal = 0.0;

                      for (final order in orders) {
                        totalBillAmount += order['bill_amount'] as int;
                        totalDiscount += order['discount'] as double;
                        totalVat += order['vat'] as double;
                        grandTotal += order['total_amount'] as double;
                      }
                      // print(date);
                      // print(totalBillAmount);
                      // print(totalDiscount);
                      // print(totalVat);
                      // print(grandTotal);
                      // print(salesDataKey[date]!);

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

                    // print(salesObjects[0].date);
                    return Column(
                      children: [
                        for (final object in salesObjects)
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
                  loading: () => CircularProgressIndicator(),
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
