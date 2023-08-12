import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("ORDER DETAILS TABLE 1"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ORDER DETAILS
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WAITER",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("Jonnel Angel Red")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER DATE & TIME",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("20 March 2023 03:43 PM")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "BILL AMOUNT",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          // TODO CHANGE TO ACTUAL
                          Text("PHP 69")
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // ORDER ITEMS
                const Row(
                  children: [
                    Expanded(flex: 2, child: Text("ITEM")),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "VARIANT",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "QTY",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "PRICE",
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff252525), width: 0.5)),
                ),
                const SizedBox(
                  height: 10,
                ),

                // TODO CHANGE TO LISt OF ITEMS ORDERED
                // INDIV ITEMS
                const Row(
                  children: [
                    Expanded(flex: 2, child: Text("Beef Bulgogi")),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "1",
                          textAlign: TextAlign.end,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "69",
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: StyledButton(
                  btnText: "BACK TO TABLES",
                  onClick: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => WaiterTablePage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  btnColor: Color(0xfff8f8f7),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
