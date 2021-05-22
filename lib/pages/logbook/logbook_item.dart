import 'package:bikeangletest/pages/detail.dart';
import 'package:bikeangletest/pages/logbook/logbook_entry_sheet_layout.dart';
import 'package:flutter/material.dart';
import 'package:bikeangle/models/recording.dart';
import 'package:intl/intl.dart';

class LogbookItem extends StatefulWidget {
  final Recording recording;
  final VoidCallback onDelete;

  LogbookItem(this.recording, {this.onDelete});

  @override
  _LogbookItemState createState() => _LogbookItemState();
}

class _LogbookItemState extends State<LogbookItem> {
  /// Recording
  Recording _recording;

  /// On Delete Callback
  VoidCallback _onDelete;

  @override
  void initState() {
    _recording = widget.recording;
    _onDelete = widget.onDelete;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String subtitle = DateFormat("EEEE, dd.MM.yyy HH:mm", 'de_DE')
            .format(DateTime.fromMillisecondsSinceEpoch(
                _recording.startedRecordingTimestamp))
            .toString() +
        ' Uhr';

    return ListTile(
      leading: Icon(Icons.sports_motorsports_outlined, size: 32),
      trailing: Icon(Icons.chevron_right_outlined),
      title: Text(_recording.title),
      subtitle: Text(subtitle),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailPage(_recording)),
      ),
      onLongPress: () async => await _showOptionsSheet(),
    );
  }

  /// Show bottom sheet with logbook entry options
  Future<void> _showOptionsSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => LogbookEntrySheetLayout(
        deleteEntry: () async => (_onDelete != null) ? _onDelete() : null,
      ),
    );
  }
}
