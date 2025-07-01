import 'package:flutter/material.dart';
import 'package:matchupnews/views/bookmark_screen.dart';
import 'package:matchupnews/views/home_screen.dart';
import 'package:matchupnews/views/profile_screen.dart';
import 'package:matchupnews/views/utils/helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> body = const [HomeScreen(), BookmarkScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cBgDc,
        currentIndex: _currentIndex,
        selectedItemColor: cPrimary,
        unselectedItemColor: cWhite,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0 ? Icons.bookmark_outline : Icons.bookmark,
            ),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0 ? Icons.person_outline : Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}