import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDropdown.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/widgets/uploadImage_input.dart';

class AdminMenuForm extends StatefulWidget {
  AdminMenuForm({super.key});

  @override
  State<AdminMenuForm> createState() => _AdminMenuFormState();
}

class _AdminMenuFormState extends State<AdminMenuForm> {
  final itemNameController = TextEditingController();

  final itemPriceController = TextEditingController();

  final itemCategoryController = TextEditingController();

  final itemImageController = TextEditingController();

  String? category;

  String? selectedImagePath; // Store the selected image path here

  // Function to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImagePath = image.path; // Store the selected image path
      });
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
          title: const Text("ADD ITEM"),
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
                    }),
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
                  onClick: () {},
                  btnWidth: 250,
                )
              ],
            ),
          ),
        ));
  }
}
