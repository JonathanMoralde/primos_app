import 'package:flutter/material.dart';

import 'package:primos_app/widgets/sideMenu.dart'; //side menu
import 'package:primos_app/widgets/pageObject.dart'; //page Class

class SalesReportPage extends StatelessWidget {
  SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      drawer: SideMenu(
        pages: adminPages,
      ),
      appBar: AppBar(
        title: const Text("SALES REPORT"),

        // automaticallyImplyLeading: false,
      ),
      body: const SafeArea(
        child: Center(
          child: Text("Sales Report Page"),
        ),
      ),
    );
  }
}
