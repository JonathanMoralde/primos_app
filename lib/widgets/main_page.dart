import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:primos_app/pages/kitchen/kitchen.dart';
import 'package:primos_app/pages/loginScreen.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import '../pages/admin/salesReport.dart';
import '../pages/admin/table.dart';
import '../pages/cashier/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     }

    //     if (snapshot.hasData) {
    return FutureBuilder<String?>(
      future: _checkLastVisitedPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        String? lastVisitedPage = snapshot.data;

        if (lastVisitedPage != null) {
          print(lastVisitedPage);
          return _buildLoggedInUI(lastVisitedPage);
        } else {
          print(lastVisitedPage);
          return LoginSreen();
        }
      },
    );
    // } else {
    //   return LoginSreen();
    // }
    // },
    // );
  }

  Future<String?> _checkLastVisitedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastVisitedPage');
  }

  Widget _buildLoggedInUI(String lastVisitedPage) {
    switch (lastVisitedPage) {
      case 'Admin':
        return SalesReportPage();
      case 'Waiter':
        return WaiterTablePage();
      case 'Cashier':
        return OrdersPage();
      case 'Kitchen':
        return KitchenPage();
      default:
        return LoginSreen(); // Default page for unknown roles
    }
  }
}
