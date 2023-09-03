import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/admin/adminMenu_CatForm.dart';
import 'package:primos_app/pages/admin/adminMenu_Form.dart';
import 'package:primos_app/pages/admin/category.dart';
import 'package:primos_app/providers/categoryFilter/activeCategory_provider.dart';
import 'package:primos_app/providers/searchBar/searchQuery_provider.dart';
import 'package:primos_app/providers/waiter_menu/variations_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/itemCard.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/searchBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/pageObject.dart';

import '../../providers/waiter_menu/menuItems_provider.dart';

// TODO REFACTOR THIS PAGE TO USE RIVERPOD STATE MANAGEMENT

class AdminMenuPage extends ConsumerWidget {
  AdminMenuPage({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuItemsStreamProvider);
    final variationsStream = ref.watch(variationsStreamProvider);
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
                Consumer(
                  builder: ((context, ref, child) {
                    final activeCategory = ref.watch(activeCategoryProvider);
                    final searchQuery =
                        ref.watch(searchQueryProvider).toLowerCase();

                    return menuItems.when(
                        data: (itemDocs) {
                          // FILTER BASED ON ACTIVE CATEGORY
                          final filteredItems = itemDocs.where((itemDoc) {
                            final productCategory =
                                itemDoc['category'] as String;
                            final productName =
                                itemDoc['itemName'].toString().toLowerCase();
                            return (activeCategory == "All" ||
                                    productCategory == activeCategory) &&
                                (searchQuery.isEmpty ||
                                    productName.contains(searchQuery));
                          }).toList();

                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: filteredItems.map((itemDoc) {
                                final productId = itemDoc.id;
                                final productName =
                                    itemDoc['itemName'] as String;
                                final itemPrice = itemDoc['itemPrice'];
                                final double productPrice =
                                    (itemPrice is double)
                                        ? itemPrice
                                        : (itemPrice is int)
                                            ? itemPrice.toDouble()
                                            : 0.0;
                                final imageUrl = itemDoc['imageURL'] as String;

                                return variationsStream.when(
                                    data: (varDoc) {
                                      List<dynamic>? varList;
                                      List<dynamic>? varPriceList;
                                      List<String> variations = [];
                                      List<String> prices = [];
                                      for (final itemVar in varDoc)
                                        if (itemVar.id == productId) {
                                          varList = itemVar['variations'];
                                          varPriceList = itemVar['prices'];
                                        }

                                      if (varList is List<dynamic>) {
                                        variations = varList.cast<String>();
                                      }
                                      if (varPriceList is List<dynamic>) {
                                        prices = varPriceList.cast<String>();
                                      }

                                      return ItemCard(
                                        cardWidth: 165,
                                        key: ValueKey(productId),
                                        productId: productId,
                                        productName: productName,
                                        productPrice: productPrice,
                                        variations: variations.isNotEmpty
                                            ? variations
                                            : null,
                                        prices:
                                            prices.isNotEmpty ? prices : null,
                                        imageUrl: imageUrl,
                                      );
                                    },
                                    error: (error, stackTrace) =>
                                        Text("Error: $error"),
                                    loading: () => CircularProgressIndicator());
                              }).toList(),
                            ),
                          );
                        },
                        error: (error, stackTrace) => Text("Error: $error"),
                        loading: () => Center(
                                child: CircularProgressIndicator(
                              color: Color(0xFFE2B563),
                            )));
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      noShadow: true,
                      btnIcon: const Icon(Icons.add),
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: StyledButton(
                      noShadow: true,
                      btnText: "Delete Category",
                      onClick: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Categories(),
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
