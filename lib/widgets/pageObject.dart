// It creates an instance of an object with name, and widget
// used for adding pages in sideMenu.dart
import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/adminMenu.dart';
import 'package:primos_app/pages/admin/employee.dart';
import 'package:primos_app/pages/admin/salesReport.dart';
import 'package:primos_app/pages/admin/table.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/pages/kitchen/kitchen.dart';

import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/pages/waiter/takeout.dart';

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
  SideMenuPage(
    name: "Employee",
    page: EmployeePage(),
  ),
];

// END OF ADMIN PAGES

// CASHIER PAGES
List<SideMenuPage> cashierPages = [
  SideMenuPage(
    name: "Orders",
    page: OrdersPage(),
  ),
];
// END OF CASHIER PAGES

// WAITER PAGES
List<SideMenuPage> waiterPages = [
  SideMenuPage(
    name: "Tables",
    page: WaiterTablePage(),
  ),
  SideMenuPage(
    name: "Takeout",
    page: TakeoutPage(),
  ),
];
// END OF WAITER PAGES

List<SideMenuPage> kitchenPages = [
  SideMenuPage(
    name: "Orders",
    page: KitchenPage(),
  ),
];
