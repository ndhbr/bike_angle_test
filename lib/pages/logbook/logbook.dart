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
  final BikeAngle _bikeAngle = BikeAngle();

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
                return LogbookItem(_recordings[index]);
              },
              // Or, uncomment the following line:
              childCount: _recordings.length,
            ),
          ),
        ],
      ),
    );

    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(
              margin: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Test'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      return LogbookItem(_recordings[index]);
                    },
                    itemCount: _recordings.length,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);

    return RefreshIndicator(
      onRefresh: () async => await _getRecordings(),
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: 8.0,
          ),
          itemBuilder: (context, index) {
            return LogbookItem(_recordings[index]);
          },
          itemCount: _recordings.length,
        ),
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
}
