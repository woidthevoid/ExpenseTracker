import 'package:expense_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'components/HomePage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String AppTitle = "My Expenses";
    return MaterialApp(
        title: AppTitle,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyHomePage(),
    );
  }
}
