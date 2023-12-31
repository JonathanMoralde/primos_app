import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

class PrintPage extends StatefulWidget {
  DatabaseReference? orderRef;
  final String formattedDate;
  final String orderName;
  final String? paymentMethod;
  final String? paymentReference;
  final String? receiptNum;
  final String waiterName;
  final List<dynamic> orderDetails;
  final double subtotal;
  final int? vatPerc;
  final double? vatAmount;
  final double? discountAmount;
  final double? grandTotal;
  final String cashierName;
  final double? amountReceived;
  final double? changeAmount;

  PrintPage(
      {super.key,
      this.orderRef,
      required this.formattedDate,
      required this.orderName,
      this.paymentMethod,
      this.paymentReference,
      this.receiptNum,
      required this.waiterName,
      required this.orderDetails,
      required this.subtotal,
      this.vatPerc,
      this.vatAmount,
      this.discountAmount,
      this.grandTotal,
      required this.cashierName,
      this.amountReceived,
      this.changeAmount});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  String _devicesMsg = '';
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  Future<void> initPrinter() async {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      print(val);
      if (!mounted) {
        return;
      }
      ;

      setState(() {
        _devices = val;
      });
    });
  }

  Future<void> _refreshPrinterList() async {
    setState(() {
      _devices.clear(); // Clear the current list of devices
      _devicesMsg = ''; // Clear any error message
    });
    await initPrinter(); // Start scanning again
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("SELECT PRINTER"),
        automaticallyImplyLeading: false,
      ),
      body: _devices.isEmpty
          ? Center(
              child: Text(_devicesMsg ?? ""),
            )
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(_devices[i].name!),
                  subtitle: Text(_devices[i].address!),
                  onTap: () {
                    _startPrint(_devices[i], context);
                  },
                );
              }),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Color(0xff252525),
        backgroundColor: Color(0xFFE2B563),
        onPressed: _refreshPrinterList,
        tooltip: 'Refresh Printer List',
        child: Icon(Icons.refresh),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
                child: StyledButton(
              btnText:
                  widget.orderRef != null ? "CONFIRM & BACK TO ORDERS" : "BACK",
              onClick: () {
                if (widget.orderRef != null) {
                  widget.orderRef!.update({'payment_status': 'Paid'});
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                      return OrdersPage();
                    }),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              btnColor: Color(0xfff8f8f7),
            ))
          ]),
        ),
      ),
    );
  }

  Future<List<int>> demoReceipt(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];

    bytes += ticket.text('Primo\'s Bistro',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += ticket.text(
        'G/F D Park View Hotel, Blumentritt Street Barangay Guilid 4504 Palimbang',
        styles: PosStyles(align: PosAlign.center));
    bytes += ticket.text('Ligao City, Albay',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(
          text: 'DATE:', width: 4, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: '${widget.formattedDate}',
          width: 8,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'ORDER:', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: widget.orderName,
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    if (widget.receiptNum != null) {
      bytes += ticket.row([
        PosColumn(
            text: 'PAYMENT METHOD:',
            width: 6,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: widget.paymentMethod!,
            width: 6,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      if (widget.paymentMethod != "Cash") {
        bytes += ticket.row([
          PosColumn(
              text: 'REF. NO.:',
              width: 4,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text: widget.paymentReference!,
              width: 8,
              styles: PosStyles(align: PosAlign.right)),
        ]);
      }
      bytes += ticket.row([
        PosColumn(
            text: 'RECEIPT NO.:',
            width: 6,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: widget.receiptNum!,
            width: 6,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += ticket.row([
      PosColumn(
          text: 'WAITER:', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: widget.waiterName,
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: 'ITEM NAME', width: 6),
      // PosColumn(text: 'QTY', width: 1),
      PosColumn(text: 'VARIATION', width: 3),
      // PosColumn(
      //     text: 'PRICE', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'TOTAL', width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);
    for (var i = 0; i < widget.orderDetails.length; i++) {
      final String productName = widget.orderDetails[i]['productName'];
      final String variation = widget.orderDetails[i]['variation'] ?? "-";
      final String quantity = widget.orderDetails[i]['quantity'].toString();
      final String productPrice =
          widget.orderDetails[i]['productPrice'].toString();
      final String totalPrice =
          (int.parse(quantity) * int.parse(productPrice)).toString();
      bytes += ticket.row([
        PosColumn(text: productName, width: 6),
        // PosColumn(text: quantity, width: 1),
        PosColumn(text: variation, width: 3),
        // PosColumn(
        //     text: productPrice,
        //     width: 2,
        //     styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: totalPrice,
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      bytes += ticket.row([
        PosColumn(text: "  $quantity x $productPrice", width: 12),
        // PosColumn(
        //     text: productPrice,
        //     width: 2,
        //     styles: PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += ticket.hr();

    if (widget.receiptNum == null) {
      bytes += ticket.row([
        PosColumn(
            text: 'BILL AMOUNT:',
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: 'PHP ${widget.subtotal.toStringAsFixed(2)}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
    } else {
      bytes += ticket.row([
        PosColumn(
          text: 'SUBTOTAL:',
          width: 6,
        ),
        PosColumn(
            text: 'PHP ${widget.subtotal.toStringAsFixed(2)}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
      ]);
      bytes += ticket.row([
        PosColumn(
          text: 'VAT (${widget.vatPerc}%):',
          width: 6,
        ),
        PosColumn(
            text: 'PHP ${widget.vatAmount!.toStringAsFixed(2)}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
      ]);
      bytes += ticket.row([
        PosColumn(
          text: 'DISCOUNTS:',
          width: 6,
        ),
        PosColumn(
            text: 'PHP ${widget.discountAmount!.toStringAsFixed(2)}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: 'GRAND TOTAL',
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: 'PHP ${widget.grandTotal!.toStringAsFixed(2)}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
      bytes += ticket.hr(ch: '=', linesAfter: 1);

      bytes += ticket.row([
        PosColumn(
            text: 'CASH:',
            width: 7,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
        PosColumn(
            text: 'PHP ${widget.amountReceived!.toStringAsFixed(2)}',
            width: 5,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: 'CHANGE:',
            width: 7,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
        PosColumn(
            text: 'PHP ${widget.changeAmount!.toStringAsFixed(2)}',
            width: 5,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      ]);
      bytes += ticket.hr(linesAfter: 1);
      bytes += ticket.row([
        PosColumn(
            text: 'CASHIER:',
            width: 6,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: widget.cashierName,
            width: 6,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += ticket.feed(1);
    bytes += ticket.text('DIOS MABALOS PO SAINDO GABOS!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += ticket.feed(2);

    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  Future<void> _startPrint(
      PrinterBluetooth printer, BuildContext context) async {
    _printerManager.selectPrinter(printer);
    const PaperSize paper = PaperSize.mm58; // Adjust paper size as needed
    final profile = await CapabilityProfile.load();

    try {
      final PosPrintResult res =
          await _printerManager.printTicket(await demoReceipt(paper, profile));
      print("Printing result: ${res.msg}");
    } catch (e) {
      print("Printing error: $e");
    }
  }
}
