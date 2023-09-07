// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/pages/cashier/print_page.dart';
import 'package:primos_app/providers/session/user_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/providers/kitchen/models.dart';

class OrderViewPage extends ConsumerWidget {
  final MapEntry<dynamic, dynamic> orderEntry;
  OrderViewPage({super.key, required this.orderEntry});

  final cashController = TextEditingController();
  final discountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late bool servicePermission = false;
    late LocationPermission permission;

    Future<Position> getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('service disabled');
      }
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }

    // Extract the order details from orderEntry.value
    final orderDetails = orderEntry.value['order_details'] as List<dynamic>?;
    final orderName = orderEntry.value['order_name'] as String?;
    // final totalAmount = orderEntry.value['total_amount'] as int?;
    final orderDate = DateTime.parse(orderEntry.value['order_date']);
    final waiterName = orderEntry.value['served_by'] as String?;
    String formattedDate =
        DateFormat('dd-MM-yyyy hh:mm a').format(orderDate.toLocal());
    final cashierName = ref.read(userNameProvider);

    if (orderDetails == null || orderName == null) {
      return SizedBox.shrink(); // Handle if the data is missing
    }

    if (orderDetails == null || orderName == null) {
      return SizedBox.shrink(); // Handle if the data is missing
    }

    final List<Order> ordersList = orderDetails.map<Order>((orderDetail) {
      final name = orderDetail['productName'] ?? 'No Name';
      final quantity = orderDetail['quantity'] ?? 0;
      final variation = orderDetail['variation'] ?? '-';
      final price = orderDetail['productPrice'] ?? 0;

      return Order(
        name: name,
        quantity: quantity,
        variation: variation,
        price: price,
        // orderName: orderName,
      );
    }).toList();

    int totalAmount = ordersList.fold(0, (int sum, Order order) {
      return sum + (order.quantity * order.price!.toInt());
    });

    double calculateDiscountedPrice(
        double originalPrice, double discountPercentage) {
      return originalPrice - (originalPrice * (discountPercentage / 100));
    }

    String generateUniqueReferenceNumber() {
      // Generate a timestamp
      DateTime now = DateTime.now();
      String timestamp = now.microsecondsSinceEpoch.toString();

      // Generate a random number
      Random random = Random();
      String randomComponent = random.nextInt(1000).toString().padLeft(3, '0');

      // Combine timestamp and random number to create the reference number
      String referenceNumber = '$timestamp$randomComponent';

      return referenceNumber;
    }

    Future nextModal(double discountedTotal) => showDialog(
          barrierDismissible: false, // Prevent dismissal by tapping outside
          barrierColor: Colors.black54.withOpacity(
              0), //prevent the background from becoming more darker
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Receipt:",
                      textAlign: TextAlign.left,
                      style: TextStyle(letterSpacing: 1),
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount Received: ",
                            ),
                            Text(
                                "PHP ${double.parse(cashController.text).toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bill Amount: ",
                            ),
                            Text("PHP ${totalAmount.toStringAsFixed(2)}")
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "VAT 12% ",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              (totalAmount! * 0.12).toStringAsFixed(2),
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount: ",
                            ),
                            Text(discountController.text.isEmpty
                                ? "0%"
                                : "${discountController.text}%"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount: ",
                            ),
                            Text("PHP ${discountedTotal.toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Change: ",
                            ),
                            Text(
                                "PHP ${(int.parse(cashController.text) - discountedTotal).toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StyledButton(
                                btnText: "Back",
                                onClick: () {
                                  Navigator.of(context).pop();
                                }),
                            StyledButton(
                                btnText: "Confirm & Print",
                                onClick: () async {
                                  // ! DATAS THAT NEED TO BE SENT TO THE PRINT PAGE:
                                  // ! DATE
                                  // ! ORDER NUMBER
                                  // ! ORDER REFERENCE NUMBER
                                  // payment method
                                  // ! ROLE + WAITER NAME
                                  // ! ORDER DETAILS/DESCRIPTION
                                  // ! SUBTOTAL
                                  // ! VAT
                                  // ! DISCOUNTS
                                  // ! GRAND TOTAL
                                  // ! AMOUNT PAID
                                  // ! CASHIER NAME
                                  String referenceNumber =
                                      generateUniqueReferenceNumber();

                                  double vatAmount = totalAmount * 0.12;
                                  double discountAmount = (totalAmount *
                                      (double.parse(
                                              discountController.text.isNotEmpty
                                                  ? discountController.text
                                                  : "0") /
                                          100));
                                  double amountReceived =
                                      double.parse(cashController.text);
                                  double changeAmount =
                                      (int.parse(cashController.text) -
                                          discountedTotal);

                                  DatabaseReference orderRef = FirebaseDatabase
                                      .instance
                                      .ref()
                                      .child('orders')
                                      .child(orderEntry.key);

                                  orderRef.update({'bill_amount': totalAmount});
                                  orderRef.update(
                                      {'total_amount': discountedTotal});
                                  orderRef.update({'discount': discountAmount});
                                  orderRef.update({'vat': vatAmount});
                                  orderRef.update({'payment_status': 'Paid'});
                                  orderRef
                                      .update({'receipt_ref': referenceNumber});

                                  // Location location = new Location();
                                  // bool _serviceEnabled;
                                  // LocationData _locationData;

                                  // _serviceEnabled =
                                  //     await location.serviceEnabled();
                                  // if (!_serviceEnabled) {
                                  //   _serviceEnabled =
                                  //       await location.requestService();
                                  //   if (!_serviceEnabled) {
                                  //     debugPrint('Location Denied once');
                                  //   }
                                  // }

                                  await getCurrentLocation();
                                  if (Platform.isAndroid) {
                                    await FlutterBluePlus.turnOn();
                                  }

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return PrintPage(
                                        formattedDate: formattedDate,
                                        orderName: orderName,
                                        receiptNum: referenceNumber,
                                        waiterName: waiterName!,
                                        orderDetails: orderDetails,
                                        subtotal: totalAmount.toDouble(),
                                        vatAmount: vatAmount,
                                        discountAmount: discountAmount,
                                        grandTotal: discountedTotal,
                                        amountReceived: amountReceived,
                                        changeAmount: changeAmount,
                                        cashierName: cashierName!,
                                      );
                                    }),
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

    Future openModal() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Payment Method:",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
                Divider(height: 0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: cashController,
                          hintText: "Enter Amount Received",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: discountController,
                          hintText: "Enter Discount %",
                          obscureText: false),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Cancel",
                                onClick: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Next",
                                onClick: () {
                                  if (cashController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Please enter amount received!")),
                                    );
                                  } else {
                                    double discountedTotal =
                                        calculateDiscountedPrice(
                                            totalAmount.toDouble(),
                                            discountController.text.isEmpty
                                                ? 0
                                                : double.parse(
                                                    discountController.text));

                                    if (double.parse(cashController.text) <
                                        discountedTotal) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Please enter the right amount!")),
                                      );
                                    } else {
                                      nextModal(discountedTotal);
                                    }
                                  }
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Future voidModal() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "WARNING!",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Are you sure you want to void this order?"),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                            ),
                            SizedBox(
                                width:
                                    4), // Adding a small gap between the icon and text
                            Flexible(
                              child: Text(
                                "Confirming this action can not be undone",
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Cancel",
                                  onClick: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Confirm",
                                  onClick: () {
                                    DatabaseReference orderRef =
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child('orders')
                                            .child(orderEntry.key);

                                    orderRef.remove().then((_) {
                                      print('Entry deleted successfully');
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  OrdersPage()),
                                          (route) => false);
                                    }).catchError((error) {
                                      print('Error deleting entry: $error');
                                    });
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: (Text("ORDER DETAILS ${orderName.toUpperCase()}")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ORDER DETAILS
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WAITER",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(waiterName ?? "Waiter")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER DATE & TIME",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(formattedDate)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SUBTOTAL",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text("PHP ${totalAmount.toStringAsFixed(2)}")
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // ORDER ITEMS
                const Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "ITEM",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "QTY",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "VARIANT",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "UNIT PRICE",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "TOTAL PRICE",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff252525), width: 0.5)),
                ),
                const SizedBox(
                  height: 10,
                ),

                for (final order in ordersList)
                  Row(
                    children: [
                      Expanded(flex: 2, child: Text(order.name)),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.quantity.toString(),
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.variation == "No Variation"
                                ? "-"
                                : order.variation,
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            order.price.toString(),
                            textAlign: TextAlign.end,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            (order.price! * order.quantity).toString(),
                            textAlign: TextAlign.end,
                          )),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StyledButton(
                btnIcon: const Icon(Icons.payments),
                btnText: "PAYMENT",
                onClick: () {
                  openModal();
                },
                btnColor: const Color(0xFFf8f8f7),
                noShadow: true,
                btnWidth: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      btnIcon: Icon(Icons.remove_circle),
                      btnText: "VOID",
                      onClick: () {
                        voidModal();
                      },
                      btnColor: const Color(0xFFf8f8f7),
                      noShadow: true,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      btnIcon: Icon(Icons.print),
                      btnText: "PRINT BILL",
                      onClick: () async {
                        // check adapter availability
                        // if (await FlutterBluePlus.isAvailable == false) {
                        //   print("Bluetooth not supported by this device");
                        //   return;
                        // }

                        // turn on bluetooth ourself if we can
                        // for iOS, the user controls bluetooth enable/disable
                        // Location location = new Location();
                        // bool _serviceEnabled;
                        // LocationData _locationData;

                        // _serviceEnabled = await location.serviceEnabled();
                        // if (!_serviceEnabled) {
                        //   _serviceEnabled = await location.requestService();
                        //   if (!_serviceEnabled) {
                        //     debugPrint('Location Denied once');
                        //   }
                        // }

                        await getCurrentLocation();
                        if (Platform.isAndroid) {
                          await FlutterBluePlus.turnOn();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PrintPage(
                                formattedDate: formattedDate,
                                orderName: orderName,
                                waiterName: waiterName!,
                                orderDetails: orderDetails,
                                subtotal: totalAmount.toDouble(),
                                cashierName: cashierName!,
                              ),
                            ),
                          );
                        }
                      },
                      btnColor: const Color(0xFFf8f8f7),
                      noShadow: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
