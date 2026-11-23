import 'package:flutter/material.dart';
import 'screens/login_page.dart';
// Supprime les imports suivants si ces fichiers n'existent pas encore.
// ignore: unused_import
import 'screens/register_page.dart';
// ignore: unused_import
import 'screens/home_page.dart';
// ignore: unused_import
import 'screens/profile_page.dart';
// ignore: unused_import
import 'screens/courses_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Colors.indigo; // étape 17 : essayer Colors.green

    return MaterialApp(
      title: 'EMSI Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        appBarTheme: const AppBarTheme(centerTitle: true),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginPage(), // ou RegisterPage() pour tester l'inscription
    );
  }
}