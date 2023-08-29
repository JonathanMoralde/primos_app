import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';

class PrintPage extends StatefulWidget {
  final String? formattedDate;
  final String? orderName;
  final String? receiptNum;
  final String? waiterName;
  final List<dynamic>? orderDetails;
  final double? subtotal;
  final double? vatAmount;
  final double? discountAmount;
  final double? grandTotal;
  final String? cashierName;
  final double? amountReceived;
  final double? changeAmount;

  const PrintPage(
      {super.key,
      this.formattedDate,
      this.orderName,
      this.receiptNum,
      this.waiterName,
      this.orderDetails,
      this.subtotal,
      this.vatAmount,
      this.discountAmount,
      this.grandTotal,
      this.cashierName,
      this.amountReceived,
      this.changeAmount});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothprint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  Future<void> initPrinter() async {
    bluetoothprint.startScan(
      timeout: Duration(seconds: 4),
    );

    if (!mounted) return;
    bluetoothprint.scanResults.listen((val) {
      setState(() {
        _devices = val;
      });
      if (_devices.isEmpty) {
        setState(() {
          _devicesMsg = "No Devices";
        });
      }
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
                    _startPrint(_devices[i]);
                  },
                );
              }),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothprint.connect(device);

      Map<String, dynamic> config = Map();
      List<LineText> list = [
        LineText(
          type: LineText.TYPE_TEXT,
          content: "PRIMO'S BISTRO",
          weight: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
        LineText(
          type: LineText.TYPE_TEXT,
          content:
              "G/F D Park View Hotel, Blumentritt Street Barangay Guilid 4504 Palimbang",
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Ligao City, Albay",
          weight: 0,
          align: LineText.ALIGN_CENTER,
          linefeed: 2,
        ),
        LineText(
          type: LineText.TYPE_TEXT,
          content: "DATE & TIME:",
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 0,
        ),
        LineText(
          type: LineText.TYPE_TEXT,
          content: widget.formattedDate,
          weight: 0,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ),
        LineText(
          type: LineText.TYPE_TEXT,
          content: "ORDER NO:",
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 0,
        ),
        LineText(
          type: LineText.TYPE_TEXT,
          content: widget.orderName,
          weight: 0,
          align: LineText.ALIGN_RIGHT,
          linefeed: 1,
        ),
      ];

      if (widget.receiptNum != null) {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "RECEIPT NO:",
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: widget.receiptNum,
            weight: 0,
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
      }
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "WAITER:",
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 0,
        ),
      );
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: widget.waiterName,
          weight: 0,
          align: LineText.ALIGN_RIGHT,
          linefeed: 2,
        ),
      );
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: '-------------------------',
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
      );

      for (final order in widget.orderDetails!) {
        int price = order['productPrice'];
        int quantity = order['quantity'];
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: order['productName'],
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: '$price x',
            align: LineText.ALIGN_CENTER,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: ' $quantity',
            align: LineText.ALIGN_CENTER,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'PHP ${price * quantity}',
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
      }
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: '-------------------------',
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
      );

      if (widget.vatAmount != null &&
          widget.discountAmount != null &&
          widget.grandTotal != null &&
          widget.amountReceived != null &&
          widget.changeAmount != null) {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "SUBTOTAL:",
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: widget.subtotal.toString(),
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "VAT (12%):",
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: widget.vatAmount.toString(),
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "DISCOUNTS:",
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: widget.discountAmount.toString(),
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "TOTAL:",
            weight: 1,
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'PHP ${widget.grandTotal}',
            weight: 1,
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "AMOUNT PAID:",
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'PHP ${widget.amountReceived}',
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "CHANGE:",
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: 'PHP ${widget.changeAmount}',
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: '-------------------------',
            align: LineText.ALIGN_CENTER,
            linefeed: 2,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "CASHIER:",
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: widget.cashierName,
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
      } else {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "BILL AMOUNT:",
            weight: 1,
            align: LineText.ALIGN_LEFT,
            linefeed: 0,
          ),
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            weight: 1,
            content: widget.subtotal.toString(),
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
          ),
        );
      }
    }
  }
}
