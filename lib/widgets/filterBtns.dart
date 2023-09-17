import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/categoryFilter/fetchCategory_provider.dart';
import 'package:primos_app/providers/categoryFilter/activeCategory_provider.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterBtns extends ConsumerWidget {
  const FilterBtns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _activeCategory = ref.watch(activeCategoryProvider);
    final AsyncValue<List<String>> categoriesState =
        ref.watch(fetchCategoryProvider);

    return categoriesState.when(
      data: (category) {
        category.sort();
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              itemCount: category.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final bool isActive = _activeCategory == category[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: StyledButton(
                    btnText: category[index],
                    onClick: () {
                      ref.read(activeCategoryProvider.notifier).state =
                          category[index];
                    },
                    btnColor: isActive
                        ? const Color(0xFFFE3034)
                        : const Color(0xFFE2B563),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(
        color: const Color(0xFFE2B563),
      ), // Show a loading indicator while fetching data
      error: (error, stackTrace) {
        print("Error fetching categories: $error");
        return const Text("Error fetching categories"); // Show an error message
      },
    );
  }
}
