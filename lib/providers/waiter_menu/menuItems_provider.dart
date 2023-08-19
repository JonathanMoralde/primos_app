import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final menuItemsStreamProvider =
    StreamProvider.autoDispose<List<DocumentSnapshot>>(
  (ref) {
    final itemsCollection = FirebaseFirestore.instance.collection('menu');
    return itemsCollection
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  },
);
