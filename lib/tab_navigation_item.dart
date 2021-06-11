import 'package:bikeangletest/pages/logbook/logbook.dart';
import 'package:bikeangletest/pages/recording.dart';
import 'package:flutter/material.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;
  final Icon activeIcon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
    @required this.activeIcon,
  });

  /// Main tabbar navigation items
  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: RecordingPage(),
          title: 'Aufzeichnen',
          icon: Icon(Icons.compass_calibration_outlined),
          activeIcon: Icon(Icons.compass_calibration),
        ),
        TabNavigationItem(
          page: LogbookPage(),
          title: 'Fahrtenbuch',
          icon: Icon(Icons.bookmark_border_outlined),
          activeIcon: Icon(Icons.bookmark),
        ),
      ];
}
