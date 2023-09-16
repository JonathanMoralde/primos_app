// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/cashier/print_page.dart';
import 'package:primos_app/providers/cashier/discountAmount_provider.dart';
import 'package:primos_app/providers/cashier/vatPercentage_provider.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:primos_app/providers/session/user_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDropdown.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/providers/kitchen/models.dart';

class OrderViewPage extends ConsumerWidget {
  final MapEntry<dynamic, dynamic> orderEntry;
  OrderViewPage({super.key, required this.orderEntry});

  final cashController = TextEditingController();
  final discountController = TextEditingController();
  final referenceNumController = TextEditingController();

  final tablePersonNumController = TextEditingController();
  final seniorOrPwdNumController = TextEditingController();
  final highestPriceController = TextEditingController();

  // final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);
    final cashierName = ref.read(userNameProvider);
    final vatPercentage = ref.watch(vatPercentageProvider);
    late bool servicePermission = false;
    late LocationPermission permission;

    double? percentage;

    // ! GET VAT PERCENTAGE
    if (vatPercentage is AsyncData<int>) {
      percentage = (vatPercentage.value / 100);
      // Now you can use 'percentage' as the VAT percentage value
      print('VAT Percentage: $percentage');
    } else if (vatPercentage is AsyncError) {
      final error = vatPercentage.error;
      // Handle the error if needed
      print('Error: $error');
    }

    // ! TURN ON LOCATION
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

    // ! DISCOUNT AMOUNT
    double discountAmount = ref.watch(discountAmountProvider);

    double calculateDiscountedAmount(
        double originalPrice, double personNum, double seniorOrPwdNum) {
      double vat = (1 + percentage!);
      return originalPrice / personNum * seniorOrPwdNum / vat * 0.32;
    }

    double calculateTakeoutDiscountAmout(double price) {
      double vat = (1 + percentage!);
      return price / vat * 0.32;
    }

// ! GENERATE RECEIPT NUMBER
    Future<String> generateReceiptNumber() async {
      // Fetch the latest incrementing number from Firestore
      final firestore.DocumentReference docRef = firestore
          .FirebaseFirestore.instance
          .collection('receiptNumbers')
          .doc('counter');

      // Use a transaction to ensure atomicity
      final firestore.DocumentSnapshot docSnapshot = await firestore
          .FirebaseFirestore.instance
          .runTransaction((firestore.Transaction transaction) async {
        return await transaction.get(docRef);
      });

      int receiptNumberCounter = 1;

      // If there is a previous counter, increment it
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        receiptNumberCounter = data['counter'] as int;
        receiptNumberCounter++; // Increment the counter
      }

      // Store the new incremented counter in Firestore
      await docRef.set({'counter': receiptNumberCounter});

      final DateTime now = DateTime.now();
      final DateFormat dateFormat = DateFormat('ddMMyyyy');
      final String formattedDate = dateFormat.format(now);

      // Create the receipt number string
      final String receiptNumber = '$formattedDate$receiptNumberCounter';

