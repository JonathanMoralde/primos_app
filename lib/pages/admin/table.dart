import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/tableDisplay.dart';
import 'package:primos_app/widgets/bottomBar.dart';
import 'package:primos_app/widgets/styledButton.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f7f7),
      drawer: SideMenu(pages: adminPages),
      appBar: AppBar(
        title: const Text("TABLE"),
      ),
      body: const SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              TableDisplay(),
              TableDisplay(),
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
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFf8f8f7),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: 45,
                width: 175,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle),
                        iconSize: 30,
                      ),
                      Text("1"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle),
                        iconSize: 30,
                      )
                    ]),
              ),
              StyledButton(
                btnText: "ADD",
                onClick: () {},
                btnColor: Color(0xFFf8f8f7),
                btnWidth: 175,
              )
            ],
          ),
        ),
      ),
    );
  }
}
