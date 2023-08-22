import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableItemsProvider = FutureProvider<List<String>>((ref) async {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final tablesSnapshot = await tablesCollection.get();

  final tableNames =
      tablesSnapshot.docs.map((doc) => doc.get('tableName') as String).toList();

  return tableNames;
});
