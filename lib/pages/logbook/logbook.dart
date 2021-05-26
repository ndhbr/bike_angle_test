import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangletest/pages/logbook/logbook_item.dart';
import 'package:bikeangle/models/recording.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogbookPage extends StatefulWidget {
  @override
  _LogbookPageState createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle(debug: true);

  /// Listed recordings
  List<Recording> _recordings;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _getRecordings(),
      displacement: 80.0,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Fahrtenbuch'),
            backgroundColor: Colors.blueAccent,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset('assets/logbook.svg'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return LogbookItem(
                  _recordings[index],
                  onDelete: _onDelete,
                  key: ValueKey(_recordings[index].id),
                );
              },
              // Or, uncomment the following line:
              childCount: _recordings.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    _recordings = [];

    await _getRecordings();
  }

  Future<void> _getRecordings() async {
    if (_bikeAngle.initialized) {
      _recordings = await _bikeAngle.getRecordings();
    }

    setState(() {});
  }

  Future<void> _onDelete(int recordingId) async {
    print('im here');
    await _bikeAngle.removeRecording(recordingId);
    _recordings.removeWhere((recording) => recording.id == recordingId);

    if (mounted) {
      setState(() {});
      Navigator.of(context).pop();
    }
  }
}
