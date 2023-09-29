import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/waiter_menu_cart.dart';
import 'package:primos_app/providers/categoryFilter/activeCategory_provider.dart';
import 'package:primos_app/providers/isAdditionalOrder/isAdditionalOrder_provider.dart';
import 'package:primos_app/providers/waiter_menu/currentOrder_provider.dart';
import 'package:primos_app/providers/waiter_menu/isTakeout_provider.dart';
import 'package:primos_app/providers/waiter_menu/menuItems_provider.dart';
import 'package:primos_app/providers/waiter_menu/orderName_provider.dart';
import 'package:primos_app/providers/waiter_menu/variations_provider.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/searchBar.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/searchBar/searchQuery_provider.dart';
import '../../providers/waiter_menu/subtotal_provider.dart';
import '../../widgets/itemCard.dart';
import '../../widgets/styledDropdown.dart';
import '../../providers/kitchen/variation_provider.dart';

import 'package:primos_app/widgets/orderObject.dart';

// STATE MANAGEMENT
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaiterMenu extends ConsumerWidget {
  WaiterMenu({super.key});

  double calculateSubtotal(List<OrderObject> orders) {
    return orders.fold(0, (double sum, OrderObject order) {
      return sum + (order.price * order.quantity);
    });
  }

  void updateSubtotal(WidgetRef ref) {
    final currentOrders = ref.watch(currentOrdersProvider);
    ref.read(subtotalProvider.notifier).state =
        calculateSubtotal(currentOrders);
  }

  void removeOrder(WidgetRef ref, int index) {
    ref.read(currentOrdersProvider.notifier).state.removeAt(index);
    updateSubtotal(ref);
  }

  Future<void> addModal(
      BuildContext context,
      WidgetRef ref,
      productId,
      productName,
      productPrice,
      List<String> productVariations,
      imageUrl,
      String status) async {
    print('Add modal function called.');
    final currentOrders = ref.watch(currentOrdersProvider);

    int localQuantity = 1;
    String? localVariation;
    // productVariations.isNotEmpty ? productVariations.first : null;
    String? selectedVarPrice;
    // productVariations.isNotEmpty ? productPrice.first : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      productName,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (productVariations.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text("Variation: "),
                              ),
                              Expanded(
                                flex: 2,
                                child: StyledDropdown(
                                  width: double.infinity,
                                  dropdownColor: Color(0xFFf8f8f7),
                                  value: localVariation,
                                  onChange: (String? newValue) {
                                    setState(() {
                                      localVariation = newValue;
                                      selectedVarPrice = productPrice[
                                          productVariations.indexOf(newValue!)];
                                    });

                                    print(selectedVarPrice);
                                  },
                                  hintText: "Select Variation",
                                  items: productVariations,
                                  showFetchedCategories: false,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Quantity: "),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFf8f8f7),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              height: 40,
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (localQuantity != 0) {
                                          localQuantity--;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                    iconSize: 25,
                                  ),
                                  Text(
                                    localQuantity.toString(),
                                    style: const TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        localQuantity++;
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    iconSize: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            StyledButton(
                              btnText: "Cancel",
                              onClick: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                btnText: "Confirm",
                                onClick: () {
                                  int existingIndex = currentOrders.indexWhere(
                                    (order) =>
                                        order.name == productName &&
                                        order.variation == localVariation &&
                                        order.price ==
                                            (productVariations.isEmpty
                                                ? productPrice
                                                : double.parse(
                                                    selectedVarPrice!)),
                                  );

                                  if (existingIndex != -1) {
                                    ref
                                        .read(currentOrdersProvider.notifier)
                                        .state[existingIndex]
                                        .quantity += localQuantity;
                                  } else {
                                    final currentOrder = OrderObject(
                                      id: productId,
                                      name: productName,
                                      price: productVariations.isEmpty
                                          ? productPrice
                                          : double.parse(selectedVarPrice!),
                                      variation: localVariation,
                                      quantity: localQuantity,
                                      imageUrl: imageUrl,
                                      status: status,
                                    );

                                    ref
                                        .read(currentOrdersProvider.notifier)
                                        .state
                                        .add(currentOrder);
                                  }
                                  updateSubtotal(ref);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(subtotalProvider);
    final menuItems = ref.watch(menuItemsStreamProvider);
    final variationsStream = ref.watch(variationsStreamProvider);

    return WillPopScope(
      onWillPop: () async {
        // Reset the currentOrdersProvider state when navigating back
        ref.read(currentOrdersProvider.notifier).state = [];
        ref.read(isAdditionalOrderProvider.notifier).state = false;
        ref.read(orderNameProvider.notifier).state = null;

        ref.read(isTakeoutProvider.notifier).state = false;

        updateSubtotal(ref);
        return true; // Allow navigation
      },
      child: Scaffold(
        backgroundColor: Color(0xfff8f8f7),
        appBar: AppBar(
          leading: IconButton(
            //manual handle back button
            icon: const Icon(Icons.keyboard_arrow_left),
            iconSize: 35,
            onPressed: () {
              // RESET CURRENT ORDERS
              ref.read(currentOrdersProvider.notifier).state = [];
              ref.read(isAdditionalOrderProvider.notifier).state = false;
              ref.read(orderNameProvider.notifier).state = null;
              ref.read(isTakeoutProvider.notifier).state = false;
              updateSubtotal(ref);
              Navigator.of(context).pop();
            },
          ),
          title: Text("MENU"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomSearchBar(),
                FilterBtns(),
                Consumer(builder: ((context, ref, child) {
                  final activeCategory = ref.watch(activeCategoryProvider);
                  final searchQuery =
                      ref.watch(searchQueryProvider).toLowerCase();

                  return menuItems.when(
                    data: (itemDocs) {
                      // FILTER BASED ON ACTIVE CATEGORY
                      final filteredItems = itemDocs.where((itemDoc) {
                        final productCategory = itemDoc['category'] as String;
                        final productName =
                            itemDoc['itemName'].toString().toLowerCase();
                        // return activeCategory == "All" ||
                        //     productCategory == activeCategory;
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
                            final productName = itemDoc['itemName'] as String;
                            final itemPrice = itemDoc['itemPrice'];
                            final double productPrice = (itemPrice is double)
                                ? itemPrice
                                : (itemPrice is int)
                                    ? itemPrice.toDouble()
                                    : 0.0;
                            final imageUrl = itemDoc['imageURL'] as String;
                            final productStatus =
                                itemDoc['itemStatus'] as String;

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
                                    cardHeight: 220,
                                    key: ValueKey(productId),
                                    productId: productId,
                                    productName: productName,
                                    productPrice: productPrice,
                                    variations: variations.isNotEmpty
                                        ? variations
                                        : null,
                                    prices: prices.isNotEmpty ? prices : null,
                                    imageUrl: imageUrl,
                                    status: productStatus,
                                    footerSection: Column(children: [
                                      StyledButton(
                                          btnIcon: Icon(Icons.add),
                                          noShadow: true,
                                          btnWidth: double.infinity,
                                          btnHeight: 35,
                                          btnText: "Add",
                                          onClick: productStatus == "Unavail"
                                              ? null
                                              : () {
                                                  if (variations.isNotEmpty) {
                                                    addModal(
                                                      context,
                                                      ref,
                                                      productId,
                                                      productName,
                                                      prices,
                                                      variations, // Pass the fetched variations
                                                      imageUrl,
                                                      productStatus,
                                                    );
                                                  } else {
                                                    addModal(
                                                      context,
                                                      ref,
                                                      productId,
                                                      productName,
                                                      productPrice,
                                                      variations, // Pass the fetched variations
                                                      imageUrl,
                                                      productStatus,
                                                    );
                                                  }
                                                })
                                    ]),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    Text("Error: $error"),
                                loading: () => Center(
                                        child: CircularProgressIndicator(
                                      color: Color(0xFFE2B563),
                                    )));
                          }).toList(),
                        ),
                      );
                    },
                    error: (error, stackTrace) => Text("Error: $error"),
                    loading: () => Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFFE2B563),
                    )),
                  );
                }))
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: StyledButton(
                    btnIcon: Icon(Icons.shopping_cart_checkout),
                    noShadow: true,
                    btnText: "View Orders",
                    secondText: "PHP ${subtotal.toStringAsFixed(2)}",
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return WaiterMenuCart();
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
      ),
    );
  }
}
