import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vatPercentageProvider = FutureProvider<int>((ref) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('vat')
        .doc('percentage') // Replace with the actual document ID
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final percentage = data['percentage'] as int;
      return percentage;
    } else {
      throw Exception('VAT document does not exist.');
    }
  } catch (e) {
    throw Exception('Error fetching VAT percentage: $e');
  }
});
