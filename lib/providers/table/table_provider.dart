import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tableItemsProvider = StreamProvider<List<String>>((ref) {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final query = tablesCollection.where('status', whereIn: ['active', 'merged']);

  return query.snapshots().map((tablesSnapshot) {
    return tablesSnapshot.docs
        .map((doc) => doc.get('tableName') as String)
        .toList();
  });
});

final tableDataProvider =
    StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>?, String>(
        (ref, tableName) {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final query = tablesCollection.where('tableName', isEqualTo: tableName);

  return query.snapshots().map((tablesSnapshot) {
    if (tablesSnapshot.docs.isNotEmpty) {
      return tablesSnapshot.docs.first;
    } else {
      return null;
    }
  });
});

final mergedTablesProvider = StreamProvider<List<String>>((ref) {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final query = tablesCollection.where('status', isEqualTo: 'merged');

  return query.snapshots().map((tablesSnapshot) {
    return tablesSnapshot.docs
        .map((doc) => doc.get('tableName') as String)
        .toList();
  });
});

final allTableItemsProvider = StreamProvider<List<Map<String, Object>>>((ref) {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final query = tablesCollection.orderBy('tableNumber');

  return query.snapshots().map((tablesSnapshot) {
    return tablesSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'tableId': doc.id,
        'tableName': data['tableName'] as String,
        'tableNumber': data['tableNumber'] as int,
      };
    }).toList();
  });
});

final tableItemsProvider2 = StreamProvider<List<String>>((ref) {
  final tablesCollection = FirebaseFirestore.instance.collection('tables');
  final query = tablesCollection.where('status', whereIn: ['active']);

  return query.snapshots().map((tablesSnapshot) {
    return tablesSnapshot.docs
        .map((doc) => doc.get('tableName') as String)
        .toList();
  });
});
