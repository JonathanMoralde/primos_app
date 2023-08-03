import 'package:flutter/material.dart';
import 'package:primos_app/widgets/filterExpansion.dart';
import 'package:primos_app/widgets/salesCard.dart';

import 'package:primos_app/widgets/sideMenu.dart'; //side menu
import 'package:primos_app/widgets/pageObject.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      drawer: SideMenu(
        pages: adminPages,
      ),
      appBar: AppBar(
        title: const Text("SALES REPORT"),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                FilterExpansion(),
                SizedBox(
                  height: 20,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
                SizedBox(
                  height: 10,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
                SizedBox(
                  height: 10,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
                SizedBox(
                  height: 10,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
