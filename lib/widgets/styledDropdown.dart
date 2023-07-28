import 'package:flutter/material.dart';

class StyledDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChange;

  /*
  *   ONCHANGE
  (String? newValue) {
                        setState(() {
                          value = newValue;
                        });
                      }
  */

  const StyledDropdown({
    super.key,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 250,
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: DropdownButton(
        icon: const Icon(Icons.keyboard_arrow_down),
        underline: Container(),
        hint: const Text(
          "Category",
          style: TextStyle(fontSize: 14),
        ),
        value: value,
        isExpanded: true,
        items: const [
          // TODO CREATE A LISTVIEW.BUILDER TO MAKE THE DROPDOWN ITEM DYNAMIC
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
        onChanged: onChange,
      ),
    );
  }
}
