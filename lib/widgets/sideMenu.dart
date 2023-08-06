//preconfigured with pageObject.dart
import 'package:firebase_auth/firebase_auth.dart';
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
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                } catch (error) {
                  print('Error during logout: $error');
                  // Handle error if needed
                }
              },
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
