import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/orderDetails.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/itemCard.dart';
import 'package:primos_app/widgets/styledButton.dart';

class WaiterMenuCart extends StatelessWidget {
  const WaiterMenuCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("CURRENT ORDERS"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ItemCard(
                  productId: "test",
                  productName: "test",
                  productPrice: 69,
                  isRow: true,
                  cardHeight: 150,
                  footerSection: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Variation: Large"),
                        Row(
                          children: [
                            Text("Quantity"),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TOTAL AMOUNT: ",
                    style: TextStyle(letterSpacing: 1),
                  ),
                  Text(
                    "PHP 9999",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, letterSpacing: 1),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: StyledButton(
                      btnColor: Color(0xfff8f8f7),
                      btnText: "CONFIRM ORDER",
                      onClick: () {
                        // TODO SEND REAL TIME ORDER TO KITCHEN AND CASHIER
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return OrderDetailsPage();
                          }),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
