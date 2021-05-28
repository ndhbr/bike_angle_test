import 'dart:async';

import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/models/device_rotation.dart';
import 'package:bikeangletest/pages/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with TickerProviderStateMixin {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle(debug: true);
  StreamSubscription _rotationStream;

  /// Rotation controller
  AnimationController _rotationController;

  /// Rive
  Artboard _riveArtboard;
  SMIInput<double> _riveAngle;

  @override
  void initState() {
    // Rotation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/bike.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'State');
        if (controller != null) {
          artboard.addController(controller);
          _riveAngle = controller.findInput('Angle');
        }
        setState(() => _riveArtboard = artboard);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Aufzeichnen'),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              ),
              icon: Icon(Icons.info_outline),
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: _bikeAngle.getBikeAngle(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_outlined),
                          const SizedBox(height: 8.0),
                          Text(
                            'Gyroscope nicht verfügbar!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }

                    if (!snapshot.hasData) {
                      return _buildLoadingSpinner();
                    }

                    return StreamBuilder<DeviceRotation>(
                      stream: snapshot.data,
                      initialData: DeviceRotation(0),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingSpinner();
                        }

                        DeviceRotation deviceRotation = snapshot.data;

                        // rive angle
                        if (_riveAngle != null) {
                          _riveAngle.value =
                              deviceRotation.bikeAngle.roundToDouble();
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // AnimatedBuilder(
                            //   animation: _rotationController,
                            //   builder: (context, child) {
                            //     return Transform.rotate(
                            //       angle: -deviceRotation?.bikeAngleRad ?? 0.0,
                            //       alignment: Alignment.bottomCenter,
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           Text(
                            //             '${((deviceRotation?.bikeAngle ?? 0.0).abs()).toStringAsFixed(0)} °',
                            //             style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 36,
                            //             ),
                            //             textAlign: TextAlign.center,
                            //           ),
                            //           SvgPicture.asset(
                            //             'assets/motorcycle.svg',
                            //             width: 128,
                            //           )
                            //         ],
                            //       ),
                            //     );
                            //   },
                            // ),
                            // SizedBox(height: 16.0),
                            if (_riveArtboard != null) ...{
                              SizedBox(
                                height: 128,
                                child: Rive(
                                  artboard: _riveArtboard,
                                ),
                              ),
                            },
                            SizedBox(height: 16.0),
                            if (deviceRotation.valid) ...{
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_outlined),
                                  const SizedBox(width: 8.0),
                                  Text('Ausrichtung korrekt'),
                                ],
                              ),
                            } else ...{
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 8.0),
                                  Text('Ausrichtung inkorrekt'),
                                ],
                              ),
                            }
                          ],
                        );
                      },
                    );
                  },
                ),
                _buildControls(),
              ],
            ),
          ),
        ));
  }

  Widget _buildLoadingSpinner() {
    return SizedBox(
      height: 64,
      width: 64,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildControls() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => ScaleTransition(
        child: child,
        scale: animation,
      ),
      child: _getControls(),
    );
  }

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
