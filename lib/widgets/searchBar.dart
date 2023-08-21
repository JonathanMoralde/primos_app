import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/searchBar/searchQuery_provider.dart';

class CustomSearchBar extends ConsumerWidget {
  CustomSearchBar({Key? key}) : super(key: key);

  // This controller will store the value of the search bar
  // final TextEditingController _searchController = TextEditingController();
  final searchController = TextEditingController();

  // @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);

    return Container(
      // height: 55,
      // width: 328,
      // Add padding around the search bar
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      // Use a Material design search bar
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        // controller: searchController,
        cursorColor: const Color(0xFF252525),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
              bottom: 16, left: 10, right: 10), //* This centers the input
          hintText: 'Search',
          // Show the clear icon only when there is text in the search bar
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  color: const Color(0xFF252525),
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                    searchController.clear();
                  },
                )
              : null,
          // Add a search icon or button to the search bar
          prefixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Color(0xFF252525),
            ),
          ),
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
