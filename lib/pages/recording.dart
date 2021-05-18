import 'dart:async';
import 'dart:math';

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

class _RecordingState extends State<Recording> with TickerProviderStateMixin {
  /// Bike Angle Library
  BikeAngle _bikeAngle;
  StreamSubscription _rotationStream;
  DeviceRotation _deviceRotation;

  /// Rotation controller
  AnimationController _rotationController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
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

  Future<void> _init() async {
    _bikeAngle = BikeAngle();

    Stream<DeviceRotation> stream = await _bikeAngle.startAngleRecording();
    _rotationStream = stream.listen((deviceRotation) {
      if (deviceRotation != null) {
        _deviceRotation = deviceRotation;

        if (mounted) {
          _rotationController.animateTo(_deviceRotation.pitch.abs() / 90);
        }

        setState(() {});
      }
    });

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  Future<void> _reset() async {
    await _bikeAngle.stopAngleRecording();

    if (_rotationStream != null) {
      await _rotationStream.cancel();
      _rotationStream = null;
    }
  }

  Widget _buildAngleVisualization() {
    double pitch = _deviceRotation?.pitch ?? 0.0;

    if (pitch > 80) {
      pitch = 80;
    } else if (pitch < -80) {
      pitch = -80;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 48.0,
              bottom: 0.0,
              child: ClipRect(
                clipper: HalfClip(),
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(
                      progressBarWidth: 24,
                      handlerSize: 6,
                      trackWidth: 24,
                    ),
                    customColors: CustomSliderColors(
                      shadowMaxOpacity: 0.0,
                      trackGradientStartAngle: 260,
                      trackGradientEndAngle: 340,
                      trackColors: [
                        Colors.green,
                        Colors.yellow,
                        Colors.red,
                      ],
                      progressBarColor: Colors.black26,
                    ),
                    angleRange: 80,
                    startAngle: 260,
                    counterClockwise: true,
                  ),
                  min: 0,
                  max: 80,
                  initialValue: (pitch < 0) ? pitch.abs() : 0,
                  innerWidget: (_) => Container(),
                ),
              ),
            ),
            Positioned(
              right: 48.0,
              bottom: 0.0,
              child: ClipRect(
                clipper: HalfClip(left: true),
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(
                      progressBarWidth: 24,
                      handlerSize: 6,
                      trackWidth: 24,
                    ),
                    customColors: CustomSliderColors(
                      shadowMaxOpacity: 0.0,
                      trackGradientStartAngle: 280,
                      trackGradientEndAngle: 370,
                      trackColors: [
                        Colors.green,
                        Colors.yellow,
                        Colors.red,
                      ],
                      progressBarColor: Colors.black26,
                    ),
                    angleRange: 80,
                    startAngle: 280,
                  ),
                  min: 0,
                  max: 80,
                  initialValue: (pitch > 0) ? pitch : 0,
                  innerWidget: (_) => Container(),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 128,
                child: _buildAnimatingBike(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatingBike() {
    if (_deviceRotation == null) {
      return Text('Gyroscope nicht verfügbar');
    }

    // _deviceRotation.pitch / 360

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: (_deviceRotation.pitch.sign == -1)
                    ? -_rotationController.value
                    : _rotationController.value,
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset('assets/motorcycle.svg'),
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          'Rotation ${_deviceRotation.pitch.abs().toStringAsFixed(0)} °',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
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
