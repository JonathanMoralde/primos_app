import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final salesProvider = StreamProvider<Map<String, Map<String, dynamic>>>((ref) {
//   DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');
//   return ordersRef.onValue.map((event) {
//     DataSnapshot snapshot = event.snapshot;

//     Map<String, dynamic> ordersMap =
//         Map<String, dynamic>.from(snapshot.value ?? {});

//     // Group orders by date and calculate total amount and number of orders for each date
//     Map<String, Map<String, dynamic>> groupedOrders = {};
//     ordersMap.forEach((key, value) {
//       if (value is Map<String, dynamic> && value.containsKey('order_date')) {
//         String date = value['order_date']?.toString()?.substring(0, 10) ?? "";

//         // Initialize the data for this date if it doesn't exist
//         groupedOrders[date] ??= {
//           'total_amount': 0.0,
//           'number_of_orders': 0,
//         };

//         // Update the total amount and number of orders for this date
//         double totalAmount = groupedOrders[date]!['total_amount'] +
//             (value['total_amount'] ?? 0.0);
//         int numberOfOrders = groupedOrders[date]!['number_of_orders'] + 1;

//         groupedOrders[date]!['total_amount'] = totalAmount;
//         groupedOrders[date]!['number_of_orders'] = numberOfOrders;
//       }
//     });

//     return groupedOrders;
//   });
// });

final salesProvider = StreamProvider<Map<dynamic, dynamic>>((ref) {
  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');
  return ordersRef.onValue.map((event) {
    DataSnapshot snapshot = event.snapshot;

    Map<dynamic, dynamic>? ordersMap = snapshot.value as Map<dynamic, dynamic>?;

    if (ordersMap == null) {
      return {};
    }

    return ordersMap;
  });
});
