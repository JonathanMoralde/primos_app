import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final dynamic child;
  final double height;

  const BottomBar({
    super.key,
    this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -3), // changes position of shadow
          ),
        ],
        color: Color(0xFFE2B563),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: child,
    );
  }
}
