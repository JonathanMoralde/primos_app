import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/takeout.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/tableBox.dart';

class WaiterTablePage extends StatefulWidget {
  const WaiterTablePage({super.key});

  @override
  State<WaiterTablePage> createState() => _WaiterTablePageState();
}

class _WaiterTablePageState extends State<WaiterTablePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      drawer: SideMenu(pages: waiterPages),
      appBar: AppBar(
        title: Text("TABLES"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                10, //! Replace this with the number of TableBox instances you want to generate
                (index) => FractionallySizedBox(
                  widthFactor: 0.31, // Take up 30% of available width
                  child: TableBox(
                      tableNum: index +
                          1), // You can use 'index + 1' if you want table numbers to start from 1
                ),
              ),
            ),
          ),
        ),
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
              setState(() {
                currentIndex = index;

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
              });
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
