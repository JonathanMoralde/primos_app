import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/adminMenu_Form.dart';
import 'package:primos_app/pages/admin/adminMenu_Form_Edit.dart';
import 'package:primos_app/widgets/styledButton.dart';

// ! TO CHANGE THE FOOTER SECTION
// PASS A WIDGET, EXAMPLE:
/* 
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children:[Text("TEST"), Text("TEST")]), 
*/

class ItemCard extends StatelessWidget {
  final String productName;
  final double productPrice;
  final Widget? widget;

  const ItemCard(
      {super.key,
      required this.productName,
      required this.productPrice,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 174,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                "https://thestayathomechef.com/wp-content/uploads/2021/02/Korean-Beef-Bulgogi-4.jpg", //replace image
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("$productPrice PHP"),
                    const SizedBox(
                      height: 8,
                    ),
                    // !FOOTER SECTION
                    widget != null
                        ? widget!
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyledButton(
                                noShadow: true,
                                btnText: "Edit",
                                onClick: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return AdminMenuFormEdit(
                                        productName: productName,
                                        productPrice: productPrice,
                                      );
                                    }),
                                  );
                                },
                                btnHeight: 30,
                              ),
                              StyledButton(
                                noShadow: true,
                                btnText: "Delete",
                                onClick: () {}, //TODO DELETE OR REMOVE FUNCTION
                                btnHeight: 30,
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
