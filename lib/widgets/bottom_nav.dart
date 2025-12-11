// lib/navigation/bottom_nav_screen.dart

import 'package:flutter/material.dart';
import 'package:puzzle_app/screens/home/multi_leaderboard.dart';
import 'package:puzzle_app/screens/setting.dart';
import '../widgets/glass_bottom_nav.dart';
import '../screens/home/home.dart';
import '../screens/leaderboard.dart';
import '../screens/profile.dart';

class BottomNavScreen extends StatefulWidget {
  final int selected;

  const BottomNavScreen({super.key, this.selected = 0});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selected;
  }

  final List<Widget> pages = const [
    HomeScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: GlassBottomNav(
        selectedIndex: currentIndex,
        onItemTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}
