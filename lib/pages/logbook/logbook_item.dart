import 'package:flutter/material.dart';

class LogbookItem extends StatefulWidget {
  @override
  _LogbookItemState createState() => _LogbookItemState();
}

class _LogbookItemState extends State<LogbookItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.sports_motorsports_outlined, size: 32),
        trailing: Icon(Icons.arrow_right),
        title: Text('Fahrt'),
        subtitle: Text('Beschreibung'),
        onTap: () => print('Tapped'),
      ),
    );
  }
}
