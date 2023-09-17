import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/kitchen/orderDetails_Provider.dart';
import 'package:primos_app/providers/selectedTabletoMerge/selectedTable_provider.dart';
import 'package:primos_app/providers/selectedTabletoMerge/tablesToMerge_provider.dart';
import 'package:primos_app/providers/table/table_provider.dart';
import 'package:primos_app/widgets/selectTableBtn.dart';
import 'package:primos_app/widgets/styledButton.dart';

class CustomDialogBox extends ConsumerWidget {
  CustomDialogBox({super.key});

  List<String> selectedTable = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);
    final tableItems = ref.watch(tableItemsProvider);

    String? tableValue;
    List<String> availableTables = [];
    List<String> tableList = [];

    tableItems.when(
        data: (itemDocs) {
          itemDocs.sort((a, b) {
            // Extract the numeric part of the table names
            int tableNumberA =
                int.parse(RegExp(r'[0-9]+').firstMatch(a)!.group(0)!);
            int tableNumberB =
                int.parse(RegExp(r'[0-9]+').firstMatch(b)!.group(0)!);
            return tableNumberA.compareTo(tableNumberB);
          });

          tableList = itemDocs;
          return true;
        },
        loading: () => Center(
                child: CircularProgressIndicator(
              color: Color(0xFFE2B563),
            )),
        error: (error, stackTrace) => []);

    // get the occupied orders
    ordersStream.when(
        data: (ordersMap) {
          final orderEntries = ordersMap.entries.toList();
          for (final entry in orderEntries) {
            if (entry.value['payment_status'] == 'Unpaid') {
              availableTables.add(entry.value['order_name']);
            }
          }
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => CircularProgressIndicator());
    // Exclude occupied tables from the tableList
    final unoccupiedTables =
        tableList.where((table) => !availableTables.contains(table)).toList();

    Future<String?> getTableIdByName(String tableName) async {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('tables')
          .where('tableName', isEqualTo: tableName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming table names are unique, so there should be only one document
        return querySnapshot.docs.first.id;
      } else {
        // Handle the case where the table name is not found
        return null;
      }
    }

    void handleTableCheckboxChange(String unoccupiedTable, bool isChecked) {
      if (isChecked) {
        selectedTable.add(unoccupiedTable);
      } else {
        selectedTable.remove(unoccupiedTable);
      }
      print(selectedTable);
    }

    Future<void> unoccupiedListModal() {
      List<String> availableTables = [];

      // get the occupied orders
      ordersStream.when(
          data: (ordersMap) {
            final orderEntries = ordersMap.entries.toList();
            for (final entry in orderEntries) {
              if (entry.value['payment_status'] == 'Unpaid') {
                availableTables.add(entry.value['order_name']);
              }
            }
          },
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => CircularProgressIndicator());
      // Exclude occupied tables from the tableList
      final unoccupiedTables =
          tableList.where((table) => !availableTables.contains(table)).toList();
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select tables to merge with:"),
                    Divider(height: 0),
                    for (int i = 0; i < unoccupiedTables.length; i++)
                      Row(
                        children: [
                          Checkbox(
                            value: selectedTable.contains(unoccupiedTables[i]),
                            onChanged: (isChecked) {
                              handleTableCheckboxChange(
                                  unoccupiedTables[i], isChecked!);
                              setState(() {});
                            },
                          ),
                          Text(unoccupiedTables[i]),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StyledButton(
                                btnText: "CANCEL",
                                onClick: () {
                                  Navigator.pop(context);
                                }),
                            StyledButton(
                              btnText: "CONFIRM",
                              onClick: () async {
                                // Use selectedCategories for further processing
                                // ref
                                //     .read(selectedCategoryProvider.notifier)
                                //     .state = selectedCategories;
                                List<String> tablesToMerge = [];
                                for (final table in selectedTable) {
                                  String? result =
                                      await getTableIdByName(table);
                                  if (result != null) {
                                    tablesToMerge.add(result);
                                  }
                                }
                                print(tablesToMerge);
                                ref.read(tablesToMergeProvider.notifier).state =
                                    tablesToMerge;

                                Navigator.pop(context);
                                print(selectedTable);
                                ref.refresh(selectedTableProvider);
                                ref.read(selectedTableProvider.notifier).state =
                                    selectedTable;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Merge Tables",
                textAlign: TextAlign.left,
              ),
            ),
            Divider(height: 0),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SelectTableBtn(onPressed: unoccupiedListModal),
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
                            btnText: "Merge",
                            onClick: () async {
                              final tablesToMerge =
                                  ref.watch(tablesToMergeProvider);
                              final firestore = FirebaseFirestore.instance;

                              // Update the 'status' field to 'inactive' for each table to merge
                              for (final tableId in tablesToMerge) {
                                await firestore
                                    .collection('tables')
                                    .doc(tableId)
                                    .update({
                                  'status': 'merged',
                                  // 'mergedWith': tableEntry!['order_name'],
                                });
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
    );
  }
}
