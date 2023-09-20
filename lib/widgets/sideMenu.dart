//preconfigured with pageObject.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:primos_app/main.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/providers/loading/isLoading_provider.dart';
import 'package:primos_app/providers/selectedTabletoMerge/mainTable_provider.dart';
import 'package:primos_app/providers/selectedTabletoMerge/selectedTable_provider.dart';
import 'package:primos_app/providers/selectedTabletoMerge/tablesToMerge_provider.dart';
import 'package:primos_app/providers/session/userRole_provider.dart';
import 'package:primos_app/providers/session/user_provider.dart';
import 'package:primos_app/providers/table/table_provider.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/pages/loginScreen.dart';
import 'package:primos_app/widgets/selectTableBtn.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDropdown.dart';
import '../pages/login_services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../providers/kitchen/orderDetails_Provider.dart';

class SideMenu extends ConsumerWidget {
  final List<SideMenuPage> pages;

  SideMenu({
    super.key,
    required this.pages,
  });

  List<String> selectedTable = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? userName = ref.watch(userNameProvider);
    final String? userRole = ref.watch(userRoleProvider);
    print(userRole);

    String getRoleImagePath(String role) {
      switch (role) {
        case 'Admin':
          return 'lib/images/admin.png';
        case 'Waiter':
          return 'lib/images/waiter.png';
        case 'Cashier':
          return 'lib/images/cashier.png';
        case 'Kitchen':
          return 'lib/images/kitchen.png';
        default:
          return 'lib/images/default.png'; // Provide a default image if the role is unknown
      }
    }

    // ! WAITER MERGE TABLES
    final ordersStream = ref.watch(ordersProvider);
    final tableItems = ref.watch(tableItemsProvider2);
    List<String> tableList = [];

    // ? GET TABLE LIST
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

