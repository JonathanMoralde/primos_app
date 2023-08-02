import 'package:flutter/material.dart';
import 'package:primos_app/widgets/progressBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

class SalesCard extends StatelessWidget {
  final dynamic date;
  const SalesCard({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 183,
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
            Text(
              "$date",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text("Total Order % based on target: (10)"),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  flex: 1,
                  child: ProgressBar(
                    value: 0.35,
                  ),
                )
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(style: BorderStyle.solid, width: 0.5),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Total Sales:"), Text("6969 PHP")],
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(style: BorderStyle.solid, width: 0.5),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StyledButton(
              btnText: "Details",
              onClick: () {},
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
