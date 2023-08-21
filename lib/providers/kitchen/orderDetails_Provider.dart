import 'package:riverpod/riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:primos_app/providers/kitchen/models.dart';

// final ordersProvider = StreamProvider<Map<String, List<Order>>>((ref) {
//   DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');
//   return ordersRef.onValue.map((event) {
//     DataSnapshot snapshot = event.snapshot;

//     Map<dynamic, dynamic>? ordersMap = snapshot.value as Map<dynamic, dynamic>?;

//     if (ordersMap == null) {
//       return {};
//     }

//     Map<String, List<Order>> orders = {};

//     ordersMap.forEach((orderID, orderData) {
//       final orderDetails = orderData['order_details'] as List<dynamic>?;

//       if (orderDetails != null && orderDetails.isNotEmpty) {
//         List<Order> ordersList = orderDetails.map((orderDetail) {
//           final name = orderDetail['productName'] ?? 'No Name';
//           final quantity = orderDetail['quantity'] ?? 0;
//           final variation = orderDetail['variation'] ?? 'No Variation';

//           return Order(
//             name: name,
//             quantity: quantity,
//             variation: variation,
//           );
//         }).toList();

//         orders[orderID] = ordersList;
//       }
//     });

//     return orders;
//   });
// });

final ordersProvider = StreamProvider<Map<dynamic, dynamic>>((ref) {
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
