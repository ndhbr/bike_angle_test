import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/device_rotation.dart';
import 'package:bikeangletest/clipper/half_clip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAngleVisualization(),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildAngleVisualization() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: ClipRRect(
              clipper: HalfClip(),
              child: SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(
                    progressBarWidth: 24,
                    handlerSize: 12,
                    trackWidth: 24,
                  ),
                  angleRange: 80,
                  startAngle: 260,
                  counterClockwise: true,
                ),
                min: 0,
                max: 80,
                initialValue: 0,
                innerWidget: (_) => Container(),
              ),
            ),
          ),
          Flexible(flex: 3, child: _buildAnimatingBike()),
          Flexible(
            flex: 3,
            child: SleekCircularSlider(
              appearance: CircularSliderAppearance(
                customWidths: CustomSliderWidths(
                  progressBarWidth: 24,
                  handlerSize: 12,
                  trackWidth: 24,
                ),
                angleRange: 80,
                startAngle: 280,
              ),
              min: 0,
              max: 80,
              initialValue: 0,
              innerWidget: (_) => Container(),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<DeviceRotation> _buildAnimatingBike() {
    return StreamBuilder<DeviceRotation>(
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
              height: MediaQuery.of(context).size.height * 0.1,
              child: RotationTransition(
                turns: new AlwaysStoppedAnimation(deviceRotation.pitch / 360),
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
    );
  }

  Row _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Aufzeichnung starten'),
        ),
      ],
    );
  }
}
