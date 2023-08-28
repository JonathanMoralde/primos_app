import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/categoryFilter/fetchCategory_provider.dart';
import 'package:primos_app/widgets/styledButton.dart';

class Categories extends ConsumerWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(fetchCategoriesOnlyProvider);

    Future<void> delModal(String docId, String name) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      name,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Are you sure you want to delete this category?"),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                            ),
                            SizedBox(
                                width:
                                    4), // Adding a small gap between the icon and text
                            Flexible(
                              child: Text(
                                "Confirming this action cannot be undone",
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Cancel",
                                  onClick: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: StyledButton(
                                  btnText: "Confirm",
                                  onClick: () async {
                                    final catDocRef = FirebaseFirestore.instance
                                        .collection('categories')
                                        .doc(docId);
                                    await catDocRef.delete();

                                    // Trigger a refresh after category deletion
                                    ref.refresh(fetchCategoriesOnlyProvider);
                                    ref.refresh(fetchCategoryProvider);

                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("DELETE CATEGORIES"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: categoriesState.when(
              data: (category) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      for (final c in category)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                delModal(c['documentId']!, c['categoryName']!);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE2B563),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        c['categoryName']!,
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Icon(Icons.delete)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) {
                print("Error fetching categories: $error");
                return const Text(
                    "Error fetching categories"); // Show an error message
              },
              loading: () => const CircularProgressIndicator()),
        ),
      ),
    );
  }
}
