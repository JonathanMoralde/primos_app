import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/providers/bottomNavBar/currentIndex_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

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
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("TAKE OUT ORDERS"),
      ),
      drawer: SideMenu(pages: waiterPages),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [Container()], //TODO ADD LIST OF TAKEOUT ORDERS HERE
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // When the floating action button is pressed, update the order name and last takeout number
          final currentDate = DateTime.now();
          final lastOrderDate = ref.watch(lastOrderDateProvider);

          if (lastOrderDate == null || currentDate.day != lastOrderDate.day) {
            ref.read(lastTakeoutNumberProvider.notifier).state = 1;
            ref.read(lastOrderDateProvider.notifier).state = currentDate;
          } else {
            ref.read(lastTakeoutNumberProvider.notifier).state += 1;
          }
          final int takeoutNum = ref.watch(lastTakeoutNumberProvider);
          final String orderName = "Takeout $takeoutNum";

          ref.read(orderNameProvider.notifier).state = orderName;

          print(ref.watch(orderNameProvider));

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
