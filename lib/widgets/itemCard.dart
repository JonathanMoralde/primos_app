import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledButton.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 174,
      decoration: BoxDecoration(
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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Product Name"),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("PHP Price"),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledButton(
                          btnText: "Edit",
                          onClick: () {},
                          btnHeight: 30,
                        ),
                        StyledButton(
                          btnText: "Delete",
                          onClick: () {},
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
