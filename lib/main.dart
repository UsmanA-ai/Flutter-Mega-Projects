import 'package:condition_report/StartupScreens/splashscreen.dart';
import 'package:condition_report/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

// Just A Comment For Testing!!!
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized before Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase with the correct options
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Condition Report Go",
      debugShowCheckedModeBanner: false,
      // This is your signup screen
      home: Splashscreen(),
      // home: ConditionReport(),
    );
  }
}
