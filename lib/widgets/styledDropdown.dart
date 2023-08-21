import 'package:flutter/material.dart';
import 'package:primos_app/providers/categoryFilter/fetchCategory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StyledDropdown<T> extends ConsumerWidget {
  final T? value;
  final void Function(T?) onChange; // Update the parameter type
  final String hintText;
  final List<String> items; // Pass in your static items here
  final double? width;
  final dynamic dropdownColor;
  final bool showFetchedCategories; // New parameter

  const StyledDropdown({
    Key? key,
    required this.value,
    required this.onChange,
    required this.hintText,
    required this.items,
    this.width,
    this.dropdownColor,
    this.showFetchedCategories = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(fetchCategoryProvider).when(
          data: (categories) {
            final uniqueCategories = categories.toSet().toList();
            final availableCategories =
                showFetchedCategories ? uniqueCategories : [];

            final allCategories = [
              ...availableCategories,
              ...items,
            ];

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
                items: allCategories.map((item) {
                  return DropdownMenuItem(
                    value: item as T,
                    child: Text(
                      item.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: onChange,
              ),
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) {
            print("Error fetching categories: $error");
            return Text("Error fetching categories");
          },
        );
  }
}
