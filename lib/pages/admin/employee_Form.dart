import 'package:flutter/material.dart';
import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/styledDropdown.dart';
import 'package:primos_app/widgets/styledTextField.dart';

class EmployeeForm extends StatefulWidget {
  final String? fullName;

  EmployeeForm({
    super.key,
    this.fullName,
  });

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final fullNameController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  String? role;

  @override
  void initState() {
    super.initState();
    // Set the initial values for the text fields
    fullNameController.text =
        widget.fullName ?? ''; // If fullName is null, set an empty string
  }

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
        title: widget.fullName != null
            ? const Text("EDIT EMPLOYEE")
            : const Text("NEW EMPLOYEE"),
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
                  controller: usernameController,
                  hintText: "Username",
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
              ),
              const SizedBox(
                height: 20,
              ),
              StyledButton(
                btnText: widget.fullName != null ? "SAVE" : "ADD",
                onClick: () {},
                btnWidth: 250,
              )
            ],
          ),
        ),
      ),
    );
  }
}
