import 'package:flutter/material.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

class OrderViewPage extends StatelessWidget {
  const OrderViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future openModal() => showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text("Payment Method:"),
              content: Text("Test"),
            ));

    return Scaffold(
      appBar: AppBar(
        title: (Text("ORDER DETAILS")),
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
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StyledButton(
                btnText: "PAYMENT",
                onClick: () {
                  openModal();
                },
                btnColor: const Color(0xFFf8f8f7),
                noShadow: true,
                btnWidth: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      btnText: "VOID",
                      onClick: () {},
                      btnColor: const Color(0xFFf8f8f7),
                      noShadow: true,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      btnText: "PRINT",
                      onClick: () {},
                      btnColor: const Color(0xFFf8f8f7),
                      noShadow: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
