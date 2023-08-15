import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/waiter_menu.dart';
import 'package:primos_app/providers/waiter_menu/orderName_provider.dart';
import 'package:primos_app/widgets/styledButton.dart';

// STATE MANAGEMENT
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO UI FOR WHEN THE TABLE IS OCCUPPIED

class TableBox extends ConsumerWidget {
  final int tableNum;
  TableBox({super.key, required this.tableNum});

//   @override
//   State<TableBox> createState() => _TableBoxState();
// }

// class _TableBoxState extends State<TableBox> {
  bool isOccupied = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future tableModal() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        StyledButton(
                          btnText: "New Order",
                          onClick: () {},
                          btnWidth: double.infinity,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StyledButton(
                          btnText: "View Order",
                          onClick: () {},
                          btnWidth: double.infinity,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));

    return GestureDetector(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isOccupied ? Color(0xFFFE3034) : Color(0xFFE2B563),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text("Table ${tableNum}"),
        ),
      ),
      onTap: () {
        // print(tableNum);
        if (isOccupied) {
          tableModal();
        }
        ref.read(orderNameProvider.notifier).state = "Table $tableNum";
        print(ref.watch(orderNameProvider));
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return WaiterMenu();
          }),
        );
      },
    );
  }
}
