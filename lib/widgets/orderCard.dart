import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledButton.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TABLE 1",
                  style: TextStyle(letterSpacing: 1, fontSize: 20),
                ),
                Text(
                  "DINE-IN",
                  style: TextStyle(
                      color: Color(0xFFFE3034), letterSpacing: 1, fontSize: 20),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 5),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Qty.",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Var.",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12),
                    ))
              ],
            ),
          ),
          const Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Column(
              children: [
                // TODO REPLACE NAME, QTY., VAR. WITH ORDER DETAILS
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Name",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Qty.",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Var.",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Name",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Qty.",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Var.",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StyledButton(
              btnText: "DONE",
              onClick: () {},
              btnWidth: double.infinity,
              noShadow: true,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
