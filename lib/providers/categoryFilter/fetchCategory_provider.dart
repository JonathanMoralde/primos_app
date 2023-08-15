import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final fetchCategoryProvider = FutureProvider<List<QuerySnapshot>>((ref) async {
//   final categoriesCollection =
//       FirebaseFirestore.instance.collection('categories');
//   final QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
//       await categoriesCollection.get();

//   return categoriesSnapshot;
//   // final List<String> fetchedCategories = [
//   //     "All",];

//   // categoriesSnapshot.docs.forEach((categoryDoc) {
//   //     final categoryName = categoryDoc.data()['categoryName'] as String;
//   //     fetchedCategories.add(categoryName);
//   //     });

// });

final fetchCategoryProvider = FutureProvider<List<String>>((ref) async {
  try {
    final categoriesCollection =
        FirebaseFirestore.instance.collection('categories');
    final QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
        await categoriesCollection.get();

    final List<String> fetchedCategories = ['All'];

    categoriesSnapshot.docs.forEach((categoryDoc) {
      final categoryName = categoryDoc.data()['categoryName'] as String;
      fetchedCategories.add(categoryName);
    });

    return fetchedCategories;
  } catch (error) {
    // Handle error here
    throw Error();
  }
});
