import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String btnText;
  Function()? onClick;
  final btnIcon;

  StyledButton({
    super.key,
    required this.btnText,
    required this.onClick,
    this.btnIcon,
  });

  @override
  Widget build(BuildContext context) {
    // BUTTON WITH ICON
    if (btnIcon != null) {
      return SizedBox(
        height: 45,
        width: 250,
        child: ElevatedButton.icon(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            // fixedSize: const Size(250, 32),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: const Color.fromARGB(255, 226, 181, 99),
            foregroundColor: const Color.fromARGB(255, 37, 37, 37),
            textStyle: const TextStyle(
                letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          icon: btnIcon,
          label: Text(btnText),
        ),
      );
    } else {
      // BUTTON WITHOUT ICON
      return SizedBox(
        height: 45,
        width: 250,
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            // fixedSize: const Size(250, 32),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: const Color.fromARGB(255, 226, 181, 99),
            foregroundColor: const Color.fromARGB(255, 37, 37, 37),
            textStyle: const TextStyle(
                letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          child: Text(btnText),
        ),
      );
    }
  }
}
