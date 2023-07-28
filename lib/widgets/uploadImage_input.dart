import 'package:flutter/material.dart';

class UploadImage extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;

  const UploadImage({super.key, required this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 250,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(
            EdgeInsets.all(8),
          ),
          backgroundColor: MaterialStatePropertyAll(Colors.grey.shade300),
          iconColor: MaterialStatePropertyAll(
            Colors.grey.shade700,
          ),
          foregroundColor: MaterialStatePropertyAll(Colors.grey.shade700),
          elevation:
              const MaterialStatePropertyAll(0), //this removes box shadow
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text ?? 'Image',
                overflow: TextOverflow.ellipsis,
              ),
            ), // <-- Text
            const Icon(
              // <-- Icon
              Icons.upload,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
