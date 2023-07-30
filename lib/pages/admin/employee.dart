import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/employee_Form.dart';
import 'package:primos_app/widgets/employeeDisplay.dart';
import 'package:primos_app/widgets/pageObject.dart';
import 'package:primos_app/widgets/sideMenu.dart';

import 'package:primos_app/widgets/styledButton.dart';
import 'package:primos_app/widgets/bottomBar.dart';

class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f8f7),
      drawer: SideMenu(pages: adminPages),
      appBar: AppBar(
        title: const Text("EMPLOYEE"),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // TODO CREATE MAP OR LISTVIEW BUILDER FOR DYNAMIC EMPLOYEE DISPLAY
                EmployeeDisplay(
                  employeeName: "Jonathan H Moralde",
                  employeeRole: "Developer",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: StyledButton(
                    btnText: "NEW EMPLOYEE",
                    onClick: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return EmployeeForm();
                      }));
                    },
                    btnColor: const Color(0xFFf8f8f7),
                    // btnWidth: 250,
                    btnHeight: 45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
