import 'package:flutter/material.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';
import 'package:primos_app/widgets/filterBtns.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';

class TestPage extends StatelessWidget {
  TestPage({super.key});

  final testTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(title: Text('HELLO')),
          drawer: SideMenu(pages: adminPages),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  child: Column(
                children: [
                  FilterBtns(),
                  StyledButton(
                    btnText: 'ETITS',
                    onClick: () {},
                    btnIcon: Icon(Icons.home),
                    btnColor: Color.fromARGB(255, 224, 199, 58),
                  ),
                ],
              )),
            ),
          )),
    );
  }
}
