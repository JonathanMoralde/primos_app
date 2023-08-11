import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/searchBar.dart';

import '../../widgets/itemCard.dart';

class WaiterMenu extends StatefulWidget {
  const WaiterMenu({super.key});

  @override
  State<WaiterMenu> createState() => _WaiterMenuState();
}

class _WaiterMenuState extends State<WaiterMenu> {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('menu');
  @override
  Widget build(BuildContext context) {
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
                          footerSection: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("Test"), Text("Test")]),
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
      bottomNavigationBar: BottomBar(height: 100),
    );
  }
}
