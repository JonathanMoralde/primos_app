import 'package:flutter/material.dart';

class StyledDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChange;
  final String hintText;
  final List<String> items;
  final double? width;
  final dynamic dropdownColor;

  const StyledDropdown({
    Key? key,
    required this.value,
    required this.onChange,
    required this.hintText,
    required this.items,
    this.width,
    this.dropdownColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: width ?? 250,
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: dropdownColor ?? Colors.grey.shade300,
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
        items: items.map((item) {
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
