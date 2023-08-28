//preconfigured with pageObject.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/session/user_provider.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/pages/loginScreen.dart';
import '../pages/login_services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends ConsumerWidget {
  final List<SideMenuPage> pages;

  const SideMenu({
    super.key,
    required this.pages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? userName = ref.watch(userNameProvider);
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>[
          // HEADER
          DrawerHeader(
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
                  Text(userName ?? "User"),
                ]),
          ),

          // DYNAMIC PAGES
          ...pages.map((page) {
            return ListTile(
              iconColor: Color(0xff252525),
              leading: page.icon,
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
            iconColor: Color(0xff252525),
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
