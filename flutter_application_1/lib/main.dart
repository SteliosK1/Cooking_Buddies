import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const CookingBuddiesApp());
}

class CookingBuddiesApp extends StatefulWidget {
  const CookingBuddiesApp({super.key});

  @override
  State<CookingBuddiesApp> createState() => _CookingBuddiesAppState();
}

class _CookingBuddiesAppState extends State<CookingBuddiesApp> {
  ThemeMode _themeMode = ThemeMode.system; // Default theme mode

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooking Buddies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black), // Μαύρο για light mode
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white), // Λευκό για dark mode
        ),
      ),
      themeMode: _themeMode, // Use the current theme mode
      home: HomePage(
        onThemeToggle: _toggleTheme, // Pass the toggle function to HomePage
      ),
    );
  }
}