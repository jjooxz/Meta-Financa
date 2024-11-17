import 'package:flutter/material.dart';
import 'package:meta_financa/widgets/bottom_navigation_bar.dart';
import 'package:meta_financa/const.dart';
import 'package:meta_financa/widgets/categories.dart';
import 'package:meta_financa/widgets/history.dart';
import 'package:meta_financa/save_system.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isDarkMode = false;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = !_isDarkMode ? kTextColorLight : kTextColorDark;

    final saveSystem = SaveSystem();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meta Finança',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              transform: Matrix4.translationValues(0, 10, 0),
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Meta Finança',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: textColor,
                      ),
                      onPressed: _toggleTheme,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  Categories(saveSystem: saveSystem),
                  History(saveSystem: saveSystem),
                  const Center(child:Text("Alocações")),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: KBottomNavigationBar(
          currentIndex: _currentIndex,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
