import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primos_app/pages/waiter/waiter_menu_cart.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/searchBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

import '../../widgets/itemCard.dart';

class WaiterMenu extends StatefulWidget {
  const WaiterMenu({super.key});

  @override
  State<WaiterMenu> createState() => _WaiterMenuState();
}

class _WaiterMenuState extends State<WaiterMenu> {
  // firebase
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('menu');

  @override
  Widget build(BuildContext context) {
    int subtotal = 0;

    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("MENU"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSearchBar(),
              FilterBtns(),
              StreamBuilder<QuerySnapshot>(
                stream: itemsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final itemDocs = snapshot.data!.docs;

                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: itemDocs.map((itemDoc) {
                        final productId =
                            itemDoc.id; // Get the document ID as the productId
                        final productName = itemDoc['itemName'] as String;
                        final itemPrice = itemDoc['itemPrice'];
                        final double productPrice = (itemPrice is double)
                            ? itemPrice
                            : (itemPrice is int)
                                ? itemPrice.toDouble()
                                : 0.0;

                        return ItemCard(
                          productId: productId, // Pass the productId
                          productName: productName,
                          productPrice: productPrice,
                          cardHeight: 280,
                          footerSection: Column(
                            children: [
                              const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("Test"), Text("Test")]),
                              const SizedBox(
                                height: 5,
                              ),
                              StyledButton(
                                  noShadow: true,
                                  btnWidth: double.infinity,
                                  btnHeight: 35,
                                  btnText: "Add to order",
                                  onClick: () {
                                    // TODO ADD THE ITEM DETAILS TO AN ARRAY OR LIST THEN STORE IN PROVIDER(state management)
                                    // TODO THEN NAVIGATE TO CART PAGE, GRAB THE ITEMS IN THE LIST/ARRAY AND DISPLAY + WAITER CAN DELETE/REMOVE, EDIT QTY OR VARIANT
                                    // TODO WAITER CAN THEN CHECKOUT/CONFIRM ORDERS
                                    print("Added to cart");
                                  })
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
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
                  secondText: "PHP $subtotal",
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
    );
  }
}
