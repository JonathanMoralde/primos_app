import 'package:flutter/material.dart';
import 'package:primos_app/widgets/orders_cashier.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

//* WAYS:
//  FETCH ORDERS DATA HERE IN PARENT WIDGET AND STORE IN RIVERPOD FOR STATE MANAGEMENT
//  OR FETCH DATA USING RIVERPOD TO BE CALLED HERE AND STORE STATES IN RIVERPOD
// FETCH ORDERS DATA AND PASS IT AS PARAMETER IN OrdersCashier Widget (ALSO EDIT OrdersCashier CONSTRUCTOR)

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f7),
      appBar: AppBar(title: const Text("ORDERS")),
      drawer: SideMenu(pages: cashierPages),
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ), //TODO CREATE DYNAMIC LIST
            OrdersCashier(orderNum: 1),
            OrdersCashier(orderNum: 1),
            OrdersCashier(orderNum: 1),
          ],
        ),
      )),
    );
  }
}
