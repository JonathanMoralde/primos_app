import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  const ProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    int valuePerc = (value * 100).toInt();
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: LinearProgressIndicator(
            minHeight: 15,
            value: value, //* temp & change to variable soon, value is 0 to 1
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFE3034)),
          ),
        ),
        Text(
          "$valuePerc%",
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
