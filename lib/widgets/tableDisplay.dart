import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:primos_app/providers/table/table_provider.dart';

class TableDisplay extends ConsumerWidget {
  final String tableId;
  final int tableNum;
  final String tableName;

  const TableDisplay({
    Key? key,
    required this.tableId,
    required this.tableNum,
    required this.tableName,
  }) : super(key: key);

//   @override
//   State<TableDisplay> createState() => _TableDisplayState();
// }

// class _TableDisplayState extends State<TableDisplay> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: Color(0xFFE2B563),
      ),
      height: 45,
      width: 175,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Table: ${tableNum}"),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await deleteTable(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteTable(BuildContext context, WidgetRef ref) async {
    try {
      // Delete the Firestore document associated with the user
      final tableDocRef =
          FirebaseFirestore.instance.collection('tables').doc(tableId);
      await tableDocRef.delete().then((value) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text("Table deleted successfully."),
        //   duration: Duration(seconds: 2),
        // ));
        Fluttertoast.showToast(msg: "Table deleted successfully.");
        ref.refresh(tableItemsProvider);
        ref.refresh(allTableItemsProvider);
      });
    } catch (e) {
      print("Error deleting table: $e");
    }
  }
}
