import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/services/database/controller.dart';
import 'package:bikeangletest/pages/logbook/logbook_item.dart';
import 'package:bikeangle/models/recording.dart';
import 'package:bikeangletest/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogbookPage extends StatefulWidget {
  @override
  _LogbookPageState createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle(debug: true);

  /// Scroll controller
  final ScrollController _scrollController = ScrollController();

  /// Listed recordings
  List<Recording> _recordings;

  /// Scroll state
  bool _isLoading;
  bool _isEnd;

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
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          _buildHeaderBar(),
          _buildSliverList(),
        ],
      ),
    );
  }

  SliverList _buildSliverList() {
    return SliverList(
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
    );
  }

  /// Build sliver app bar
  SliverAppBar _buildHeaderBar() {
    return SliverAppBar(
      title: Text('Fahrtenbuch'),
      backgroundColor: Colors.blueAccent,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        background: SvgPicture.asset('assets/logbook.svg'),
      ),
    );
  }

  /// Initialize logbook page
  Future<void> _init() async {
    _recordings = [];
    _isLoading = false;
    _isEnd = false;

    // Register scroll listener
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              0.75 * _scrollController.position.maxScrollExtent &&
          _recordings.length > 0 &&
          !_isLoading &&
          !_isEnd) {
        await _getRecordings(
            startAfter: _recordings.last.startedRecordingTimestamp);
      }
    });

    // Load recordings from bike angle library
    await _getRecordings();
  }

  /// Load recordings from bike angle library
  Future<void> _getRecordings({int startAfter}) async {
    setState(() => _isLoading = true);

    if (_bikeAngle.initialized) {
      List<Recording> recordings =
          await _bikeAngle.getRecordings(startAfter: startAfter);

      if (recordings.length < LOGBOOK_PAGINATION_LIMIT) {
        _isEnd = true;
      } else {
        _isEnd = false;
      }

      if (startAfter != null) {
        _recordings.addAll(recordings);
      } else {
        _recordings = recordings;
      }
    }

    setState(() => _isLoading = false);
  }

  /// On delete callback
  Future<void> _onDelete(int recordingId) async {
    await _bikeAngle.removeRecording(recordingId);
    _recordings.removeWhere((recording) => recording.id == recordingId);

    if (mounted) {
      setState(() {});
      Navigator.of(context).pop();
    }
  }
}
