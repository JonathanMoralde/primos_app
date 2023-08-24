import 'package:flutter/material.dart';
import 'package:primos_app/pages/cashier/orders_view.dart';
import 'package:primos_app/pages/waiter/orderDetails.dart';

class TakeoutOrdersWaiter extends StatelessWidget {
  // final dynamic? orderNum;
  // final void Function()? onPressed;
  final MapEntry<dynamic, dynamic> orderEntry;

  const TakeoutOrdersWaiter({super.key, required this.orderEntry});

  @override
  Widget build(BuildContext context) {
    final orderName = orderEntry.value['order_name'] as String?;
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
            backgroundColor: const Color(0xFFE2B563),
            foregroundColor: const Color(0xFF252525),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(orderName!),
            ],
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    OrderDetailsPage(orderKey: orderEntry.key),
              ),
            );
          },
        ),
      ),
    );
  }
}
