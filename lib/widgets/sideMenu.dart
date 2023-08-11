//preconfigured with pageObject.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/pages/loginScreen.dart';
import '../pages/login_services.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 85,
                  ),
                  Text("Jonathan Moralde"),
                ]),
          ),

          // DYNAMIC PAGES
          ...pages.map((page) {
            return ListTile(
              title: Text(page.name),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => page.page,
                ));
              },
              minLeadingWidth: 0,
            );
          }).toList(),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: (() async {
              try {
                await Auth().signOut();

                // store role in sharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('lastVisitedPage', "LoginScreen");

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginSreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } catch (error) {
                print('error');
              }
            }),
            minLeadingWidth: 0,
          ),
        ],
      ),
    );
  }
}
