import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/widgets/orders_cashier.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

import '../../providers/kitchen/orderDetails_Provider.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f7),
      appBar: AppBar(title: const Text("ORDERS")),
      drawer: SideMenu(pages: cashierPages),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ordersStream.when(
          data: (ordersMap) {
            final orderEntries = ordersMap.entries.toList();

            // Sort the orderEntries based on the order_date
            orderEntries.sort((a, b) {
              final aDate = DateTime.parse(a.value['order_date']);
              final bDate = DateTime.parse(b.value['order_date']);
              return aDate.compareTo(bDate);
            });

            return Column(
              children: [
                for (final entry in orderEntries)
                  if (entry.value['payment_status'] ==
                      'Unpaid') // Filter by order_status
                    Consumer(
                      builder: (context, ref, child) {
                        return OrdersCashier(
                          orderEntry: entry,
                        );
                      },
                    ),
              ],
            );
          },
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => Center(
              child: CircularProgressIndicator(
            color: Color(0xFFE2B563),
          )),
        ),
      ))),
    );
  }
}
