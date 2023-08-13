import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

class TakeoutPage extends StatefulWidget {
  const TakeoutPage({super.key});

  @override
  State<TakeoutPage> createState() => _TakeoutPageState();
}

class _TakeoutPageState extends State<TakeoutPage> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
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
              children: [Container()],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                label: "Tables",
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
