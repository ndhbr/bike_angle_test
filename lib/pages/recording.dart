import 'dart:async';
import 'dart:math';

import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/models/device_rotation.dart';
import 'package:flutter/material.dart';
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

  // Artboard _riveArtboard;
  // RiveAnimationController _controller;
  // RiveAnimationController _leftController;

  @override
  void initState() {
    _init();
    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    // rootBundle.load('assets/bike.riv').then(
    //   (data) async {
    //     // Load the RiveFile from the binary data.
    //     final file = RiveFile.import(data);
    //     // The artboard is the root of the animation and gets drawn in the
    //     // Rive widget.
    //     final artboard = file.mainArtboard;
    //     // Add a controller to play back a known animation on the main/default
    //     // artboard.We store a reference to it so we can toggle playback.
    //     artboard.addController(_controller = SimpleAnimation('Idle'));
    //     setState(() => _riveArtboard = artboard);
    //   },
    // );

    // Rotation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _deviceRotation?.bikeAngleRad ?? 0.0,
                      child: Text(
                        '${((_deviceRotation?.bikeAngle ?? 0.0).abs()).toStringAsFixed(0)} °',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                // _buildAngleVisualization(),
                _buildControls(),
              ],
            ),
          ),
        ));
  }

  Future<void> _init() async {
    Stream<DeviceRotation> stream = await _bikeAngle.getBikeAngle();
    _rotationStream = stream.listen((deviceRotation) {
      if (deviceRotation != null) {
        _deviceRotation = deviceRotation;

        if (mounted) {
          setState(() {});
        }
      }
    });

    // _rotationController = AnimationController(
    //   duration: const Duration(milliseconds: 100),
    //   vsync: this,
    // );
  }

  Future<void> _reset() async {
    // _rotationController.dispose();
    await _bikeAngle.stopBikeAngleStream();

    if (_rotationStream != null) {
      await _rotationStream.cancel();
      _rotationStream = null;
    }
  }

  Widget _buildAngleVisualization() {
    double pitch = _deviceRotation?.bikeAngle ?? 0.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 164,
        child: Stack(
          children: [
            _buildSlider(-pitch),
            _buildSlider(-pitch, isRight: true),
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
