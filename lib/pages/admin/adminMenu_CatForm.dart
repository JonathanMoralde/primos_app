import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/categoryFilter/fetchCategory_provider.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMenuCatForm extends ConsumerWidget {
  AdminMenuCatForm({super.key});

  final categoryNameController = TextEditingController();

  Future<void> addCategory() async {
    String categoryName = categoryNameController.text;

    try {
      if (categoryName.isNotEmpty) {
        Map<String, dynamic> data = {"categoryName": categoryName};
        await FirebaseFirestore.instance.collection('categories').add(data);
        categoryNameController.clear();
        const ScaffoldMessenger(
            child: SnackBar(content: Text('Category Added Successfully')));
      } else {
        print('Category name is empty');
      }
    } catch (error) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  btnIcon: const Icon(Icons.add),
                  btnText: "ADD",
                  onClick: () {
                    addCategory();
                    ref.refresh(fetchCategoriesOnlyProvider);
                    ref.refresh(fetchCategoryProvider);
                  },
                  btnWidth: 250,
                )
              ],
            ),
          ),
        ));
  }
}
