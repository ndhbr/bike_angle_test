import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/device_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  /// Bike Angle Library
  BikeAngle _bikeAngle;

  @override
  void initState() {
    _bikeAngle = BikeAngle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: StreamBuilder<DeviceRotation>(
          stream: _bikeAngle.listenToDeviceRotationEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error');
            }

            DeviceRotation deviceRotation = snapshot.data;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: RotationTransition(
                    turns:
                        new AlwaysStoppedAnimation(deviceRotation.pitch / 360),
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset('assets/motorcycle.svg'),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Rotation ${deviceRotation.pitch.toStringAsFixed(0)} °',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
