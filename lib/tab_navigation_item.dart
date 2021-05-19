import 'package:bikeangletest/pages/logbook/logbook.dart';
import 'package:bikeangletest/pages/recording.dart';
import 'package:flutter/material.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: RecordingPage(),
          icon: Icon(Icons.compass_calibration_outlined),
          title: 'Aufzeichnen',
        ),
        TabNavigationItem(
          page: LogbookPage(),
          icon: Icon(Icons.bookmark_border_outlined),
          title: 'Fahrtenbuch',
        ),
      ];
}
