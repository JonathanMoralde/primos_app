import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BtnObject {
  final String name;
  final void Function(String category) onTap;

  BtnObject({required this.name, required this.onTap});
}

class FilterBtns extends StatefulWidget {
  const FilterBtns({Key? key}) : super(key: key);

  @override
  State<FilterBtns> createState() => _FilterBtnsState();
}

class _FilterBtnsState extends State<FilterBtns> {
  String _activeCategory = "ll"; // Default active category
  List<BtnObject> category = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final categoriesCollection =
        FirebaseFirestore.instance.collection('categories');
    final QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
        await categoriesCollection.get();

    final List<BtnObject> fetchedCategories = [];
    fetchedCategories.add(
      BtnObject(
        name: "All",
        onTap: (selectedCategory) {
          setState(() {
            _activeCategory = selectedCategory;
          });
          print("Selected category: $_activeCategory");
          // You can perform other actions based on the selected category.
        },
      ),
    );

    // Iterate through fetched documents and add to the category list
    categoriesSnapshot.docs.forEach((categoryDoc) {
      final categoryName = categoryDoc.data()['categoryName'] as String;
      fetchedCategories.add(
        BtnObject(
          name: categoryName,
          onTap: (selectedCategory) {
            setState(() {
              _activeCategory = selectedCategory;
            });
            print("Selected category: $_activeCategory");
            // You can perform other actions based on the selected category.
          },
        ),
      );
    });

    setState(() {
      category = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          itemCount: category.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final bool isActive = _activeCategory == category[index].name;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {
                  category[index].onTap(category[index].name);
                },
                child: Text(category[index].name),
                style: ElevatedButton.styleFrom(
                  primary: isActive
                      ? const Color(0xFFFE3034)
                      : const Color(0xFFE2B563),
                  textStyle: TextStyle(
                    color: isActive ? Colors.black : Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
