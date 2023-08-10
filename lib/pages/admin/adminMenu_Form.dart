import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDropdown.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/widgets/uploadImage_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class AdminMenuForm extends StatefulWidget {
  final String? productName;
  final double? productPrice;

  const AdminMenuForm({Key? key, this.productName, this.productPrice})
      : super(key: key);

  @override
  State<AdminMenuForm> createState() => _AdminMenuFormState();
}

class _AdminMenuFormState extends State<AdminMenuForm> {
  final itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  String? category;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    // Set the initial values for the text fields
    itemNameController.text =
        widget.productName ?? ''; // If productName is null, set an empty string
    itemPriceController.text = widget.productPrice?.toString() ??
        ''; // If productPrice is null, set an empty string
  }

  Future<void> addMenu(String imageUrl) async {
    final String itemName = itemNameController.text;
    final double itemPrice = double.tryParse(itemPriceController.text) ?? 0.0;
    final String selectedCategory = category ?? '';

    try {
      await FirebaseFirestore.instance.collection('menu').add({
        'itemName': itemName,
        'itemPrice': itemPrice,
        'category': selectedCategory,
        'imageURL': imageUrl,
      });
    } catch (error) {
      print('ERROR: $error');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImagePath = image.path; // Store the selected image path
      });
    }
  }

  Future<void> _uploadImageAndAddMenu() async {
    if (selectedImagePath == null) {
      return; // No image selected
    }

    try {
      final file = File(selectedImagePath!);

      // Generate a unique image name using UUID
      final imageName = Uuid().v4(); // Generates a random UUID

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('menu_images')
          .child('$imageName.jpg'); // Use the unique image name
      final uploadTask = storageRef.putFile(file);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Call the addMenu function to store the data in Firestore
      await addMenu(imageUrl);

      // Reset form fields and selected image path after successful addition
      itemNameController.clear();
      itemPriceController.clear();
      setState(() {
        category = null;
        selectedImagePath = null;
      });
    } catch (error) {
      print('ERROR: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf7f7f7),
        appBar: AppBar(
          leading: IconButton(
            //manual handle back button
            icon: const Icon(Icons.keyboard_arrow_left),
            iconSize: 35,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: widget.productName != null && widget.productPrice != null
              ? Text("EDIT ITEM")
              : Text("ADD ITEM"),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledTextField(
                    controller: itemNameController,
                    hintText: "Item Name",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                    controller: itemPriceController,
                    hintText: "Item Price",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                StyledDropdown(
                  value: category,
                  onChange: (String? newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                  hintText: "Category",
                  items: const ['Beverages', 'Meat', 'Salads', 'Pastas'],
                ),
                const SizedBox(
                  height: 10,
                ),
                UploadImage(
                  onPressed: _pickImage,
                  text: selectedImagePath,
                ),
                const SizedBox(
                  height: 20,
                ),
                StyledButton(
                  btnText: "ADD",
                  onClick: () {
                    _uploadImageAndAddMenu();
                  },
                  btnWidth: 250,
                )
              ],
            ),
          ),
        ));
  }
}
