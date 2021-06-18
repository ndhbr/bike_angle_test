import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            children: [
              _buildTitle(),
              _buildVersionNumber(),
              const Divider(height: 64.0),
              Column(
                children: [
                  _buildSubtitle('Tipps zur Ausrichtung'),
                  const SizedBox(height: 16.0),
                  SvgPicture.asset(
                    'assets/alignment.svg',
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  const SizedBox(height: 16.0),
                  _buildHintListTile(
                    '45°',
                    'Ausrichtung',
                    'Platziere dein Smartphone im Hochformat am Lenker mit ungefähr 45° Drehung zum Boden. Sobald bei der Aufzeichnung "Ausrichtung okay" erscheint, ist das Smartphone bereit zur Messung',
                  ),
                ],
              ),
              const Divider(height: 64.0),
              _buildCalibrationHints(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build calibration hints
  Column _buildCalibrationHints() {
    return Column(
      children: [
        _buildSubtitle('Tipps zur Kalibrierung'),
        const SizedBox(height: 16.0),
        if (Platform.isAndroid) ...{
          _buildHintListTile('1.', 'Öffne Google Maps',
              'Warte bis sich die Kartenansicht aufgebaut hat'),
          _buildHintListTile('2.', 'Tippe auf den blauen Punkt',
              'Daraufhin öffnet sich ein Fenster mit Optionen'),
          _buildHintListTile('3.', 'Tippe auf „Kompass kalibrieren“',
              'Der Knopf befindet sich unten links'),
          _buildHintListTile(
              '4.', 'Tippe auf „Fertig“', 'Wenn die Genauigkeit hoch ist'),
        } else ...{
          _buildHintListTile('1.', 'Starte das iPhone neu',
              'Warte bis es komplett hochgefahren ist'),
          _buildHintListTile('2.', 'Öffne den Kompass',
              'Dieser befindet sich standardmäßig im Ordner „Extras“'),
          _buildHintListTile('3.', 'Befolge die Anweisungen',
              'Und drehe dein Smartphone, bis der Prozess abgeschlossen ist'),
        },
      ],
    );
  }

  /// Build subtitle
  Text _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  /// Build version label (package info)
  FutureBuilder<PackageInfo> _buildVersionNumber() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasData) {
          PackageInfo packageInfo = snapshot.data;

          return Text(
              'Version ${packageInfo.version}+${packageInfo.buildNumber}');
        }

        return const Text('');
      },
    );
  }

  /// Build title
  Text _buildTitle() {
    return Text(
      'Bike Angle',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
    );
  }

  /// Build list tile for calibration hint
  Widget _buildHintListTile(String leading, String title, String subtitle) {
    return ListTile(
      leading: Text(
        leading,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      isThreeLine: true,
    );
  }
}
