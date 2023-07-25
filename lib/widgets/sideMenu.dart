//preconfigured with pageObject.dart
// TODO edit the header

import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/pages/loginScreen.dart';

class SideMenu extends StatelessWidget {
  final List<SideMenuPage> pages;

  const SideMenu({
    super.key,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>[
          // HEADER
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFE2B563),
            ),
            child: Text("Test"),
          ),

          // DYNAMIC PAGES
          ...pages.map((page) {
            return ListTile(
              title: Text(page.name),
              onTap: page.onTap,
              minLeadingWidth: 0,
            );
          }).toList(),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {
              Navigator.of(context).pushAndRemoveUntil(
                //clear the stack and push the login screen
                MaterialPageRoute(
                  builder: (context) => LoginSreen(),
                ),
                (_) => false,
              ),
            },
            minLeadingWidth: 0,
          ),
        ],
      ),
    );
  }
}
