import 'package:aspen_app/screens/create_post_screen.dart';
import 'package:aspen_app/screens/search_screen.dart';
import 'package:aspen_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_screen.dart';
import 'home_screen_feed.dart';
import 'message_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeFeedScreen(),
    SearchScreen(),
    MessageScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Aspen",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex >= 2
            ? _currentIndex + 1
            : _currentIndex,

        onTap: (index) async {

          if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreatePostScreen(),
              ),
            );

            return;
          }

          setState(() {
            if (index > 2) {
              _currentIndex = index - 1;
            } else {
              _currentIndex = index;
            }
          });
        },

        type: BottomNavigationBarType.fixed,

        backgroundColor: theme.cardColor,

        selectedItemColor: theme.primaryColor,

        unselectedItemColor:
        theme.textTheme.bodyMedium?.color?.withValues(
          alpha: 0.6,
        ),

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: "Post",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: "Messages",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }
}