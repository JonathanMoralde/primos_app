import 'package:riverpod/riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:primos_app/providers/kitchen/models.dart';

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
