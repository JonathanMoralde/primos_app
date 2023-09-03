import 'package:flutter/material.dart';

//this button can take 4 parameters, btnText & onClick is required
// example1:   StyleButton(btnText: "Test", onClick: (){})
// example2:   StyleButton(btnText: "Test", onClick: (){}, btnIcon: Icon(Icons.login), btnWidth: 250)
// 250 is the default width

class StyledButton extends StatelessWidget {
  final String btnText;
  final Function()? onClick;
  final dynamic btnIcon;
  final double? btnWidth;
  final double? btnHeight;
  final dynamic btnColor;
  final bool? noShadow;
  final String? secondText;
  final dynamic borderRadius;

  const StyledButton({
    super.key,
    required this.btnText,
    required this.onClick,
    this.btnIcon,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.noShadow,
    this.secondText,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // BUTTON WITH ICON
    if (btnIcon != null) {
      return SizedBox(
        height: btnHeight ?? 45,
        width: btnWidth,
        child: ElevatedButton.icon(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            // fixedSize: const Size(250, 32),
            elevation: noShadow == true ? 0 : 2,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8)),
            backgroundColor: btnColor ?? const Color(0xFFE2B563),
            foregroundColor: const Color.fromARGB(255, 37, 37, 37),
            textStyle: const TextStyle(
                letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          icon: btnIcon,
          label: secondText != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(btnText), Text(secondText!)],
                )
              : Text(btnText),
        ),
      );
    } else {
      // BUTTON WITHOUT ICON
      return SizedBox(
        height: btnHeight ?? 45,
        width: btnWidth,
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            // fixedSize: const Size(250, 32),
            elevation: noShadow == true ? 0 : 2,

            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8)),
            backgroundColor:
                btnColor ?? const Color.fromARGB(255, 226, 181, 99),
            foregroundColor: const Color.fromARGB(255, 37, 37, 37),
            textStyle: const TextStyle(
                letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          child: Text(
            btnText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }
}
