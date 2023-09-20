import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableItemsProvider = FutureProvider<List<String>>((ref) async {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final tablesSnapshot = await tablesCollection
      .where('status', whereIn: ['active', 'merged']).get();

  final tableNames =
      tablesSnapshot.docs.map((doc) => doc.get('tableName') as String).toList();

  return tableNames;
});

final tableDataProvider =
    FutureProvider.family<QuerySnapshot?, String>((ref, tableName) async {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final tablesSnapshot =
      await tablesCollection.where('tableName', isEqualTo: tableName).get();

  return tablesSnapshot;
});

final mergedTablesProvider = FutureProvider<List<String>>((ref) async {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final tablesSnapshot =
      await tablesCollection.where('status', isEqualTo: 'merged').get();

  final tableNames =
      tablesSnapshot.docs.map((doc) => doc.get('tableName') as String).toList();

  return tableNames;
});

final allTableItemsProvider =
    FutureProvider<List<Map<String, Object>>>((ref) async {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final tablesSnapshot = await tablesCollection.get();

  final fetchedData = tablesSnapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return {
      'tableId': doc.id,
      'tableName': data['tableName'] as String,
      'tableNumber': data['tableNumber'] as int,
    };
  }).toList();

  print("Fetched tables: $fetchedData");

  // Sort the fetchedData in ascending order by tableNumber
  fetchedData.sort((a, b) {
    return (a['tableNumber'] as int).compareTo(b['tableNumber'] as int);
  });

  return fetchedData;
});

final tableItemsProvider2 = FutureProvider<List<String>>((ref) async {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final tablesSnapshot =
      await tablesCollection.where('status', whereIn: ['active']).get();

  final tableNames =
      tablesSnapshot.docs.map((doc) => doc.get('tableName') as String).toList();

  return tableNames;
});
