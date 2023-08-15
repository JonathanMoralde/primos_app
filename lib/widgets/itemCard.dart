import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/adminMenu_Form.dart';
import 'package:primos_app/widgets/imageLoader.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemCard extends StatelessWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final Widget? footerSection;
  final double? cardHeight;
  final bool? isRow;
  final String imageUrl;

  /*
  to change the footer section below:
  pass this parameter
  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[Text("replace this"), Text("Replace this")]),
   */

  // TODO DO NOT ALLOW THE IMAGE TO RERENDER ONCE LOADED FOR USER EXPERIENCE

  const ItemCard({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.footerSection,
    this.cardHeight,
    this.isRow,
    required this.imageUrl,
  }) : super(key: key);

  // Future<String> _getImageUrl(String productId) async {
  //   try {
  //     final DocumentSnapshot menuDoc = await FirebaseFirestore.instance
  //         .collection('menu')
  //         .doc(productId)
  //         .get();

  //     final imageUrl = menuDoc.get('imageURL') as String;
  //     return imageUrl;
  //   } catch (error) {
  //     print('ERROR: $error');
  //     // Handle errors
  //     return ''; // Return an empty string or a default image URL
  //   }
  // }

  Future<void> _deleteMenuItem(BuildContext context) async {
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

      // You can also show a confirmation dialog or take other actions if needed

      // Reload the UI to reflect the updated data (you can use a StreamBuilder for this)
    } catch (error) {
      print('ERROR: $error');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight ?? 220,
      width: isRow == true ? double.infinity : 174,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      child: isRow == true
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                      borderRadius: isRow == true
                          ? BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 15,
                        bottom: 8,
                      ), //modified this for row
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productName),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("$productPrice PHP"),
                          const SizedBox(
                            height: 8,
                          ),
                          // Footer section
                          footerSection ??
                              Row(
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
                                      _deleteMenuItem(context);
                                    },
                                    btnHeight: 30,
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              //DEFAULT LAYOUT OF ITEM CARD
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productName),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("$productPrice PHP"),
                          const SizedBox(
                            height: 8,
                          ),
                          // Footer section
                          footerSection ??
                              Row(
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
                                      _deleteMenuItem(context);
                                    },
                                    btnHeight: 30,
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
