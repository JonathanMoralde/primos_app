import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/widgets/styledButton.dart';

class AdminMenuCatForm extends StatelessWidget {
  AdminMenuCatForm({super.key});

  final categoryNameController = TextEditingController();

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
          title: const Text("ADD CATEGORY"),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledTextField(
                    controller: categoryNameController,
                    hintText: "Category Name",
                    obscureText: false),
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
