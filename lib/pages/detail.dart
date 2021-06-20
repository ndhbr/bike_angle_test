import 'dart:math';

import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/models/device_rotation.dart';
import 'package:bikeangletest/shared/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bikeangle/models/recording.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class DetailPage extends StatefulWidget {
  final Recording recording;

  DetailPage(this.recording, {Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle();

  /// Smoothness value of the graphs
  final int sectorSize = 150;

  /// Recording
  Recording _recording;

  /// Tracked points
  List<DeviceRotation> _deviceRotations;

  /// Chart
  Color blueBackground = Colors.blue;
  Color whiteAccent = Colors.white38;
  List<Color> lineColorBlue = [Colors.white];
  List<Color> gradientColorsBlue = [Colors.blue, Colors.blue[700]];
  List<Color> gradientColorsBlueChart = [Colors.blue[600], Colors.blue[800]];

  /// Edit mode
  bool _editMode;
  bool _didChange;
  TextEditingController _titleInputController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (!_editMode)
            ? Text(_recording.title)
            : TextFormField(
                controller: _titleInputController,
                style: TextStyle(height: 1.0),
              ),
        actions: [
          if (!_editMode) ...{
            IconButton(
              onPressed: () => _toggleEditMode(),
              icon: Icon(Icons.edit_outlined),
            ),
          } else ...{
            IconButton(
              onPressed: () => _saveNewName(),
              icon: Icon(Icons.save_outlined),
            ),
          }
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(_didChange);
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildDateCard(),
                const SizedBox(height: 8.0),
                _buildDiagram(),
                const SizedBox(height: 8.0),
                _buildStatsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Initialize detail page
  Future<void> _init() async {
    _editMode = false;
    _didChange = false;
    _titleInputController = TextEditingController(text: widget.recording.title);

    _recording = widget.recording;
    _deviceRotations = [];
    _deviceRotations = await _bikeAngle.getRecordedAngles(_recording.id);

    setState(() {});
  }

  /// Toggle name edit mode
  void _toggleEditMode() {
    if (mounted) {
      setState(() => _editMode = !_editMode);
    }
  }

  /// Save new name to the database and toggle edit mode
  Future<void> _saveNewName() async {
    if (_titleInputController != null) {
      String newTitle = _titleInputController.text;

      if (newTitle != _recording.title) {
        await _bikeAngle.setRecordingTitle(_recording.id, newTitle);
        _recording.title = newTitle;
        _didChange = true;
      }
    }

    _toggleEditMode();
  }

  /// Build dates card
  Card _buildDateCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              height: double.infinity,
              child: Icon(Icons.watch_later_outlined),
            ),
            title: Text(
              DateFormat("EEEE, dd.MM.yyy HH:mm", 'de_DE')
                      .format(
                        DateTime.fromMillisecondsSinceEpoch(
                          _recording.startedRecordingTimestamp,
                        ),
                      )
                      .toString() +
                  ' Uhr',
            ),
            subtitle: Text('Startzeitpunkt'),
          ),
          Divider(),
          ListTile(
            leading: SizedBox(
              height: double.infinity,
              child: Icon(Icons.watch_later_outlined),
            ),
            title: Text(
              DateFormat("EEEE, dd.MM.yyy HH:mm", 'de_DE')
                      .format(
                        DateTime.fromMillisecondsSinceEpoch(
                          _recording.stoppedRecordingTimestamp,
                        ),
                      )
                      .toString() +
                  ' Uhr',
            ),
            subtitle: Text('Endzeitpunkt'),
          ),
        ],
      ),
    );
  }

  /// Build stats card (max (left/right) angle)
  Card _buildStatsCard() {
    double maxLeft = Utils.getGreatestNumber(
        _deviceRotations.map((e) => e.bikeAngle).toList());
    double maxRight = Utils.getLowestNumber(
        _deviceRotations.map((e) => e.bikeAngle).toList());
    double maxAngle = maxLeft;

    if (maxRight.abs() > maxLeft.abs()) {
      maxAngle = maxRight;
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              height: double.infinity,
              child: Icon(Icons.architecture_outlined),
            ),
            title: Text(maxAngle.abs().toStringAsFixed(1) + '°'),
            subtitle: Text('Maximalwinkel'),
          ),
          Divider(),
          ListTile(
            leading: SizedBox(
              height: double.infinity,
              child: Icon(Icons.screen_rotation_outlined),
            ),
            title: Text(maxLeft.abs().toStringAsFixed(1) + '°'),
            subtitle: Text('Maximale Neigung: Linkskurve'),
          ),
          ListTile(
            leading: SizedBox(
              height: double.infinity,
              child: Transform(
                transform: Matrix4.rotationY(pi),
                alignment: Alignment.center,
                child: Icon(Icons.screen_rotation_outlined),
              ),
            ),
            title: Text(maxRight.abs().toStringAsFixed(1) + '°'),
            subtitle: Text('Maximale Neigung: Rechtskurve'),
          ),
          const SizedBox(height: 32.0),
          _buildAngleVisualization(
            maxAngleLeft: -maxLeft,
            maxAngleRight: -maxRight,
          ),
        ],
      ),
    );
  }

  /// Build slider box to visualize the max bike angles
  Widget _buildAngleVisualization(
      {@required double maxAngleLeft, @required double maxAngleRight}) {
    return Container(
      height: 150,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildSlider(maxAngleLeft),
          Center(child: SvgPicture.asset('assets/motorcycle.svg', width: 128)),
          _buildSlider(maxAngleRight, isRight: true),
        ],
      ),
    );
  }

  /// Build single slider for slider box
  Widget _buildSlider(double angle, {bool isRight}) {
    // Positioned
    double left = 48.0;
    double right;

    // Slider
    double angleRange = 90;
    double trackGradientStartAngle = 260.0;
    double trackGradientEndAngle = 350.0;
    double startAngle = 260;
    bool counterClockwise = true;
    double initialValue = (angle < 0) ? angle.abs() : 0;

    if (isRight != null && isRight) {
      // Positioned
      left = null;
      right = 48.0;

      // Slider
      trackGradientStartAngle = 280.0;
      trackGradientEndAngle = 370.0;
      startAngle = 280;
      counterClockwise = false;
      initialValue = (angle > 0) ? angle : 0;
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
        innerWidget: (_) => Center(
          child: Text(
            '${angle.abs().toStringAsFixed(1)}°',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Build line chart by loaded device rotations
  /// (or loading spinner, if data is not ready yet)
  Builder _buildDiagram() {
    return Builder(
      builder: (BuildContext context) {
        if (_deviceRotations.isEmpty) {
          return const SizedBox();
        }

        return _buildLineChart(gradientColorsBlue, _angleData());
      },
    );
  }

  /// Build line chart by colors and data
  Widget _buildLineChart(List<Color> colors, LineChartData data) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 40, left: 8.0, top: 22, bottom: 8),
          child: LineChart(data),
        ),
      ),
    );
  }

  /// Build line chart data
  LineChartData _angleData() {
    String title = 'Winkel';

    // Spot
    List<FlSpot> spots = [];
    List<double> smoothedValues = Utils.smoothList(
      _deviceRotations.reversed.map((e) => e.bikeAngle).toList(),
      sectorSize,
    );
    smoothedValues.asMap().forEach((key, value) {
      if (value > 90) {
        value = 90;
      } else if (value < -90) {
        value = -90;
      }

      spots.add(FlSpot(key.toDouble(), value));
    });

    // Y range
    double minAngle = -90;
    double maxAngle = 90;
    double rangeY = 180;

    return LineChartData(
      axisTitleData: FlAxisTitleData(
        show: true,
        topTitle: AxisTitle(
          showTitle: true,
          margin: 16,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          titleText: title,
        ),
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 0,
            color: whiteAccent,
          )
        ],
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              String toolTip = '${lineBarSpot.y.round().toString()}';
              toolTip += '° Neigung';

              return LineTooltipItem(
                toolTip,
                const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          interval: smoothedValues.length / 2,
          getTitles: (value) {
            DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
                _deviceRotations.first.capturedAt);
            DateTime valueTime;

            if (value == 0) {
              valueTime = DateTime.fromMillisecondsSinceEpoch(
                  _deviceRotations[value.toInt()].capturedAt);
            } else if (value == smoothedValues.length / 2) {
              valueTime = DateTime.fromMillisecondsSinceEpoch(
                  _deviceRotations[(_deviceRotations.length / 2).floor()]
                      .capturedAt);
            } else if (value == smoothedValues.length) {
              valueTime = DateTime.fromMillisecondsSinceEpoch(
                  _deviceRotations.last.capturedAt);
            }

            return startTime?.difference(valueTime)?.inMinutes.toString() +
                ' min';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          interval: rangeY / 4,
          getTitles: (value) {
            return value.round().toString() + '°';
          },
          reservedSize: 32,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.white10, width: 1)),
      minX: 0,
      maxX: smoothedValues.length.toDouble(),
      minY: minAngle,
      maxY: maxAngle,
      clipData: FlClipData.vertical(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: lineColorBlue,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColorsBlueChart
                .map((color) => color.withOpacity(0.6))
                .toList(),
            gradientColorStops: [0.5, 1.0],
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }
}
