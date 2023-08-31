import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/admin/adminMenu_Form.dart';
import 'package:primos_app/providers/waiter_menu/menuItems_provider.dart';
import 'package:primos_app/widgets/imageLoader.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:primos_app/pages/admin/addVariation_Form.dart';

class ItemCard extends ConsumerWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final Widget? footerSection;
  final double? cardHeight;
  final bool? isRow;
  final String imageUrl;
  final double? cardWidth;

  const ItemCard({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.footerSection,
    this.cardHeight,
    this.isRow,
    required this.imageUrl,
    this.cardWidth,
  }) : super(key: key);

  Future<void> delModal(BuildContext context, WidgetRef ref) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
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
                      Text(
                          "Are you sure you want to delete this from the menu?"),
                      const SizedBox(
                        height: 5,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                          ),
                          SizedBox(
                              width:
                                  4), // Adding a small gap between the icon and text
                          Flexible(
                            child: Text(
                              "Confirming this action cannot be undone",
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Cancel",
                                onClick: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: StyledButton(
                                btnText: "Confirm",
                                onClick: () async {
                                  _deleteMenuItem(context, ref);
                                  // Trigger a refresh after category deletion
                                  // ref.refresh(fetchCategoriesOnlyProvider);
                                  // ref.refresh(fetchCategoryProvider);

                                  Navigator.of(context).pop();
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));

  // Future<String> _getImageUrl(String productId) async {
  Future<void> _deleteMenuItem(BuildContext context, WidgetRef ref) async {
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

      ref.refresh(menuItemsStreamProvider);

      // Reload the UI to reflect the updated data (you can use a StreamBuilder for this)
    } catch (error) {
      print('ERROR: $error');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: cardHeight ?? 300,
      width: isRow == true ? double.infinity : cardWidth ?? 170,
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
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : const BorderRadius.only(
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              productName,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                            ),
                          ),
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
                                      // _deleteMenuItem(context);
                                      delModal(context, ref);
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              productName,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("$productPrice PHP"),
                          const SizedBox(
                            height: 8,
                          ),
                          // Footer section
                          Column(
                            children: [
                              footerSection ??
                                  Column(
                                    children: [
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return AdminMenuForm(
                                                      productId: productId,
                                                      productName: productName,
                                                      productPrice:
                                                          productPrice,
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
                                              // _deleteMenuItem(context);
                                              delModal(context, ref);
                                            },
                                            btnHeight: 30,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              12), // Adjust the spacing as needed
                                      StyledButton(
                                        btnHeight: 30,
                                        btnText: 'Add Variation',
                                        onClick: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return AddVariationForm(
                                                  productId: productId,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    ],
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
