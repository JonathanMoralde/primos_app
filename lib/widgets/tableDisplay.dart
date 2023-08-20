import 'package:flutter/material.dart';

class TableDisplay extends StatefulWidget {
  final int tableNum;
  final String tableName;
  const TableDisplay({
    Key? key,
    required this.tableNum,
    required this.tableName,
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
              onPressed: () {
                // TODO: Implement the logic to delete the table
                print("Delete table ${widget.tableNum}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
