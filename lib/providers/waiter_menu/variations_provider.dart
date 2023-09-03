import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final variationsStreamProvider =
    StreamProvider.autoDispose<List<DocumentSnapshot>>(
  (ref) {
    final itemsCollection = FirebaseFirestore.instance.collection('variations');
    return itemsCollection
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  },
);
