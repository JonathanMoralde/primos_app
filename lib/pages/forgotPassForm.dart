import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'passwordResetFunction.dart';

class ForgotPassPage extends StatelessWidget {
  ForgotPassPage({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xfff8f8f7),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "PASSWORD RESET",
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 2),
            ),
            Text(
              "FORM",
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 2),
            ),
            const SizedBox(
              height: 40,
            ),
            StyledTextField(
                controller: emailController,
                hintText: "Enter Valid Email",
                obscureText: false),
            const SizedBox(
              height: 10,
            ),
            StyledButton(
              btnText: "CONFIRM",
              onClick: () async {
                final email = emailController.text;
                try {
                  await sendPasswordResetLink(email);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password Reset Link has been sent.')));
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error sending Password Reset Link.')));
                }
              },
              btnWidth: 250,
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                      ),
                      SizedBox(
                          width:
                              4), // Adding a small gap between the icon and text
                      Flexible(
                        child: Text(
                          "Please enter your valid email",
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "then a password reset link will be sent to your email.",
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
