import 'package:bikeangletest/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RoundedRectangleBorder roundShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    );

    // Portrait only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Bike Angle',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue[700],
        accentColor: Colors.blue,
        backgroundColor: Colors.grey[200],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            brightness: Brightness.light,
            elevation: 0.0,
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: Colors.black87),
            iconTheme:
                Theme.of(context).iconTheme.copyWith(color: Colors.black87)),
        dividerColor: Colors.grey[300],
        iconTheme: IconThemeData(color: Colors.grey[400]),
        fontFamily: 'Open Sans',
        brightness: Brightness.light,
        // Tabs
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
        // Selection
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey[800],
        ),
        // Radiobuttons
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(Colors.blue),
        ),
        // Card
        cardTheme: const CardTheme(
          elevation: 2.0,
          color: Colors.white,
        ),
        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            errorStyle: TextStyle(color: Colors.red[400])),
        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(roundShape),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(roundShape),
            foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(roundShape),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue[700],
        accentColor: Colors.blue,
        backgroundColor: Colors.grey[800],
        appBarTheme: AppBarTheme(
          color: Colors.grey[800],
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
        dividerColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.grey[600]),
        fontFamily: 'Open Sans',
        brightness: Brightness.dark,
        // Tabs
        tabBarTheme: const TabBarTheme(
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
        // Selection
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white70,
        ),
        // Radiobuttons
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(Colors.blue),
        ),
        // Card
        cardTheme: CardTheme(
          elevation: 2.0,
          color: Colors.grey[800],
        ),
        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[900],
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            errorStyle: TextStyle(color: Colors.red[400])),
        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(roundShape),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
            foregroundColor: MaterialStateProperty.all(Colors.black87),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(roundShape),
            foregroundColor: MaterialStateProperty.all(Colors.grey[300]),
            overlayColor: MaterialStateProperty.all(Colors.grey[700]),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(roundShape),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
            overlayColor: MaterialStateProperty.all(Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}
