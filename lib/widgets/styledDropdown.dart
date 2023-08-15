import 'package:flutter/material.dart';

class StyledDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChange;
  final String hintText;
  final List<String> items;

  const StyledDropdown({
    Key? key,
    required this.value,
    required this.onChange,
    required this.hintText,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure unique values for items
    final uniqueItems = items.toSet().toList();

    return Container(
      height: 45,
      width: 250,
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: DropdownButton(
        icon: const Icon(Icons.keyboard_arrow_down),
        underline: Container(),
        hint: Text(
          hintText,
          style: const TextStyle(fontSize: 14),
        ),
        value: value,
        isExpanded: true,
        items: uniqueItems.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: onChange,
      ),
    );
  }
}
