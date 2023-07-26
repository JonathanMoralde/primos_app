import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  // This controller will store the value of the search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    setState(() {}); // To update the widget when the text changes
  }

  @override
  Widget build(BuildContext context) {
    bool isTextEmpty = _searchController.text.isEmpty;

    return Container(
      // height: 55,
      // width: 328,
      // Add padding around the search bar
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      // Use a Material design search bar
      child: TextField(
        controller: _searchController,
        cursorColor: const Color(0xFF252525),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
              bottom: 16, left: 10, right: 10), //* This centers the input
          hintText: 'Search',
          // Show the clear icon only when there is text in the search bar
          suffixIcon: isTextEmpty
              ? null
              : IconButton(
                  color: const Color(0xFF252525),
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
          // Add a search icon or button to the search bar
          prefixIcon: IconButton(
            color: const Color(0xFF252525),
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO PERFORM SEARCH HERE
            },
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
