import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/tableDisplay.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  int quantity = 1;
  late List<Map<String, dynamic>> tablesData = [];
  Future<int> getLastTableNumber() async {
    final tablesCollection = FirebaseFirestore.instance.collection('tables');
    final querySnapshot = await tablesCollection
        .orderBy('tableNumber', descending: true)
        .limit(1)
        .get();
    final lastTableNumber = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.first.get('tableNumber')
        : 0;
    return lastTableNumber;
  }

  Future<void> addTables(int startingTableNumber, int numTablesToAdd) async {
    final tablesCollection = FirebaseFirestore.instance.collection('tables');
    final lastTableNumber = await getLastTableNumber();

    for (int i = 0; i < numTablesToAdd; i++) {
      final newTableNumber =
          lastTableNumber + i + 1; // Start from the next number
      await tablesCollection.add({
        'tableName': 'Table $newTableNumber',
        'tableNumber': newTableNumber,
      });
    }
  }

  Future<void> fetchTables() async {
    print("Fetching tables...");
    final tablesCollection = FirebaseFirestore.instance.collection('tables');
    final querySnapshot = await tablesCollection.get();

    setState(() {
      tablesData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
    print("Fetched tables: $tablesData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f7f7),
      drawer: SideMenu(pages: adminPages),
      appBar: AppBar(
        title: const Text("TABLE"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tablesData.map((tableData) {
              final tableNum = tableData['tableNumber'] as int;
              final tableName = tableData['tableName'] as String;
              print("Creating TableDisplay for Table $tableNum: $tableName");
              return TableDisplay(
                tableNum: tableNum,
                tableName: tableName,
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFf8f8f7),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: 45,
                width: 175,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity != 1) {
                            quantity--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove_circle),
                      iconSize: 30,
                    ),
                    Text(
                      quantity.toString(),
                      style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: Icon(Icons.add_circle),
                      iconSize: 30,
                    )
                  ],
                ),
              ),
              StyledButton(
                noShadow: true,
                btnText: "ADD",
                onClick: () {
                  addTables(quantity, quantity);
                  setState(() {
                    quantity = 1;
                  });
                },
                btnColor: Color(0xFFf8f8f7),
                btnWidth: 175,
              )
            ],
          ),
        ),
      ),
    );
  }
}
