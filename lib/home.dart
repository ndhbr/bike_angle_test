import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/gyro_data.dart';
import 'package:bikeangle/device_rotation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Bike Angle Library
  BikeAngle _bikeAngle;

  @override
  void initState() {
    _bikeAngle = BikeAngle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bike Angle'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<GyroData>(
                stream: _bikeAngle.listenToGyroscopeEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text('Error');
                  }

                  GyroData gyroData = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Gyroscope Events'),
                      Text(
                          'x: ${gyroData.x.toStringAsFixed(2)}, y: ${gyroData.y.toStringAsFixed(2)}, z: ${gyroData.z.toStringAsFixed(2)}')
                    ],
                  );
                },
              ),
              StreamBuilder<GyroData>(
                stream: _bikeAngle.listenToAccelerometerEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text('Error');
                  }

                  GyroData gyroData = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Accelerometer Events'),
                      Text(
                          'x: ${gyroData.x.toStringAsFixed(2)}, y: ${gyroData.y.toStringAsFixed(2)}, z: ${gyroData.z.toStringAsFixed(2)}')
                    ],
                  );
                },
              ),
              StreamBuilder<GyroData>(
                stream: _bikeAngle.listenToUserAccelerometerEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text('Error');
                  }

                  GyroData gyroData = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('User Accelerometer Events'),
                      Text(
                          'x: ${gyroData.x.toStringAsFixed(2)}, y: ${gyroData.y.toStringAsFixed(2)}, z: ${gyroData.z.toStringAsFixed(2)}')
                    ],
                  );
                },
              ),
              StreamBuilder<DeviceRotation>(
                stream: _bikeAngle.listenToDeviceRotationEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text('Error');
                  }

                  DeviceRotation deviceRotation = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('User Accelerometer Events'),
                      Text(
                          'Pitch: ${deviceRotation.pitch.toStringAsFixed(2)}, Roll: ${deviceRotation.roll.toStringAsFixed(2)}'),
                      LinearProgressIndicator(
                        value: deviceRotation.pitch.abs() / 90,
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
