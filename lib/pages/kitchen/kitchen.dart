import 'package:flutter/material.dart';
import 'package:primos_app/widgets/orderCard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

class KitchenPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);

    return Scaffold(
      drawer: SideMenu(pages: kitchenPages),
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: const Text("ORDERS"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ordersStream.when(
              data: (ordersMap) {
                final orderEntries = ordersMap.entries.toList();

                // Sort the orderEntries based on the order_date
                orderEntries.sort((a, b) {
                  final aDate = DateTime.parse(a.value['order_date']);
                  final bDate = DateTime.parse(b.value['order_date']);
                  return aDate.compareTo(bDate);
                });

                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final entry in orderEntries)
                        if (entry.value['order_status'] ==
                            'Pending') // Filter by order_status
                          OrderCardDropdown(
                            orderEntry: entry,
                          ),
                    ],
                  ),
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ),
        ),
      ),
    );
  }
}
