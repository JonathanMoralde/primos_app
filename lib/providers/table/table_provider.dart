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
