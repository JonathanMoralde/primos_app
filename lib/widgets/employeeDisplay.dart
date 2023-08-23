import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDisplay extends StatelessWidget {
  final String employeeName;
  final String employeeEmail;
  final String employeeRole;
  final String userId;

  const EmployeeDisplay({
    Key? key,
    required this.employeeName,
    required this.employeeEmail,
    required this.employeeRole,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        color: const Color(0xFFE2B563),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employeeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: $employeeEmail',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Text(
                      'Role: $employeeRole',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  alignment: AlignmentDirectional(7, 0),
                  iconSize: 28,
                  onPressed: () async {
                    final isAuthorized =
                        await _showPasswordAuthenticationDialog(context);
                    if (isAuthorized) {
                      await _deleteEmployee(context);
                    } else {
                      // Handle unauthorized deletion attempt (show a message, etc.)
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showPasswordAuthenticationDialog(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return false;
    }

    final email = currentUser.email;

    final TextEditingController passwordController = TextEditingController();

    final password = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Your Password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(passwordController.text);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    if (password == null || password.isEmpty) {
      return false;
    }

    if (email == null) {
      return false;
    }

    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      await currentUser.reauthenticateWithCredential(credential);
      // Reauthentication successful
      return true;
    } catch (e) {
      // Reauthentication failed
      print("Reauthentication error: $e");
      return false;
    }
  }

  Future<void> _deleteEmployee(BuildContext context) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print('No user to be deleted');
        return;
      }

      if (currentUser.uid == userId) {
        print("Cannot delete the current user");
        return;
      }

      // Delete the Firestore document associated with the user
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userDocRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User deleted successfully."),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print("Error deleting user: $e");
      // Handle deletion error
    }
  }
}
