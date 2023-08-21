import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchCategoryProvider = FutureProvider<List<String>>((ref) async {
  try {
    final categoriesCollection =
        FirebaseFirestore.instance.collection('categories');
    print("Fetching categories...");
    final QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
        await categoriesCollection.get();
    print("Fetched categories: ${categoriesSnapshot.docs}");

    final List<String> fetchedCategories = ['All'];

    categoriesSnapshot.docs.forEach((categoryDoc) {
      final categoryName = categoryDoc.data()['categoryName'] as String?;
      if (categoryName != null) {
        fetchedCategories.add(categoryName);
      }
    });

    return fetchedCategories;
  } catch (error) {
    print("Error fetching categories: $error");
    throw error; // Re-throw the error to maintain the error state in the provider
  }
});
