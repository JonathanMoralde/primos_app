import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:primos_app/pages/forgotPassForm.dart';
import 'package:primos_app/pages/kitchen/kitchen.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/providers/loading/isLoading_provider.dart';
import 'package:primos_app/providers/session/userRole_provider.dart';

// widgets
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'login_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// // test page
// import 'package:primos_app/pages/test.dart';
// waiter page
import 'package:primos_app/pages/admin/table.dart';
// cashier page
import 'package:primos_app/pages/cashier/orders.dart';
// admin pages
import 'package:primos_app/pages/admin/salesReport.dart';

// kitchen page
import 'package:primos_app/pages/kitchen/kitchen.dart';
// provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/providers/session/user_provider.dart';

// sharedpreference
import 'package:shared_preferences/shared_preferences.dart';

class LoginSreen extends ConsumerWidget {
  LoginSreen({super.key});
  final User? user = Auth().currentUser;

  final emailController =
      TextEditingController(); //* to access the input value for auth, usernameController.text
  final passwordController =
      TextEditingController(); //* passwordController.text

  final String btnText = "SIGN IN";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    void handleSignin() {
      final String email = emailController.text.trim();
      final String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter both email and password")),
        );
        return;
      }
      ref.read(isLoadingProvider.notifier).state = true;

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
          String fullName = userSnapshot['fullName'];
          ref.read(userNameProvider.notifier).state = fullName;
          ref.read(userRoleProvider.notifier).state = role;

          // store role in sharedPreferences
          // Store role in SharedPreferences with a user-specific key
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('lastVisitedPage', role);
          prefs.setString('userName', fullName);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                switch (role) {
                  case 'Admin':
                    return SalesReportPage();
                  case 'Waiter':
                    return WaiterTablePage(); // Replace with your waiter page
                  case 'Cashier':
                    return OrdersPage();
                  case 'Kitchen':
                    return KitchenPage();
                  default:
                    return LoginSreen(); // Default page for unknown roles
                }
              },
            ),
          );
        }
      }).whenComplete(() {
        ref.read(isLoadingProvider.notifier).state = false;
      }).catchError((error) {
        print(error);
        ref.read(isLoadingProvider.notifier).state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Incorrect Email or Password")),
        );
      });
    }

    return Scaffold(
      // backgroundColor: const Color(0xFFF8F8F7),
      // backgroundColor: Colors.transparent,
      body:
          // isLoading
          //     ? Center(
          //         child: CircularProgressIndicator(color: Color(0xFFE2B563)),
          //       ).animate().fade()
          //     :
          Stack(
        children: [
          Opacity(
            opacity: 0.4, // Adjust the opacity as needed
            child: Image.asset(
              'lib/images/bg1.jpg', // Replace with your image path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.5],
                colors: [
                  const Color(0xFFE2B563).withOpacity(0.3),
                  Color.fromARGB(224, 248, 248, 247)
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Spread of the shadow
                            spreadRadius: -8,
                            offset: Offset(0, 0), // Offset in x and y direction
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'lib/images/PrimosLogo.png',
                      ),
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
                      "PRIMO'S BISTRO POS!",
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
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return ForgotPassPage();
                          }),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating loading indicator
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE2B563),
              ),
            )
        ],
      ),
    );
  }
}
