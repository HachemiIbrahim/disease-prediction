import 'package:disease_prediction/features/disease_predection/view/predection_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6759FF),
        fontFamily: 'Poppins',
      ),
      home: const PredictionScreen(),
    );
  }
}
