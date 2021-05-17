import 'package:bikeangletest/tab_navigation_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Current tab index
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bike Angle'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
            )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
    );
  }
}
