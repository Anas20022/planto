import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/screens/main_screen/archive_screen.dart';

import 'providers/bottom_nav_provider.dart';
import 'screens/main_screen/home_screen.dart';
import 'screens/main_screen/settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, child) {
          return IndexedStack(
            index: bottomNavProvider.selectedIndex,
            children: const [
              ArchiveScreen(),
              HomeScreen(),
              SettingsScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, child) {
          int currentIndex = bottomNavProvider.selectedIndex;

          return CurvedNavigationBar(

            backgroundColor: Colors.transparent,
            color: const Color(0xFF508776), // لون غامق أنيق
            buttonBackgroundColor: const Color(0xFF508776),
            height: 60,
            animationDuration: const Duration(milliseconds: 300),
            index: currentIndex,
            onTap: (index) => bottomNavProvider.changeIndex(index),
            items: [
              Icon(
                Icons.archive,
                size: currentIndex == 0 ? 30 : 25, // تكبير إذا مختار
                color: Colors.white,
              ),
              Icon(
                Icons.home,
                size: currentIndex == 1 ? 30 : 25,
                color: Colors.white,
              ),
              Icon(
                Icons.settings,
                size: currentIndex == 2 ? 30 : 25,
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}
