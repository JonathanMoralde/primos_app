import 'package:flutter/material.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';

class OrderViewPage extends StatelessWidget {
  OrderViewPage({super.key});

  final cashController = TextEditingController();
  final discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future nextModal() => showDialog(
          barrierDismissible: false, // Prevent dismissal by tapping outside
          barrierColor: Colors.black54.withOpacity(
              0), //prevent the background from becoming more darker
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Receipt:",
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(height: 0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Bill Amount: "), Text("PHP 69")],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount Paid: "),
                          Text("PHP ${cashController.text}"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Discount: "),
                          Text(discountController.text.isEmpty
                              ? "0%"
                              : "${discountController.text}%"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change: "),
                          Text("PHP 999"),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyledButton(
                              btnText: "Back",
                              onClick: () {
                                Navigator.of(context).pop();
                              }),
                          StyledButton(
                              btnText: "Confirm & Print", onClick: () {}),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Future openModal() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Payment Method:",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
                Divider(height: 0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: cashController,
                          hintText: "Enter Amount",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: discountController,
                          hintText: "Enter Discount",
                          obscureText: false),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Cancel",
                                onClick: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Next",
                                onClick: () {
                                  nextModal();
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Future voidModal() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "WARNING!",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Are you sure you want to void this order?"),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Cancel",
                                  onClick: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Confirm", onClick: () {}),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));

    return Scaffold(
      appBar: AppBar(
        title: (Text("ORDER DETAILS TABLE 1")),
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
                      onClick: () {
                        voidModal();
                      },
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
