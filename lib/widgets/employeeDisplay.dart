import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/employee_Form.dart';

class EmployeeDisplay extends StatelessWidget {
  final String employeeName;
  final String employeeRole;
  const EmployeeDisplay(
      {super.key, required this.employeeName, required this.employeeRole});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ],
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 2,
        //     blurRadius: 10,
        //     offset: const Offset(0, 3), // Changes the position of the shadow
        //   ),
        // ],
        color: const Color(0xFFE2B563),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      height: 70,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(10.0),
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
                        letterSpacing: 1),
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
                            return EmployeeForm(
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
                      print("Pressed del");
                    },
                    icon: const Icon(Icons.delete),
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
