import 'package:flutter/material.dart';
import 'package:primos_app/widgets/filterExpansion.dart';
import 'package:primos_app/widgets/salesCard.dart';

import 'package:primos_app/widgets/sideMenu.dart'; //side menu
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDatepicker.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  // DateTime? selectedDate1;
  // DateTime? selectedDate2;
  // DateTime? selectedDate3;

  // void onDateSelected1(DateTime? date) {
  //   setState(() {
  //     selectedDate1 = date;
  //   });
  // }

  // void onDateSelected2(DateTime? date) {
  //   setState(() {
  //     selectedDate2 = date;
  //   });
  // }

  // void onDateSelected3(DateTime? date) {
  //   setState(() {
  //     selectedDate2 = date;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      drawer: SideMenu(
        pages: adminPages,
      ),
      appBar: AppBar(
        title: const Text("SALES REPORT"),

        // automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(8.0),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFf8f8f7),
                //     borderRadius: BorderRadius.all(Radius.circular(8)),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.25),
                //         spreadRadius: 0,
                //         blurRadius: 5,
                //         offset: const Offset(
                //             0, 2), // Changes the position of the shadow
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       const Align(
                //         alignment: Alignment.centerLeft,
                //         child: Text("Filter to specific date range:"),
                //       ),
                //       const SizedBox(
                //         height: 10,
                //       ),
                //       Row(
                //         //DATE RANGE PICKER
                //         children: [
                //           const Text("From "),
                //           Expanded(
                //             flex: 1,
                //             child: SizedBox(
                //               width: 120,
                //               child: StyledDatepicker(
                //                   onDateSelected: onDateSelected1),
                //             ),
                //           ),
                //           const Text(" to "),
                //           Expanded(
                //             flex: 1,
                //             child: SizedBox(
                //               width: 120,
                //               child: StyledDatepicker(
                //                 onDateSelected: onDateSelected2,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(
                //         height: 10,
                //       ),
                //       SizedBox(
                //         width: double.infinity,
                //         child: StyledButton(
                //             btnText: "FILTER",
                //             onClick: () {
                //               // TODO FILTER BY DATE RANGE API
                //             }),
                //       ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //       const Align(
                //         //FILTER BY SINGLE DATE
                //         alignment: Alignment.centerLeft,
                //         child: Text("Filter to a single date:"),
                //       ),
                //       const SizedBox(
                //         height: 10,
                //       ),
                //       Row(
                //         children: [
                //           Expanded(
                //             flex: 1,
                //             child: StyledDatepicker(
                //                 onDateSelected: onDateSelected3),
                //           ),
                //           const SizedBox(
                //             width: 10,
                //           ),
                //           Expanded(
                //             flex: 1,
                //             child: StyledButton(
                //               btnText: "FILTER",
                //               onClick: () {
                //                 //TODO FILTER BY SINGLE DATE API
                //                 setState(() {
                //                   selectedDate1 = null;
                //                   selectedDate2 = null;
                //                   selectedDate3 = null;
                //                 });
                //               },
                //             ),
                //           )
                //         ],
                //       ),
                //       const SizedBox(
                //         height: 20,
                //       ),
                //       SizedBox(
                //         width: double.infinity,
                //         child: StyledButton(
                //             btnText: "RESET DATE",
                //             onClick: () {
                //               // TODO RESET DISPLAY AND STATE
                //             }),
                //       )
                //     ],
                //   ),
                // ),
                FilterExpansion(),
                const SizedBox(
                  height: 20,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
                const SizedBox(
                  height: 10,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
                const SizedBox(
                  height: 10,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
                const SizedBox(
                  height: 10,
                ),
                SalesCard(
                  date: "July 31, 2023",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
