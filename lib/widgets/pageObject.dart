// It creates an instance of an object with name, and widget
// used for adding pages in sideMenu.dart
import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/adminMenu.dart';
import 'package:primos_app/pages/admin/salesReport.dart';
import 'package:primos_app/pages/admin/table.dart';

class SideMenuPage {
  final String name;
  final Widget page; //used for navigator

  SideMenuPage({required this.name, required this.page});
}

// TODO CREATE THE LIST OF PAGES BELOW
// * THESE LIST ARE TO BE PASSED AS PARAMETER IN SIDEMENU
// * IMPORTING pageObject.dart automatically gives access to it

// ADMIN PAGES

List<SideMenuPage> adminPages = [
  SideMenuPage(
    name: "Sales Report",
    page: SalesReportPage(),
  ),
  SideMenuPage(
    name: "Menu",
    page: AdminMenuPage(),
  ),
  SideMenuPage(
    name: "Table",
    page: TablePage(),
  ),
];

// END OF ADMIN PAGES
