import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MenuItemsNotifier extends StateNotifier<List<DocumentSnapshot>> {
  MenuItemsNotifier() : super([]);
  final menuItemsProvider =
      StateNotifierProvider<MenuItemsNotifier, List<DocumentSnapshot>>(
          (ref) => MenuItemsNotifier());

  Future<void> fetchMenuItems() async {
    final itemsCollection = FirebaseFirestore.instance.collection('menu');
    final querySnapshot = await itemsCollection.get();
    state = querySnapshot.docs;
  }

  Future<void> deleteMenuItem(String productId) async {
    try {
      final itemsCollection = FirebaseFirestore.instance.collection('menu');
      await itemsCollection.doc(productId).delete();

      final storageRef =
          FirebaseStorage.instance.ref().child('menu_images/$productId.jpg');
      await storageRef.delete();

      // Fetch updated menu items after deletion
      await fetchMenuItems();
    } catch (error) {
      print('ERROR: $error');
      // Handle errors
    }
  }
}
