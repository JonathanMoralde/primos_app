import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// final userProvider = StateProvider<User?>((ref) => null);

final userNameProvider = StateProvider<String?>((ref) => null);

// final usersProvider = FutureProvider<List<DocumentSnapshot>>((ref) async {
//   final userCollection = FirebaseFirestore.instance.collection('users');
//   final querySnapshot = await userCollection.get();
//   return querySnapshot.docs;
// });
