import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
