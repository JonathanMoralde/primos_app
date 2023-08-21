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
        title: Text("ORDERS"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ordersStream.when(
              data: (ordersMap) {
                final orderEntries = ordersMap.entries.toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final entry in orderEntries)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: OrderCardDropdown(
                            orderID: entry.key,
                            orders: entry.value,
                          ),
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
