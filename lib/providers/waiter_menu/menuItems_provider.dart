import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuItemsProvider = FutureProvider<List<DocumentSnapshot>>((ref) async {
  final itemsCollection = FirebaseFirestore.instance.collection('menu');
  final querySnapshot = await itemsCollection.get();
  return querySnapshot.docs;
});
