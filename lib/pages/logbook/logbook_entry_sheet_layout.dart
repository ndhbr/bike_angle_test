import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogbookEntrySheetLayout extends StatelessWidget {
  final AsyncCallback deleteEntry;

  LogbookEntrySheetLayout({this.deleteEntry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text('Aufzeichnung löschen'),
              onTap: () async {
                await _showDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show are you sure dialog
  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bist du dir sicher?'),
          content: Text('Willst du diese Aufzeichnung wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            OutlinedButton(
              child: Text('Ja, löschen'),
              onPressed: () {
                deleteEntry();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
