import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
      routes: {
        '/cart': (context) => const CartScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}