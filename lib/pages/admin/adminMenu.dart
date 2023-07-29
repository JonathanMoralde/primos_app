import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/adminMenu_CatForm.dart';
import 'package:primos_app/pages/admin/adminMenu_Form.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/itemCard.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/btnObject.dart';

import 'package:primos_app/widgets/sideMenu.dart';

import 'package:primos_app/widgets/searchBar.dart';

import 'package:primos_app/widgets/styledButton.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  int _activeButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      drawer: SideMenu(pages: adminPages),
      appBar: AppBar(
        title: const Text("MENU"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomSearchBar(),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 45,
                  child: ListView.builder(
                      itemCount: category.length, //temporary using adminPages
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final bool isActive = index == _activeButtonIndex;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: StyledButton(
                            btnText: category[index].name, //temporary
                            onClick: () {
                              setState(() {
                                _activeButtonIndex = index;
                              });

                              category[index].onTap;
                            },
                            btnColor: isActive
                                ? const Color(0xFFFE3034)
                                : const Color(0xFFE2B563),
                          ),
                        );
                      }),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // TODO WRAP ITEMCARD WITH LISTVIEW BUILDER AND CREATE A DYNAMIC ITEMCARD
                      ItemCard(
                        productName: "Turingan",
                        productPrice: 69,
                      ),
                      ItemCard(
                        productName: "Sinapot",
                        productPrice: 69,
                      ),
                      ItemCard(
                        productName: "Turon",
                        productPrice: 69,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: StyledButton(
                  btnText: "New Item",
                  onClick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AdminMenuForm();
                      }),
                    );
                  },
                  btnColor: const Color(0xfff8f8f7),
                ),
              ),
              const SizedBox(
                width: 10, //gap between the two btns
              ),
              Expanded(
                flex: 1,
                child: StyledButton(
                  btnText: "New Category",
                  onClick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return AdminMenuCatForm();
                      }),
                    );
                  },
                  btnColor: const Color(0xfff8f8f7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
