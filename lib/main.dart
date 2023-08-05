import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:primos_app/pages/loginScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Primo's Bistro POS",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: const TextStyle(
              fontSize: 20, letterSpacing: 1, fontWeight: FontWeight.w500),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: Color(0xFF252525),
          ), //w500 is medium
          color: Color(0xFFF8F8F7),
          iconTheme: IconThemeData(color: Color(0xFF252525)),
          elevation: 0,
        ),
      ),
      home: LoginSreen(),
    );
  }
}


// PROVIDER