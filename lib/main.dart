import 'package:condition_report/MainScreens/assesments.dart';
import 'package:condition_report/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Just A Comment For Testing!!!
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized before Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase with the correct options
  await Supabase.initialize(url: "https://fsprbrmiiwpmdezweozy.supabase.co", anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzcHJicm1paXdwbWRlendlb3p5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc1MzcyNDgsImV4cCI6MjA1MzExMzI0OH0.Bw6WX6mbAyOAfRtjrCcOb0ioK9rsh8noA6EcaC_4ONg");
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
      home: AssesmentsScreen(),
      // home: Splashscreen(),
      // home: ConditionReport(),
    );
  }
}
