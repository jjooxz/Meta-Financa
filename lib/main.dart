import 'package:flutter/material.dart';
import 'package:meta_financa/const.dart';
import 'package:meta_financa/widgets/home.dart';

Widget preview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Meta Finança',
    theme: lightTheme,
    darkTheme: darkTheme,
    home: const HomeScreen(),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meta Finança',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomeScreen(),
    );
  }
}