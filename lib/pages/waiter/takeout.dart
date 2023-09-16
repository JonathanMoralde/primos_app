import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/providers/bottomNavBar/currentIndex_provider.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:primos_app/providers/waiter_menu/isTakeout_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/takeout_orders.dart';

import '../../providers/waiter_menu/orderName_provider.dart';

class TakeoutPage extends ConsumerWidget {
  const TakeoutPage({super.key});

//   @override
//   State<TakeoutPage> createState() => _TakeoutPageState();
// }

// class _TakeoutPageState extends State<TakeoutPage> {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentIndex = ref.watch(currentIndex_provider);
    final ordersStream = ref.watch(ordersProvider);
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("TAKE OUT ORDERS"),
      ),
      drawer: SideMenu(pages: waiterPages),
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
                        if (entry.value['payment_status'] == 'Unpaid' &&
                            (entry.value['order_name'] as String)
                                .contains("Takeout"))
                          TakeoutOrdersWaiter(
                            orderEntry: entry,
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String orderName = "Takeout #${Random().nextInt(200)}";

          ref.read(orderNameProvider.notifier).state = orderName;

          ref.read(isTakeoutProvider.notifier).state = true;

          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return WaiterMenu();
            }),
          );
        },
        backgroundColor: Color(0xFFE2B563),
        foregroundColor: Color(0xff252525),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(currentIndex_provider.notifier).state = index;

              if (index == 0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return WaiterTablePage();
                  }),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return TakeoutPage();
                  }),
                );
              }
            },
            unselectedItemColor: Color(0xFF252525),
            selectedItemColor: Color(0xFFFE3034),
            backgroundColor: Color(0xFFE2B563),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.table_bar),
                label: "Dine-In",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.takeout_dining),
                label: "Takeout",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
