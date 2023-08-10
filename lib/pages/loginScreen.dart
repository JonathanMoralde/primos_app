import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/table.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/pages/cashier/orders_view.dart';
import 'package:primos_app/pages/test.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// admin pages
import 'package:primos_app/pages/admin/salesReport.dart';

class LoginSreen extends StatelessWidget {
  LoginSreen({super.key});
  final User? user = Auth().currentUser;

  final emailController =
      TextEditingController(); //* to access the input value for auth, usernameController.text
  final passwordController =
      TextEditingController(); //* passwordController.text

  final String btnText = "SIGN IN";

  @override
  Widget build(BuildContext context) {
    void handleSignin() {
      final String email = emailController.text.trim();
      final String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter both email and password")),
        );
        return;
      }

      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final User? user = Auth().currentUser;

        if (user != null) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          String role =
              userSnapshot['role']; // Assuming 'role' is a field in Firestore

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                switch (role) {
                  case 'Admin':
                    return SalesReportPage();
                  case 'Waiter':
                    return TablePage(); // Replace with your waiter page
                  case 'Cashier':
                    return OrderViewPage();
                  case 'Kitchen':
                    return TestPage();
                  default:
                    return LoginSreen(); // Default page for unknown roles
                }
              },
            ),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.1, 0.6],
            colors: [
              const Color(0xFFE2B563).withOpacity(0.3),
              const Color(0xFFF8F8F7)
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                // const SizedBox(
                //   height: 65,
                // ),
                Image.asset(
                  'lib/images/PrimosLogo.png',
                ),
                // TITLE
                const SizedBox(
                  height: 35,
                ),

                Text(
                  "WELCOME TO",
                  style: Theme.of(context).textTheme.titleLarge?.merge(
                        const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  // TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "PRIMO'S BISTRO POS",
                  style: Theme.of(context).textTheme.titleLarge?.merge(
                        const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  // TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
                // Username textfield
                ,
                const SizedBox(
                  height: 35,
                ),
                StyledTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                // Password textfield
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true),
                const SizedBox(
                  height: 20,
                ),

                // Sign in button
                StyledButton(
                  btnText: btnText,
                  onClick: handleSignin,
                  btnIcon: const Icon(Icons.login),
                  btnWidth: 250,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
