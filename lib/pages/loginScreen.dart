import 'package:flutter/material.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/pages/test.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_services.dart';

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
      final String email =
          emailController.text.trim(); // Remove leading/trailing whitespace
      final String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        // Show an error message to the user if email or password is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter both email and password")),
        );
        return; // Don't proceed with sign-in if inputs are empty
      }
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        Navigator.of(context).pushReplacement(
          //pushReplacement prevents user to go back to login screen

          MaterialPageRoute(
            builder: (BuildContext context) {
              return SalesReportPage(); //* Replace page depending on user type
            },
          ),
        );
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
