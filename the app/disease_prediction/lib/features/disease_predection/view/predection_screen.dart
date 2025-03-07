// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _predictedDisease = "";
  List<String> _extractedSymptoms = [];
  bool _isLoading = false;

  Future<void> predictDisease() async {
    final String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _isLoading = true;
      _predictedDisease = "";
      _extractedSymptoms = [];
    });

    final response = await http.post(
      Uri.parse('http://your-api-url/predict'), // Replace with your API URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"description": userInput}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _extractedSymptoms = List<String>.from(data["symptoms"]);
        _predictedDisease = data["predicted_disease"];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error predicting disease!")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Health AI Diagnosis",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6759FF)),
              ),
              const SizedBox(height: 20),
              _buildGlassInputField(),
              const SizedBox(height: 20),
              _buildPredictButton(),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : _buildOutputCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2),
        ],
      ),
      child: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: "Describe your symptoms...",
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return GestureDetector(
      onTap: predictDisease,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        decoration: BoxDecoration(
          color: const Color(0xFF6759FF),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          "Predict Disease",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOutputCard() {
    if (_predictedDisease.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Extracted Symptoms:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 8.0,
            children: _extractedSymptoms.map((symptom) {
              return Chip(
                label: Text(symptom),
                backgroundColor: Colors.blue[100],
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
          const Text(
            "Predicted Disease:",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 5),
          Text(
            _predictedDisease,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
