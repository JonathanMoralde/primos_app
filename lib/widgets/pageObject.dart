// It creates an instance of an object with name, and onTap function
// used for adding pages in sideMenu.dart

class SideMenuPage {
  final String name;
  final Function()? onTap;

  SideMenuPage({required this.name, required this.onTap});
}

// TODO CREATE THE LIST OF PAGES BELOW
// * THESE LIST ARE TO BE PASSED AS PARAMETER IN SIDEMENU
// * IMPORTING pageObject.dart automatically gives access to it

// ADMIN PAGES

List<SideMenuPage> adminPages = [
  SideMenuPage(
      name: "Sales Report",
      onTap: () {
        print("Sales");
      }),
  SideMenuPage(
      name: "Menu",
      onTap: () {
        print("Menu");
      }),
  SideMenuPage(
      name: "Table",
      onTap: () {
        print("Table");
      }),
  SideMenuPage(
      name: "Employee",
      onTap: () {
        print("Employee");
      }),
];

// END OF ADMIN PAGES
