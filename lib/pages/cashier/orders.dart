import 'package:flutter/material.dart';
import 'package:primos_app/widgets/orders_cashier.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f7),
      appBar: AppBar(title: const Text("ORDERS")),
      drawer: SideMenu(pages: cashierPages),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            OrdersCashier(orderNum: 1),
            OrdersCashier(orderNum: 1),
            OrdersCashier(orderNum: 1),
          ],
        ),
      )),
    );
  }
}
