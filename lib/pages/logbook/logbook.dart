import 'package:bikeangletest/pages/logbook/logbook_item.dart';
import 'package:flutter/material.dart';

class Logbook extends StatefulWidget {
  @override
  _LogbookState createState() => _LogbookState();
}

class _LogbookState extends State<Logbook> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 8.0,
      ),
      itemBuilder: (context, index) {
        return LogbookItem();
      },
      itemCount: 50,
    );
  }
}
