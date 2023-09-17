import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/admin/table/quantity_provider.dart';
import 'package:primos_app/providers/loading/isLoading_provider.dart';
import 'package:primos_app/providers/table/table_provider.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/tableDisplay.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TablePage extends ConsumerWidget {
  const TablePage({Key? key}) : super(key: key);

//   @override
//   State<TablePage> createState() => _TablePageState();
// }

// class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int quantity = ref.watch(quantityProvider);
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

    // Future<void> fetchTables() async {
    //   print("Fetching tables...");
    //   final tablesCollection = FirebaseFirestore.instance.collection('tables');
    //   final querySnapshot = await tablesCollection.get();

    //   final fetchedData = querySnapshot.docs.map((doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //     return {
    //       'tableId': doc.id,
    //       'tableName': data['tableName'] as String,
    //       'tableNumber': data['tableNumber'] as int,
    //     };
    //   }).toList();

    //   print("Fetched tables: $fetchedData");

    //   // Sort the fetchedData in ascending order by tableNumber
    //   fetchedData.sort((a, b) {
    //     return (a['tableNumber'] as int).compareTo(b['tableNumber'] as int);
    //   });

    //   // setState(() {
    //   tablesData = fetchedData;
    //   // });
    // }

    // // Callback function to refresh table data
    // Future<void> refreshTables() async {
    //   await fetchTables();
    // }

    Future<void> addTables(int startingTableNumber, int numTablesToAdd) async {
      ref.read(isLoadingProvider.notifier).state = true;
      final tablesCollection = FirebaseFirestore.instance.collection('tables');
      final lastTableNumber = await getLastTableNumber();

      for (int i = 0; i < numTablesToAdd; i++) {
        final newTableNumber =
            lastTableNumber + i + 1; // Start from the next number
        await tablesCollection.add({
          'tableName': 'Table $newTableNumber',
          'tableNumber': newTableNumber,
          'status': 'active',
          'mergedWith': [],
        });
      }
      ref.read(isLoadingProvider.notifier).state = false;
      ref.refresh(tableItemsProvider);
      ref.refresh(allTableItemsProvider);
      // refreshTables();
    }

    late AsyncValue<List<Map<String, Object>>> fetchTablesFuture =
        ref.watch(allTableItemsProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFf7f7f7),
          drawer: SideMenu(pages: adminPages),
          appBar: AppBar(
            title: const Text("TABLE"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer(builder: (context, ref, _) {
                final asyncValue = ref.watch(allTableItemsProvider);

                return asyncValue.when(
                  data: (tablesData) {
                    return ListView.builder(
                      itemCount: tablesData.length,
                      itemBuilder: (context, index) {
                        final tableId = tablesData[index]['tableId'] as String;
                        final tableNum =
                            tablesData[index]['tableNumber'] as int;
                        final tableName =
                            tablesData[index]['tableName'] as String;
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: TableDisplay(
                                key: ValueKey<int>(tableNum),
                                tableId: tableId,
                                tableNum: tableNum,
                                tableName: tableName,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      },
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE2B563),
                    ),
                  ),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              }),
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
                            // setState(() {
                            if (quantity != 1) {
                              ref.read(quantityProvider.notifier).state--;
                            }
                            // });
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
                            // setState(() {
                            ref.read(quantityProvider.notifier).state++;
                            // });
                          },
                          icon: Icon(Icons.add_circle),
                          iconSize: 30,
                        )
                      ],
                    ),
                  ),
                  StyledButton(
                    noShadow: true,
                    btnIcon: const Icon(Icons.add),
                    btnText: "ADD",
                    onClick: () {
                      addTables(quantity, quantity);
                      // setState(() {
                      ref.read(quantityProvider.notifier).state = 1;
                      // });
                    },
                    btnColor: Color(0xFFf8f8f7),
                    btnWidth: 175,
                  )
                ],
              ),
            ),
          ),
        ),
        if (ref.watch(isLoadingProvider) == true)
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Color(0xFFFE3034),
            ),
          )
      ],
    );
  }
}
