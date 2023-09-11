// It creates an instance of an object with name, and widget
// used for adding pages in sideMenu.dart
import 'package:flutter/material.dart';
import 'package:primos_app/pages/admin/adminMenu.dart';
import 'package:primos_app/pages/admin/employee.dart';
import 'package:primos_app/pages/admin/salesReport.dart';
import 'package:primos_app/pages/admin/table.dart';
import 'package:primos_app/pages/cashier/orders.dart';
import 'package:primos_app/pages/cashier/vatForm.dart';
import 'package:primos_app/pages/kitchen/kitchen.dart';

import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/pages/waiter/takeout.dart';

class SideMenuPage {
  final String name;
  final Widget page; //used for navigator
  final Widget? icon;

  SideMenuPage({required this.name, required this.page, this.icon});
}

// TODO CREATE THE LIST OF PAGES BELOW
// * THESE LIST ARE TO BE PASSED AS PARAMETER IN SIDEMENU
// * IMPORTING pageObject.dart automatically gives access to it

// ADMIN PAGES

List<SideMenuPage> adminPages = [
  SideMenuPage(
      name: "Sales Report",
      page: SalesReportPage(),
      icon: Icon(Icons.analytics_rounded)),
  SideMenuPage(
      name: "Menu",
      page: AdminMenuPage(),
      icon: Icon(Icons.restaurant_menu_rounded)),
  SideMenuPage(
    name: "Table",
    page: TablePage(),
    icon: Icon(Icons.table_bar),
  ),
  SideMenuPage(
      name: "Employee",
      page: EmployeePage(),
      icon: Icon(Icons.account_circle_rounded)),
  SideMenuPage(
    name: "Change VAT %",
    page: VatForm(),
    icon: Icon(Icons.edit),
  ),
];

// END OF ADMIN PAGES

// CASHIER PAGES
List<SideMenuPage> cashierPages = [
  SideMenuPage(
    name: "Orders",
    page: OrdersPage(),
    icon: Icon(Icons.fastfood),
  ),
];
// END OF CASHIER PAGES

// WAITER PAGES
List<SideMenuPage> waiterPages = [
  SideMenuPage(
    name: "Tables",
    page: WaiterTablePage(),
    icon: Icon(Icons.table_bar),
  ),
  SideMenuPage(
    name: "Takeout",
    page: TakeoutPage(),
    icon: Icon(Icons.takeout_dining),
  ),
];
// END OF WAITER PAGES

List<SideMenuPage> kitchenPages = [
  SideMenuPage(
    name: "Orders",
    page: KitchenPage(),
    icon: Icon(Icons.fastfood),
  ),
];
