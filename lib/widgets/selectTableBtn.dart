import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/selectedTabletoMerge/selectedTable_provider.dart';

class SelectTableBtn extends ConsumerWidget {
  final VoidCallback onPressed;
  final String? text;
  final List<String>? selected;

  const SelectTableBtn(
      {Key? key, required this.onPressed, this.text, this.selected})
      : super(key: key); // Use super() without arguments

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTableProvider);
    return Container(
      height: 45,
      width: 250,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8),
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selected.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Allow horizontal scrolling
                  child: Row(
                    children: selected!.map((cat) {
                      return Text(
                        '$cat, ',
                        overflow: TextOverflow.ellipsis,
                      );
                    }).toList(),
                  ),
                ),
              )
            else
              Expanded(
                child: Text(
                  text ?? 'Merge with',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Icon(
              // <-- Icon
              Icons.menu_open,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
