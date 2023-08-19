import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:primos_app/pages/admin/adminMenu_CatForm.dart';
import 'package:primos_app/pages/admin/adminMenu_Form.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/itemCard.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/searchBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/categoryFilter/activeCategory_provider.dart';
import 'package:primos_app/providers/waiter_menu/menuItems_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/pages/waiter/menu_items_notifier.dart';

class AdminMenuPage extends ConsumerWidget {
  AdminMenuPage({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuItemsStreamProvider);

    Future<void> _deleteMenuItem(BuildContext context, String productId) async {
      try {
        // Delete the menu item from Firestore
        await FirebaseFirestore.instance
            .collection('menu')
            .doc(productId)
            .delete();

        // Delete the image from Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('menu_images/$productId.jpg');
        await storageRef.delete();

        // Refresh the menuItemsProvider to update the UI
        ref.refresh(menuItemsStreamProvider);
      } catch (error) {
        print('ERROR: $error');
        // Handle errors
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      drawer: SideMenu(pages: adminPages),
      appBar: AppBar(
        title: const Text("MENU"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomSearchBar(),
                FilterBtns(),
                Consumer(builder: (context, ref, child) {
                  final activeCategory = ref.watch(activeCategoryProvider);
                  return menuItems.when(
                    data: (itemDocs) {
                      final filteredItems = itemDocs.where((itemDoc) {
                        final productCategory = itemDoc['category'] as String;
                        return activeCategory == "All" ||
                            productCategory == activeCategory;
                      }).toList();

                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: filteredItems.map((itemDoc) {
                            final productId = itemDoc
                                .id; // Get the document ID as the productId
                            final productName = itemDoc['itemName'] as String;
                            final itemPrice = itemDoc['itemPrice'];
                            final double productPrice = (itemPrice is double)
                                ? itemPrice
                                : (itemPrice is int)
                                    ? itemPrice.toDouble()
                                    : 0.0;
                            final imageUrl = itemDoc['imageURL'] as String;

                            return ItemCard(
                              key: ValueKey(productId),
                              productId: productId, // Pass the productId
                              productName: productName,
                              productPrice: productPrice,
                              imageUrl: imageUrl,
                              footerSection: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StyledButton(
                                    noShadow: true,
                                    btnText: "Edit",
                                    onClick: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return AdminMenuForm(
                                              productId: productId,
                                              productName: productName,
                                              productPrice: productPrice,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    btnHeight: 30,
                                  ),
                                  StyledButton(
                                    noShadow: true,
                                    btnText: "Delete",
                                    onClick: () {
                                      // Call the delete function when the "Delete" button is pressed
                                      _deleteMenuItem(context, productId);
                                    },
                                    btnHeight: 30,
                                  ),
                                ],
                              ),
                            );
                          }).toList(), // Make sure to call toList() to convert the Iterable to List<Widget>
                        ),
                      );
                    },
                    error: (error, stackTrace) => Text("Error: $error"),
                    loading: () => CircularProgressIndicator(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: StyledButton(
                  noShadow: true,
                  btnText: "New Item",
                  onClick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AdminMenuForm();
                      }),
                    );
                  },
                  btnColor: const Color(0xfff8f8f7),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: StyledButton(
                  noShadow: true,
                  btnText: "New Category",
                  onClick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AdminMenuCatForm();
                      }),
                    );
                  },
                  btnColor: const Color(0xfff8f8f7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
