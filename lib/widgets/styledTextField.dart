import 'package:flutter/material.dart';

class StyledTextField extends StatefulWidget {
  final controller; //for accessing the textField value
  final String hintText; //dynamic label or hint
  bool obscureText; //true = for password
  final dynamic keyboardType;
  final double? width;
  final dynamic borderRadius;
  final bool? isPassword;

  StyledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
    this.width,
    this.borderRadius,
    this.isPassword,
  });

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  bool isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  void _textListener() {
    setState(() {
      isTextFieldEmpty = widget.controller.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: widget.width ?? 250,
      child: TextField(
        keyboardType: widget.keyboardType ?? TextInputType.text,
        style: const TextStyle(fontSize: 14.0),
        controller: widget.controller, //controller
        obscureText: widget.obscureText, //obscureText
        cursorColor: Color(0xFF252525),
        decoration: InputDecoration(
          // show pass btn
          suffixIcon: widget.isPassword == true && !isTextFieldEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding:
              const EdgeInsets.only(bottom: 16, left: 10, right: 10),
          hintText: widget.hintText, //hintText
          filled: true,
          fillColor: Colors.grey.shade300,
          border: InputBorder.none, // To remove the default border
          // ENABLED BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ??
                BorderRadius.all(
                  Radius.circular(8),
                ),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          // FOCUSED BORDER
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ??
                BorderRadius.all(
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
