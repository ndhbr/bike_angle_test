import 'package:bikeangle/bikeangle.dart';
import 'package:bikeangle/models/device_rotation.dart';
import 'package:bikeangletest/shared/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bikeangle/models/recording.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Recording recording;

  DetailPage(this.recording);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  /// Bike Angle Library
  final BikeAngle _bikeAngle = BikeAngle();

  /// Smoothness value of the graphs
  final int sectorSize = 30;

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

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recording.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildDateCard(),
              const SizedBox(height: 8.0),
              Builder(
                builder: (BuildContext context) {
                  if (_deviceRotations.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return _buildLineChart(gradientColorsBlue, _angleData());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _init() async {
    _recording = widget.recording;
    _deviceRotations = [];
    _deviceRotations = await _bikeAngle.getRecordedAngles(_recording.id);

    setState(() {});
  }

  Card _buildDateCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.watch_later_outlined),
            title: Text(
              DateFormat("EEEE, dd.MM.yyy HH:mm", 'de_DE')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          _recording.startedRecordingTimestamp))
                      .toString() +
                  ' Uhr',
            ),
            subtitle: Text('Startzeitpunkt'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.watch_later_outlined),
            title: Text(
              DateFormat("EEEE, dd.MM.yyy HH:mm", 'de_DE')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          _recording.startedRecordingTimestamp))
                      .toString() +
                  ' Uhr',
            ),
            subtitle: Text('Endzeitpunkt'),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<Color> colors, LineChartData data) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
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

  LineChartData _angleData() {
    String title = 'Winkel';

    // Spot
    List<FlSpot> spots = [];
    List<double> smoothedValues = Utils.smoothList(
      _deviceRotations.map((e) => e.pitch).toList(),
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

            return valueTime?.difference(startTime)?.inMinutes.toString() +
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
