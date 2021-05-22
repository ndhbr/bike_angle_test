import 'dart:async';

import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/models/device_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with TickerProviderStateMixin {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle(debug: true);
  StreamSubscription _rotationStream;
  DeviceRotation _deviceRotation;

  /// Rotation controller
  AnimationController _rotationController;

  @override
  void initState() {
    _init();
    // _bikeAngle.listenToDeviceRotationEvents().listen((event) {
    // print('New device rotation ${DateTime.fromMillisecondsSinceEpoch(event.capturedAt).toIso8601String()}');
    // });
    super.initState();
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aufzeichnen'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text('${_deviceRotation?.bikeAngle6?.toStringAsFixed(0) ?? 0} °'),
            _buildAngleVisualization(),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    Stream<DeviceRotation> stream = await _bikeAngle.getBikeAngle();
    _rotationStream = stream.listen((deviceRotation) {
      if (deviceRotation != null) {
        _deviceRotation = deviceRotation;

        if (mounted) {
          // if (!_rotationController.isAnimating)
          // _rotationController.animateTo(_deviceRotation.pitch.abs() / 90);
          _rotationController.value = (_deviceRotation.bikeAngle6.abs() / 90);
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
    _rotationController.dispose();
    await _bikeAngle.stopBikeAngleStream();

    if (_rotationStream != null) {
      await _rotationStream.cancel();
      _rotationStream = null;
    }
  }

  Widget _buildAngleVisualization() {
    double pitch = _deviceRotation?.bikeAngle6 ?? 0.0;

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
            _buildSlider(pitch),
            _buildSlider(pitch, isRight: true),
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

  Widget _buildSlider(double pitch, {bool isRight}) {
    // Positioned
    double left = 48.0;
    double right;

    // Slider
    double angleRange = 90;
    double trackGradientStartAngle = 260.0;
    double trackGradientEndAngle = 350.0;
    double startAngle = 260;
    bool counterClockwise = true;
    double initialValue = (pitch < 0) ? pitch.abs() : 0;

    if (isRight != null && isRight) {
      // Positioned
      left = null;
      right = 48.0;

      // Slider
      trackGradientStartAngle = 280.0;
      trackGradientEndAngle = 370.0;
      startAngle = 280;
      counterClockwise = false;
      initialValue = (pitch > 0) ? pitch : 0;
    }

    return Positioned(
      left: left,
      right: right,
      bottom: 0.0,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          customWidths: CustomSliderWidths(
            progressBarWidth: 24,
            handlerSize: 6,
            trackWidth: 24,
          ),
          customColors: CustomSliderColors(
            shadowMaxOpacity: 0.0,
            trackGradientStartAngle: trackGradientStartAngle,
            trackGradientEndAngle: trackGradientEndAngle,
            trackColors: [
              Colors.green,
              Colors.yellow,
              Colors.red,
            ],
            progressBarColor: Colors.black26,
          ),
          angleRange: angleRange,
          startAngle: startAngle,
          counterClockwise: counterClockwise,
        ),
        min: 0,
        max: 90,
        initialValue: initialValue,
        innerWidget: (_) => Container(),
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
          'Rotation ${_deviceRotation.bikeAngle6.abs().toStringAsFixed(0)} °',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildControls() {
    if (_bikeAngle.isRecording()) {
      return ElevatedButton.icon(
        onPressed: () => _bikeAngle.stopRecording(),
        icon: Icon(Icons.stop_outlined),
        label: Text('Stoppen'.toUpperCase()),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () => _bikeAngle.startRecording(),
        icon: Icon(Icons.play_arrow_outlined),
        label: Text('Aufzeichnung starten'.toUpperCase()),
      );
    }
  }
}
