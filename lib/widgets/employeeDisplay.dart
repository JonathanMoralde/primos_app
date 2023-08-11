import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/employee_Form.dart';
import 'package:primos_app/pages/admin/employee_Form_Edit.dart';

class EmployeeDisplay extends StatelessWidget {
  final String employeeName;
  final String employeeRole;

  const EmployeeDisplay({
    Key? key,
    required this.employeeName,
    required this.employeeRole,
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
      height: 70,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text(
                    employeeRole,
                    style: const TextStyle(fontSize: 12),
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
                    alignment: const AlignmentDirectional(7, 0),
                    iconSize: 28,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EmployeeFormEdit(
                              fullName: employeeName,
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.create),
                  ),
                  IconButton(
                    alignment: const AlignmentDirectional(7, 0),
                    iconSize: 28,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this employee?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled deletion
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion, proceed to delete
    if (confirmed == true) {
      // _deleteEmployee();
    }
  }
}
  // Function to delete the employee from Firebase Firestore and Authentication
//   Future<void> _deleteEmployee() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Delete user from Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .delete();
//         // Delete user from authentication
//         await user.delete();
//       }
//     } catch (error) {
//       print('Error during deletion: $error');
//     }
//   }
// }