import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/admin/salesReport_details.dart';
import 'package:primos_app/widgets/progressBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../providers/kitchen/models.dart';

class SalesCard extends StatelessWidget {
  final String date;
  final int totalBillAmount;
  final double totalDiscount;
  final double totalAmount;
  final double totalVat;
  final List<String> orderKey;
  final AsyncValue<Map<dynamic, dynamic>> allOrders;

  SalesCard({
    super.key,
    required this.date,
    required this.totalBillAmount,
    required this.totalDiscount,
    required this.totalAmount,
    required this.totalVat,
    required this.orderKey,
    required this.allOrders,
  });

  @override
  Widget build(BuildContext context) {
    DateTime originalDate = DateTime.parse(date);

    String formattedDate = DateFormat('MMMM dd, yyyy').format(originalDate);
    // print(date);
    // print(totalBillAmount);
    // print(totalDiscount);
    // print(totalAmount);
    // print(totalVat);
    // print(orderKey.length);
    return Container(
      width: 360,
      // height: 183,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3), // Changes the position of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Order: "),
                const SizedBox(
                  width: 30,
                ),
                Text(orderKey.length.toString())
              ],
            ),
            const Divider(
              height: 0,
              color: Color(0xff252525),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Gross Sales:"),
                Text('PHP ${totalBillAmount.toString()}'),
              ],
            ),
            const Divider(
              height: 0,
              color: Color(0xff252525),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total discounts given:"),
                Text(totalDiscount.toString()),
              ],
            ),
            const Divider(
              height: 0,
              color: Color(0xff252525),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Grand Total:"),
                Text('PHP ${totalAmount.toString()}'),
              ],
            ),
            const Divider(
              height: 0,
              color: Color(0xff252525),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total VAT amount:"),
                Text(totalVat.toString()),
              ],
            ),
            const Divider(
              height: 0,
              color: Color(0xff252525),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Net Income:"),
                Text('PHP ${(totalAmount - totalVat).toStringAsFixed(2)}'),
              ],
            ),
            const Divider(
              height: 0,
              color: Color(0xff252525),
            ),
            const SizedBox(
              height: 10,
            ),
            StyledButton(
              btnText: "Details",
              onClick: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SalesReportDetails(
                      date: date,
                      orderKey: orderKey,
                      ordersStream: allOrders,
                    ),
                  ),
                );
              },
              btnWidth: double.infinity,
              btnColor: const Color(0xFFE2B563),
              noShadow: true,
            )
          ],
        ),
      ),
    );
  }
}
