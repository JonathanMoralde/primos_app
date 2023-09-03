import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primos_app/pages/kitchen/kitchen.dart';
import 'package:primos_app/pages/loginScreen.dart';
import 'package:primos_app/pages/waiter/tables.dart';
import 'package:primos_app/providers/session/userRole_provider.dart';
import 'package:primos_app/providers/session/user_provider.dart';
import '../pages/admin/salesReport.dart';
import '../pages/admin/table.dart';
import '../pages/cashier/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, String?>>(
      future: _checkLastVisitedPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final Map<String, String?>? userPrefs = snapshot.data;
        final String? lastVisitedPage = userPrefs?['lastVisitedPage'];
        final String? userName = userPrefs?['userName'];

        if (lastVisitedPage != null) {
          print(lastVisitedPage);
          print(userName);

          // Delay the provider state update after the build process
          Future.delayed(Duration.zero, () {
            ref.read(userNameProvider.notifier).state = userName;
            ref.read(userRoleProvider.notifier).state = lastVisitedPage;
          });

          return _buildLoggedInUI(lastVisitedPage);
        } else {
          print(lastVisitedPage);
          return LoginSreen();
        }
      },
    );
  }

  Future<Map<String, String?>> _checkLastVisitedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastVisitedPage = prefs.getString('lastVisitedPage');
    String? userName = prefs.getString('userName');

    return {'lastVisitedPage': lastVisitedPage, 'userName': userName};
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
