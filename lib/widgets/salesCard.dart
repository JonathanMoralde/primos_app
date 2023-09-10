import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/admin/salesReport_details.dart';
import 'package:primos_app/providers/filter/isExpanded_provider.dart';
import 'package:primos_app/widgets/progressBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../providers/kitchen/models.dart';

class SalesCard extends StatefulWidget {
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
  State<SalesCard> createState() => _SalesCardState();
}

class _SalesCardState extends State<SalesCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    DateTime originalDate = DateTime.parse(widget.date);

    String formattedDate = DateFormat('MMMM dd, yyyy').format(originalDate);

    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool currentlyExpanded) {
            setState(() {
              isExpanded = !currentlyExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontSize: 16,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Orders: "),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(widget.orderKey.length.toString())
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
                        Text(
                            'PHP ${widget.totalBillAmount.toStringAsFixed(2)}'),
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
                        Text('PHP ${widget.totalDiscount.toStringAsFixed(2)}'),
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
                        Text('PHP ${widget.totalAmount.toStringAsFixed(2)}'),
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
                        Text('PHP ${widget.totalVat.toStringAsFixed(2)}'),
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
                        const Text(
                          "Total Sales:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'PHP ${(widget.totalAmount - widget.totalVat).toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 0,
                      color: Color(0xff252525),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StyledButton(
                      btnIcon: const Icon(Icons.remove_red_eye_rounded),
                      btnText: "View Sold Dishes",
                      onClick: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SalesReportDetails(
                              date: widget.date,
                              orderKey: widget.orderKey,
                              // ordersStream: widget.allOrders,
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
              isExpanded: isExpanded,
            ),
          ],
        ),
      ),
    );
  }
}
