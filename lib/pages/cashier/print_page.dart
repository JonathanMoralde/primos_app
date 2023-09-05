import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  final String formattedDate;
  final String orderName;
  final String? receiptNum;
  final String waiterName;
  final List<dynamic> orderDetails;
  final double subtotal;
  final double? vatAmount;
  final double? discountAmount;
  final double? grandTotal;
  final String cashierName;
  final double? amountReceived;
  final double? changeAmount;

  const PrintPage(
      {super.key,
      required this.formattedDate,
      required this.orderName,
      this.receiptNum,
      required this.waiterName,
      required this.orderDetails,
      required this.subtotal,
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
      if (!mounted) return;
      setState(() {
        _devices = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SELECT PRINTER"),
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
    );
  }

  Future<List<int>> demoReceipt(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];

    // Print image
    // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
    // final Uint8List imageBytes = data.buffer.asUint8List();
    // final Image? image = decodeImage(imageBytes);
    // bytes += ticket.image(image);

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
          text: 'DATE:', width: 6, styles: PosStyles(align: PosAlign.left)),
      PosColumn(
          text: widget.formattedDate,
          width: 6,
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
            text: 'RECEIPT NO.:',
            width: 12,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: widget.receiptNum!,
            width: 12,
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
      PosColumn(text: 'ITEM NAME', width: 5),
      PosColumn(text: 'QTY', width: 1),
      PosColumn(text: 'VARIATION', width: 2),
      PosColumn(
          text: 'UNIT PRICE',
          width: 2,
          styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'TOTAL PRICE',
          width: 2,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    for (final order in widget.orderDetails) {
      bytes += ticket.row([
        PosColumn(text: order['productName'], width: 5),
        PosColumn(text: order['quantity'] as String, width: 1),
        PosColumn(text: order['variation'] ?? "-", width: 2),
        PosColumn(
            text: order['productPrice'] as String,
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: (double.parse(order['quantity'] as String) *
                    double.parse(order['productPrice'] as String))
                .toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += ticket.hr();

    if (widget.receiptNum == null) {
      bytes += ticket.row([
        PosColumn(
            text: 'BILL AMOUNT:',
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
        PosColumn(
            text: 'PHP ${widget.subtotal}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
      ]);
    } else {
      bytes += ticket.row([
        PosColumn(
          text: 'SUBTOTAL:',
          width: 6,
        ),
        PosColumn(
            text: 'PHP ${widget.subtotal}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
            )),
      ]);
      bytes += ticket.row([
        PosColumn(
          text: 'VAT (12%):',
          width: 6,
        ),
        PosColumn(
            text: 'PHP ${widget.vatAmount}',
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
            text: 'PHP ${widget.discountAmount}',
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
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
        PosColumn(
            text: 'PHP ${widget.grandTotal}',
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            )),
      ]);
      bytes += ticket.hr(ch: '=', linesAfter: 1);

      bytes += ticket.row([
        PosColumn(
            text: 'CASH:',
            width: 7,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
        PosColumn(
            text: 'PHP ${widget.amountReceived}',
            width: 5,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: 'CHANGE:',
            width: 7,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
        PosColumn(
            text: 'PHP ${widget.changeAmount}',
            width: 5,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
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

    bytes += ticket.feed(2);
    bytes += ticket.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    ;

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

      // ONCE PRINTED
      Navigator.of(context).pop();
    } catch (e) {
      print("Printing error: $e");
    }
  }
}
