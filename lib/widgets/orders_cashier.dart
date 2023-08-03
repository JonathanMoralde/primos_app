import 'package:flutter/material.dart';

class OrdersCashier extends StatelessWidget {
  final int orderNum;
  void Function()? onPressed;

  OrdersCashier({super.key, required this.orderNum, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE2B563),
            foregroundColor: Color(0xFF252525),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Table $orderNum"),
            ],
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
