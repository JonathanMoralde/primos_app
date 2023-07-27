import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                SizedBox(
                  height: 10,
                ),
                StyledTextField(
                    controller: itemPriceController,
                    hintText: "Item Price",
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 45,
                  width: 250,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: DropdownButton(
                      underline: Container(),
                      hint: const Text(
                        "Category",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: category,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: "Cat1",
                          child: Text(
                            "Cat1",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Cat2",
                          child: Text(
                            "Cat2",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          category = newValue;
                        });
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                StyledTextField(
                    controller: itemImageController,
                    hintText: "Image",
                    obscureText: false),
                SizedBox(
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
