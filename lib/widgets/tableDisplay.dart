import 'package:flutter/material.dart';

class TableDisplay extends StatelessWidget {
  final int tableNum;

  const TableDisplay({super.key, required this.tableNum});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Colors.amber),
      height: 45,
      width: 175,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Table $tableNum"),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO ADD API
                print(tableNum);
              },
            ),
          ],
        ),
      ),
    );
  }
}
