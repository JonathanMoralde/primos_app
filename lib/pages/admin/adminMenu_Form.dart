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
  final String? productId;
  final String? productName;
  final double? productPrice;

  const AdminMenuForm({
    Key? key,
    this.productId,
    this.productName,
    this.productPrice,
  }) : super(key: key);

  @override
  State<AdminMenuForm> createState() => _AdminMenuFormState();
}

class _AdminMenuFormState extends State<AdminMenuForm> {
  final itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  String? category;
  String? selectedImagePath;

  Future<void> updateMenu(String imageUrl) async {
    final String itemName = itemNameController.text;
    final double itemPrice = double.tryParse(itemPriceController.text) ?? 0.0;
    final String selectedCategory = category ?? '';

    try {
      // Ensure we have a valid productId to update an existing item
      if (widget.productId != null) {
        await FirebaseFirestore.instance
            .collection('menu')
            .doc(widget.productId)
            .update({
          'itemName': itemName,
          'itemPrice': itemPrice,
          'category': selectedCategory,
          'imageURL': imageUrl,
        });

        // Successfully updated item, you can navigate back
        Navigator.of(context).pop(true);
      } else {
        print("Invalid productId. Cannot update item.");
      }
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

  Future<void> _uploadImageAndUpdateMenu() async {
    if (selectedImagePath == null) {
      // Show an error if no image is selected
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please select an image."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Do not proceed
    }

    if (itemNameController.text.isEmpty ||
        itemPriceController.text.isEmpty ||
        category == null) {
      // Show an error if any required fields are missing
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all required fields."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Do not proceed
    }

    try {
      final file = File(selectedImagePath!);

      // Generate a unique image name using UUID
      final imageName = Uuid().v4(); // Generates a random UUID

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('menu_images')
          .child('$imageName.jpg'); // Use the unique image name

      final metadata = SettableMetadata(
        contentType: 'image/jpeg', // Set the content type to image/jpeg
        cacheControl: 'max-age=0', // Disable caching for the updated image
      );

      final uploadTask =
          storageRef.putFile(file, metadata); // Include the metadata

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // If productId is null, it's a new item, otherwise, it's an edit
      if (widget.productId == null) {
        // Add a new menu item
        final String itemName = itemNameController.text;
        final double itemPrice =
            double.tryParse(itemPriceController.text) ?? 0.0;
        final String selectedCategory = category ?? '';

        try {
          await FirebaseFirestore.instance.collection('menu').add({
            'itemName': itemName,
            'itemPrice': itemPrice,
            'category': selectedCategory,
            'imageURL': imageUrl,
          });

          // Successfully added item, you can navigate back
          Navigator.of(context).pop(true);
        } catch (error) {
          print('ERROR: $error');
        }
      } else {
        // Update an existing menu item
        await updateMenu(imageUrl);
      }
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
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              StyledTextField(
                controller: itemPriceController,
                hintText: "Item Price",
                obscureText: false,
              ),
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
                items: [],
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
                onClick: _uploadImageAndUpdateMenu,
                btnWidth: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
