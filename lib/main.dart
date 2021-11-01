import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'main_screen.dart';
import 'welcome_screen.dart';


void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Fi Token',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: exist == false ? WelcomeScreen() : MainScreen(),
    );
  }

  bool exist = false;

  void accountExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      exist = prefs.containsKey("username");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountExists();
  }
}

