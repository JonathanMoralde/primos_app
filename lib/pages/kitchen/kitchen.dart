import 'package:flutter/material.dart';
import 'package:primos_app/widgets/orderCard.dart';

// TODO GRAB ORDERS FROM DB AND DISPLAY DYNAMICALLY

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f7),
      appBar: AppBar(
        title: Text("ORDERS"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              //TODO ADD WIDGET THAT DISPLAYS DATA FROM DB ex. LISTVIEW.BUILDER, MAP
              children: [
                OrderCard()
              ], //TODO EDIT THE ORDERCARD() TO TAKE PARAMETERS FROM THE DATA FROM DB
            ),
          ),
        ),
      ),
    );
  }
}
