import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableDisplay extends StatefulWidget {
  final String tableId;
  final int tableNum;
  final String tableName;
  final VoidCallback refreshCallback;

  const TableDisplay({
    Key? key,
    required this.tableId,
    required this.tableNum,
    required this.tableName,
    required this.refreshCallback,
  }) : super(key: key);

  @override
  State<TableDisplay> createState() => _TableDisplayState();
}

class _TableDisplayState extends State<TableDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: const Color(0xFFE2B563),
      ),
      height: 45,
      width: 175,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Table: ${widget.tableNum}"),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                // TODO: Implement the logic to delete the table
                await deleteTable();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteTable() async {
    try {
      // Delete the Firestore document associated with the user
      final tableDocRef =
          FirebaseFirestore.instance.collection('tables').doc(widget.tableId);
      await tableDocRef.delete().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Table deleted successfully."),
          duration: Duration(seconds: 2),
        ));

        // Call the callback function to refresh the table data
        widget.refreshCallback();
      });
    } catch (e) {
      print("Error deleting table: $e");
    }
  }
}
