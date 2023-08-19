import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final fetchVariationsProvider = FutureProvider<List<String>>((ref) async {
  final variationsCollection =
      FirebaseFirestore.instance.collection('variations');
  final variationsSnapshot = await variationsCollection.get();

  final variationNames = variationsSnapshot.docs
      .map((doc) => doc.get('variationName') as String)
      .toList();

  return variationNames;
});
