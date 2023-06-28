import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final controller; //for accessing the textField value
  final String hintText; //dynamic label or hint
  final bool obscureText; //true = for password

  const StyledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 250,
      child: TextField(
        style: const TextStyle(fontSize: 14.0),
        controller: controller, //controller
        obscureText: obscureText, //obscureText
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(bottom: 16, left: 10, right: 10),
          hintText: hintText, //hintText
          filled: true,
          fillColor: Colors.grey.shade300,
          border: InputBorder.none, // To remove the default border
          // ENABLED BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          // FOCUSED BORDER
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
