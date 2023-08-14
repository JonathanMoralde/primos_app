import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> sendPasswordResetLink(String email) async {
  FirebaseAuth.instance.sendPasswordResetEmail(email: email);

  print('Success');
}
