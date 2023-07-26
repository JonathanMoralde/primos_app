import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';

import 'package:primos_app/widgets/sideMenu.dart';

import 'package:primos_app/widgets/searchBar.dart';

import 'package:primos_app/widgets/styledButton.dart';

class AdminMenuPage extends StatelessWidget {
  const AdminMenuPage({super.key});

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
                    itemCount: adminPages.length, //temporary using adminPages
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: StyledButton(
                        btnText: adminPages[index]
                            .name, //temporarry using adminpages
                        onClick: adminPages[index].onTap,
                        btnWidth: 100,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
