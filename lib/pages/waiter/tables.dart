import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/tableBox.dart';

class WaiterTablePage extends StatelessWidget {
  const WaiterTablePage({super.key});

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
                10, // Replace this with the number of TableBox instances you want to generate
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
    );
  }
}
