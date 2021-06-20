import 'package:bikeangle/bikeangle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecordingControls extends StatefulWidget {
  @override
  _RecordingControlsState createState() => _RecordingControlsState();
}

class _RecordingControlsState extends State<RecordingControls> {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle(debug: kDebugMode);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => ScaleTransition(
        child: child,
        scale: animation,
      ),
      child: _getControls(),
    );
  }

  /// Get start/stop recording button
  Widget _getControls() {
    if (_bikeAngle.isRecording()) {
      return ElevatedButton.icon(
        onPressed: () async {
          await _bikeAngle.stopRecording();
          setState(() {});
        },
        icon: Icon(Icons.stop_outlined),
        label: Text(
          'Stoppen'.toUpperCase(),
        ),
        key: ValueKey(1),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () async {
          await _bikeAngle.startRecording();
          setState(() {});
        },
        icon: Icon(Icons.play_arrow_outlined),
        label: Text(
          'Aufzeichnung starten'.toUpperCase(),
        ),
        key: ValueKey(2),
      );
    }
  }
}