      return receiptNumber;
    }

    Future nextModal(
            double discountedTotal,
            String method,
            String? referenceNum,
            int totalAmount,
            String formattedDate,
            String orderName,
            String waiterName,
            List<dynamic> orderDetails) =>
        showDialog(
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
                              "BILL AMOUNT: ",
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
                              "VAT ${(percentage! * 100).toInt()}% ",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              (discountedTotal * percentage).toStringAsFixed(2),
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
                              "DISCOUNT: ",
                            ),
                            Text("PHP ${discountAmount.toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL AMOUNT: ",
                            ),
                            Text("PHP ${discountedTotal.toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "AMOUNT RECEIVED: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "PHP ${double.parse(cashController.text).toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "CHANGE: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "PHP ${(int.parse(cashController.text) - discountedTotal).toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
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
                                  //! payment method
                                  // ! ROLE + WAITER NAME
                                  // ! ORDER DETAILS/DESCRIPTION
                                  // ! SUBTOTAL
                                  // ! VAT
                                  // ! DISCOUNTS
                                  // ! GRAND TOTAL
                                  // ! AMOUNT PAID
                                  // ! CASHIER NAME
                                  String receiptRefNum =
                                      await generateReceiptNumber();

                                  double vatAmount =
                                      discountedTotal * percentage!;

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
                                  orderRef
                                      .update({'receipt_ref': receiptRefNum});
                                  if (method != "Cash") {
                                    orderRef.update({'payment_method': method});
                                    orderRef
                                        .update({'payment_ref': referenceNum});
                                  }

                                  await getCurrentLocation();
                                  if (Platform.isAndroid) {
                                    await FlutterBluePlus.turnOn();
                                  }

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return PrintPage(
                                        orderRef: orderRef,
                                        formattedDate: formattedDate,
                                        orderName: orderName,
                                        paymentMethod: method,
                                        paymentReference: referenceNum,
                                        receiptNum: receiptRefNum,
                                        waiterName: waiterName!,
                                        orderDetails: orderDetails,
                                        subtotal: totalAmount.toDouble(),
                                        vatPerc: (percentage! * 100).toInt(),
                                        vatAmount: vatAmount,
                                        discountAmount: discountAmount,
                                        grandTotal: discountedTotal,
                                        amountReceived: amountReceived,
                                        changeAmount: changeAmount,
                                        cashierName: cashierName!,
                                      );
                                    }),
                                  );

                                  ref
                                      .read(discountAmountProvider.notifier)
                                      .state = 0;
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

    // ! CASH METHOD
    Future cashMethod(int totalAmount, String formattedDate, String orderName,
            String waiterName, List<dynamic> orderDetails) =>
        showDialog(
          barrierDismissible: false,
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
                        "Cash Method:",
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
                                    Fluttertoast.showToast(
                                        msg: "Please enter the amount received",
                                        gravity: ToastGravity.CENTER);
                                  } else {
                                    double discountedTotal = discountAmount != 0
                                        ? (totalAmount.toDouble() -
                                            discountAmount)
                                        : totalAmount.toDouble();

                                    if (double.parse(cashController.text) <
                                        discountedTotal) {
                                      Fluttertoast.showToast(
                                          msg: "Please enter the right amount!",
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      nextModal(
                                          discountedTotal,
                                          "Cash",
                                          null,
                                          totalAmount,
                                          formattedDate,
                                          orderName,
                                          waiterName,
                                          orderDetails);
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

    // ! GCASH OR CARD METHOD
    Future onlinePayment(String method, int totalAmount, String formattedDate,
        String orderName, String waiterName, List<dynamic> orderDetails) {
      String? selectedMethod;
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "$method Method:",
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
                      if (method == "E-wallet")
                        StyledDropdown(
                          value: selectedMethod,
                          onChange: (newValue) {
                            setState(() {
                              selectedMethod = newValue;
                            });
                          },
                          hintText: "Select E-wallet",
                          items: ["Gcash", "Paymaya"],
                          showFetchedCategories: false,
                        ),
                      const SizedBox(height: 10),
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: cashController,
                          hintText: "Enter Amount Received",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledTextField(
                          controller: referenceNumController,
                          hintText: "Enter Reference Number",
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
                                  if (method == "E-wallet") {
                                    if (cashController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please enter the amount received",
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      double discountedTotal =
                                          discountAmount != 0
                                              ? (totalAmount.toDouble() -
                                                  discountAmount)
                                              : totalAmount.toDouble();

                                      if (double.parse(cashController.text) <
                                          discountedTotal) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please enter the right amount!",
                                            gravity: ToastGravity.CENTER);
                                      } else if (referenceNumController
                                          .text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please enter the reference number!",
                                            gravity: ToastGravity.CENTER);
                                      } else if (selectedMethod == null) {
                                        Fluttertoast.showToast(
                                            msg: "Please select the E-wallet!",
                                            gravity: ToastGravity.CENTER);
                                      } else {
                                        nextModal(
                                            discountedTotal,
                                            selectedMethod!,
                                            referenceNumController.text,
                                            totalAmount,
                                            formattedDate,
                                            orderName,
                                            waiterName,
                                            orderDetails);
                                      }
                                    }
                                  } else {
                                    if (cashController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please enter the amount received",
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      double discountedTotal =
                                          discountAmount != 0
                                              ? (totalAmount.toDouble() -
                                                  discountAmount)
                                              : totalAmount.toDouble();

                                      if (double.parse(cashController.text) <
                                          discountedTotal) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please enter the right amount!",
                                            gravity: ToastGravity.CENTER);
                                      } else if (referenceNumController
                                          .text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please enter the reference number!",
                                            gravity: ToastGravity.CENTER);
                                      } else {
                                        nextModal(
                                            discountedTotal,
                                            method,
                                            referenceNumController.text,
                                            totalAmount,
                                            formattedDate,
                                            orderName,
                                            waiterName,
                                            orderDetails);
                                      }
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
            );
          }),
        ),
      );
    }

    // ! CHOOSE PAYMENT METHOD
    Future paymentMethod(int totalAmount, String formattedDate,
            String orderName, String waiterName, List<dynamic> orderDetails) =>
        showDialog(
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
                      StyledButton(
                        btnText: "CASH",
                        onClick: () {
                          Navigator.of(context).pop();
                          cashMethod(totalAmount, formattedDate, orderName,
                              waiterName, orderDetails);
                        },
                        btnWidth: double.infinity,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledButton(
                        btnText: "E-WALLET",
                        onClick: () {
                          Navigator.of(context).pop();
                          onlinePayment("E-wallet", totalAmount, formattedDate,
                              orderName, waiterName, orderDetails);
                        },
                        btnWidth: double.infinity,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledButton(
                        btnText: "CARD",
                        onClick: () {
                          Navigator.of(context).pop();
                          onlinePayment("Card", totalAmount, formattedDate,
                              orderName, waiterName, orderDetails);
                        },
                        btnWidth: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    // ! HANDLE VOID
    Future<void> voidModal(List<Order> ordersList) async {
      String? voidValue;
      List<String> items = ordersList.map((order) => order.name).toList();

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: StatefulBuilder(builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "VOID AN ITEM",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Divider(height: 0),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          StyledDropdown(
                            value: voidValue,
                            onChange: (newValue) {
                              setState(() {
                                voidValue = newValue;
                              });
                              print(voidValue);
                            },
                            hintText: "Select Item",
                            items: items,
                            showFetchedCategories: false,
                          ),
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
                                    onClick: () async {
                                      if (voidValue != null) {
                                        final isAuthorized =
                                            await _showPasswordAuthenticationDialog(
                                                context);
                                        if (isAuthorized) {
                                          // Find the index of the selected item in the ordersList
                                          final int selectedIndex =
                                              ordersList.indexWhere(
                                            (order) => order.name == voidValue,
                                          );

                                          if (selectedIndex != -1) {
                                            // Remove the selected item from ordersList
                                            ordersList.removeAt(selectedIndex);

                                            // Update the orderEntry.value['order_details'] with the new list
                                            final updatedOrderDetails =
                                                ordersList.map((order) {
                                              return {
                                                'productId': order.productId,
                                                'productName': order.name,
                                                'quantity': order.quantity,
                                                'variation': order.variation,
                                                'serve_status':
                                                    order.serveStatus,
                                                'productPrice': order.price,
                                              };
                                            }).toList();

                                            FirebaseDatabase.instance
                                                .ref()
                                                .child('orders')
                                                .child(orderEntry.key)
                                                .update({
                                              'order_details':
                                                  updatedOrderDetails
                                            });

                                            Fluttertoast.showToast(
                                                msg: "Item voided",
                                                gravity: ToastGravity.CENTER);

                                            ref.refresh(ordersProvider);
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please select an Item",
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              })));
    }

    // ! HANDLE DISCOUNT / ADD DISCOUNT
    Future handleDiscount(int totalAmount) => showDialog(
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
                        "Avail Discount:",
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
                          controller: tablePersonNumController,
                          hintText: "Enter # of Person",
                          obscureText: false),
                      const SizedBox(
                        height: 10,
                      ),
                      StyledTextField(
                          keyboardType: TextInputType.number,
                          controller: seniorOrPwdNumController,
                          hintText: "Enter the # of Senior/PWD",
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
                                btnText: "Confirm",
                                onClick: () {
                                  print(discountAmount);
                                  double result = calculateDiscountedAmount(
                                      totalAmount.toDouble(),
                                      double.parse(
                                          tablePersonNumController.text),
                                      double.parse(
                                          seniorOrPwdNumController.text));
                                  ref
                                      .read(discountAmountProvider.notifier)
                                      .state = result;
                                  print(discountAmount);
                                  Navigator.of(context).pop();
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

    // ! HANDLE TAKEOUT DISCOUNT
    handleTakeoutDiscount() => showDialog(
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
                        "Avail Discount:",
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
                          controller: highestPriceController,
                          hintText: "Amount of item w/ highest price",
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
                                btnText: "Confirm",
                                onClick: () {
                                  print(discountAmount);
                                  double result = calculateTakeoutDiscountAmout(
                                      double.parse(
                                          highestPriceController.text));
                                  ref
                                      .read(discountAmountProvider.notifier)
                                      .state = result;
                                  print(discountAmount);
                                  Navigator.of(context).pop();
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

    return ordersStream.when(
      data: (ordersMap) {
        final orderEntries = ordersMap.entries.toList();

        final singleOrderEntry = orderEntries.firstWhere(
          (entry) => entry.key == orderEntry.key,
        );

        // Extract the order details from orderEntry.value
        final orderDetails =
            singleOrderEntry.value['order_details'] as List<dynamic>?;
        final orderName = singleOrderEntry.value['order_name'] as String?;
        // final totalAmount = orderEntry.value['total_amount'] as int?;
        final orderDate = DateTime.parse(singleOrderEntry.value['order_date']);
        final waiterName = singleOrderEntry.value['served_by'] as String?;
        String formattedDate =
            DateFormat('dd-MM-yyyy hh:mm a').format(orderDate.toLocal());

        if (orderDetails == null || orderName == null) {
          return SizedBox.shrink(); // Handle if the data is missing
        }

        if (orderDetails == null || orderName == null) {
          return SizedBox.shrink(); // Handle if the data is missing
        }

        final List<Order> ordersList = orderDetails.map<Order>((orderDetail) {
          final productId = orderDetail['productId'] ?? "No id";
          final name = orderDetail['productName'] ?? 'No Name';
          final quantity = orderDetail['quantity'] ?? 0;
          final variation = orderDetail['variation'] ?? '-';
          final serveStatus = orderDetail['serve_status'] ?? 'Pending';
          final price = orderDetail['productPrice'] ?? 0;

          return Order(
            productId: productId,
            name: name,
            quantity: quantity,
            variation: variation,
            serveStatus: serveStatus,
            price: price,
            // orderName: orderName,
          );
        }).toList();

        // ! BILL AMOUNT
        int totalAmount = ordersList.fold(0, (int sum, Order order) {
          return sum + (order.quantity * order.price!.toInt());
        });

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              //manual handle back button
              icon: const Icon(Icons.keyboard_arrow_left),
              iconSize: 35,
              onPressed: () {
                ref.read(discountAmountProvider.notifier).state = 0;
                Navigator.of(context).pop();
              },
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
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
                              Text("PHP ${discountAmount != 0 ? (totalAmount.toDouble() - discountAmount).toStringAsFixed(2) : totalAmount.toStringAsFixed(2)}")
                                  .animate(target: discountAmount != 0 ? 1 : 0)
                                  .shake()
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
                  Row(
                    children: [
                      Expanded(
                        child: StyledButton(
                          btnText: "DISCOUNT",
                          onClick: () {
                            if (orderName.contains("Takeout")) {
                              handleTakeoutDiscount();
                            } else {
                              handleDiscount(totalAmount);
                            }
                          },
                          btnIcon: Icon(Icons.money),
                          btnColor: const Color(0xfff8f8f7),
                          noShadow: true,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: StyledButton(
                          btnIcon: const Icon(Icons.payments),
                          btnText: "PAYMENT",
                          onClick: () {
                            paymentMethod(totalAmount, formattedDate, orderName,
                                waiterName!, orderDetails);
                          },
                          btnColor: const Color(0xFFf8f8f7),
                          noShadow: true,
                          btnWidth: double.infinity,
                        ),
                      ),
                    ],
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
                            voidModal(ordersList);
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
                                    subtotal: discountAmount != 0
                                        ? (totalAmount.toDouble() -
                                            discountAmount)
                                        : totalAmount.toDouble(),
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
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE2B563),
        ),
      ),
    );
  }

  // Future<bool> passwordAuth(
  //     BuildContext context, String email, User currentUser) async {
  //   final credential = EmailAuthProvider.credential(
  //       email: email, password: passwordController.text);
  //   try {
  //     await currentUser.reauthenticateWithCredential(credential);
  //     // Reauthentication successful
  //     return true;
  //   } catch (e) {
  //     // Reauthentication failed
  //     print("Reauthentication error: $e");
  //     return false;
  //   }
  // }

  Future<bool> _showPasswordAuthenticationDialog(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return false;
    }

    final email = currentUser.email;

    final TextEditingController passwordController = TextEditingController();

    final password = await showDialog<String?>(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      barrierColor: Colors.black54.withOpacity(0),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Your Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StyledTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Password",
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                  ),
                  SizedBox(
                      width: 4), // Adding a small gap between the icon and text
                  Flexible(
                    child: Text(
                      "This action cannot be undone, please enter password to proceed",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                    btnText: "Back",
                    onClick: () {
                      Navigator.of(context).pop();
                    }),
                const SizedBox(
                  width: 10,
                ),
                StyledButton(
                    btnText: "Confirm",
                    onClick: () {
                      if (passwordController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please enter your password to proceed",
                            gravity: ToastGravity.CENTER);
                      } else {
                        Navigator.of(context).pop(passwordController.text);
                      }
                    }),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        );
      },
    );

    if (password == null || password.isEmpty) {
      return false;
    }

    if (email == null) {
      return false;
    }

    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      await currentUser.reauthenticateWithCredential(credential);
      // Reauthentication successful
      return true;
    } catch (e) {
      // Reauthentication failed
      print("Reauthentication error: $e");
      return false;
    }
  }
}
