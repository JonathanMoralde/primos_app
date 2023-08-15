import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/employee.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDropdown.dart';
import 'package:primos_app/widgets/styledTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeForm extends StatefulWidget {
  EmployeeForm({
    super.key,
  });

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f8f7),
      appBar: AppBar(
        leading: IconButton(
          //manual handle back button
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 35,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("NEW EMPLOYEE"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledTextField(
                  controller: fullNameController,
                  hintText: "Full Name",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              StyledTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              StyledTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(
                height: 10,
              ),
              StyledDropdown(
                value: role,
                onChange: (String? newValue) {
                  setState(() {
                    role = newValue;
                  });
                },
                hintText: "Role",
                items: const ['Admin', 'Waiter', 'Cashier', 'Kitchen'],
              ),
              const SizedBox(
                height: 20,
              ),
              StyledButton(
                btnText: "ADD",
                onClick: () async {
                  try {
                    if (passwordController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Password should be at least 6 characters."),
                        ),
                      );
                      return;
                    }
                    final authResult = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    await users.doc(authResult.user!.uid).set({
                      'fullName': fullNameController.text,
                      'role': role,
                      'email': emailController.text
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return EmployeePage(); //* Replace page depending on user type
                        },
                      ),
                    );
                  } catch (error) {
                    print('error detected: $error');
                  }
                },
                btnWidth: 250,
              )
            ],
          ),
        ),
      ),
    );
  }
}