    Future<void> unoccupiedListModal(BuildContext context, WidgetRef ref) {
      List<String> availableTables = [];
      final mainTable = ref.watch(mainTableProvider);

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

      // Exclude the selected main table from the unoccupid tables
      final tableChoices =
          unoccupiedTables.where((table) => table != mainTable).toList();

      return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black54.withOpacity(0),
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
                    for (int i = 0; i < tableChoices.length; i++)
                      Row(
                        children: [
                          Checkbox(
                            value: selectedTable.contains(tableChoices[i]),
                            onChanged: (isChecked) {
                              handleTableCheckboxChange(
                                  tableChoices[i], isChecked!);
                              setState(() {});
                            },
                          ),
                          Text(tableChoices[i]),
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

    Future<void> mergeModal(BuildContext context, WidgetRef ref) async {
      String? tableValue;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Table"),
                      StyledDropdown(
                        value: tableValue,
                        onChange: (newValue) {
                          setState(() {
                            tableValue = newValue;
                            ref.read(mainTableProvider.notifier).state =
                                newValue;
                          });
                        },
                        hintText: "Select Table",
                        items: tableList,
                        showFetchedCategories: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Select tables to merge with"),
                      SelectTableBtn(
                          onPressed: ref.watch(mainTableProvider) != null
                              ? () {
                                  unoccupiedListModal(context, ref);
                                }
                              : () {
                                  Fluttertoast.showToast(
                                      msg: "Please select the table first",
                                      gravity: ToastGravity.CENTER);
                                }),
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
                                  final mainTable =
                                      ref.watch(mainTableProvider);
                                  final selectedTable =
                                      ref.watch(selectedTableProvider);

                                  final firestore = FirebaseFirestore.instance;
                                  try {
                                    final mainTableId =
                                        await getTableIdByName(mainTable!);
                                    await firestore
                                        .collection('tables')
                                        .doc(mainTableId)
                                        .update({
                                      'status': 'merged',
                                      'mergedWith': selectedTable
                                    });

                                    // Update the 'status' field to 'inactive' for each table to merge
                                    for (final tableId in tablesToMerge) {
                                      await firestore
                                          .collection('tables')
                                          .doc(tableId)
                                          .update({
                                        'status': 'inactive',
                                      });
                                    }
                                  } catch (e) {
                                    print('error line 330: $e');
                                  }

                                  ref
                                      .read(selectedTableProvider.notifier)
                                      .state = [];
                                  ref
                                      .read(tablesToMergeProvider.notifier)
                                      .state = [];
                                  ref.refresh(mergedTablesProvider);
                                  ref.refresh(tableItemsProvider);
                                  ref.refresh(tableItemsProvider2);
                                  ref.refresh(tableDataProvider(mainTable!));

                                  Navigator.pop(context);
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
        ),
      );
    }
    // ! END OF WAITER MERGE TABLES

    // ! WAITER UNMERGE TABLES
    final mergedItems = ref.watch(mergedTablesProvider);
    List<String> mergedTableList = [];

    // ? GET TABLE LIST
    mergedItems.when(
        data: (itemDocs) {
          itemDocs.sort((a, b) {
            // Extract the numeric part of the table names
            int tableNumberA =
                int.parse(RegExp(r'[0-9]+').firstMatch(a)!.group(0)!);
            int tableNumberB =
                int.parse(RegExp(r'[0-9]+').firstMatch(b)!.group(0)!);
            return tableNumberA.compareTo(tableNumberB);
          });

          mergedTableList = itemDocs;
          return true;
        },
        loading: () => Center(
                child: CircularProgressIndicator(
              color: Color(0xFFE2B563),
            )),
        error: (error, stackTrace) => []);

    Future<void> unMergeModal(BuildContext context, WidgetRef ref) async {
      String? tableValue;

      String? status;
      List<String> mergedWithStringList = [];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Unmerge Tables",
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(height: 0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Table"),
                      StyledDropdown(
                        value: tableValue,
                        onChange: (newValue) {
                          setState(() {
                            tableValue = newValue;
                            ref.read(mainTableProvider.notifier).state =
                                newValue;

                            final tableData =
                                ref.watch(tableDataProvider(newValue!));

                            tableData.when(
                              data: (itemSnap) {
                                if (itemSnap != null) {
                                  final data =
                                      itemSnap.data() as Map<String, dynamic>;
                                  // final documentSnapshot = itemSnap.docs[
                                  //     0]; // Get the first document in the QuerySnapshot
                                  // final data = documentSnapshot.data()
                                  //     as Map<String, dynamic>;
                                  status = data['status'] as String;
                                  final mergedWith =
                                      data['mergedWith'] as List<dynamic> ?? [];

                                  mergedWithStringList =
                                      mergedWith.map((dynamic item) {
                                    return item
                                        .toString(); // Convert each item to a String
                                  }).toList();
                                } else {}
                              },
                              error: (error, stackTrace) =>
                                  Text("Error: $error"),
                              loading: () => Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFE2B563),
                                ),
                              ),
                            );
                          });
                        },
                        hintText: "Select Table",
                        items: mergedTableList,
                        showFetchedCategories: false,
                      ),
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
                                btnText: "Unmerge",
                                onClick: () async {
                                  ref.read(isLoadingProvider.notifier).state =
                                      true;
                                  final firestore = FirebaseFirestore.instance;
                                  List<String> mergedTableId = [];
                                  final mainTable =
                                      ref.watch(mainTableProvider);

                                  try {
                                    for (final table in mergedWithStringList) {
                                      String? result =
                                          await getTableIdByName(table);
                                      if (result != null) {
                                        mergedTableId.add(result);
                                      }
                                    }

                                    // Update the 'status' field to 'inactive' for each table to merge
                                    for (final tableId in mergedTableId) {
                                      await firestore
                                          .collection('tables')
                                          .doc(tableId)
                                          .update({
                                        'status': 'active',
                                      });
                                    }

                                    final mainTableId =
                                        await getTableIdByName(mainTable!);
                                    await firestore
                                        .collection('tables')
                                        .doc(mainTableId)
                                        .update({
                                      'status': 'active',
                                      'mergedWith': [],
                                    });
                                  } catch (e) {
                                    print("ERROR LINE 506: $e");
                                  }
                                  ref.read(isLoadingProvider.notifier).state =
                                      false;
                                  ref.refresh(mergedTablesProvider);
                                  ref.refresh(tableItemsProvider);
                                  ref.refresh(tableItemsProvider2);
                                  ref.refresh(tableDataProvider(mainTable!));
                                  Navigator.pop(context);
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
        ),
      );
    }

    // ! END OF WAITER UNMERGE

    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>[
          // HEADER
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFE2B563),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        // color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      getRoleImagePath(userRole ?? 'default'),
                      height: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text(userRole ?? 'Default'),
                  Text(userName ?? "User"),
                ]),
          ),

          // DYNAMIC PAGES
          ...pages.map((page) {
            return ListTile(
              iconColor: Color(0xff252525),
              leading: page.icon,
              title: Text(page.name),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => page.page,
                ));
              },
              minLeadingWidth: 0,
            );
          }).toList(),

          // ! WAITER MERGE TALBES
          if (userRole == "Waiter")
            ListTile(
              iconColor: Color(0xff252525),
              leading: const Icon(Icons.edit),
              title: const Text('Merge Tables'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return WaiterTablePage();
                }));
                mergeModal(context, ref);
              },
              minLeadingWidth: 0,
            ),
          if (userRole == "Waiter")
            ListTile(
              iconColor: Color(0xff252525),
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Unmerge Tables'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return WaiterTablePage();
                }));
                unMergeModal(context, ref);
              },
              minLeadingWidth: 0,
            ),

          // LOGOUT
          ListTile(
            iconColor: Color(0xff252525),
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: (() async {
              try {
                await Auth().signOut();

                // store role in sharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('lastVisitedPage', "LoginScreen");
                prefs.setString('userRole', "n/a");
                prefs.setString('userName', "User");

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginSreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } catch (error) {
                print('error');
              }
            }),
            minLeadingWidth: 0,
          ),
        ],
      ),
    );
  }
}
