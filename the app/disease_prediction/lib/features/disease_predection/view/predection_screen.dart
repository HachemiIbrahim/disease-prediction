// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:disease_prediction/features/disease_predection/view_model/predection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

class PredictionScreen extends ConsumerStatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends ConsumerState<PredictionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _predictedDisease = "";
  List<String> _extractedSymptoms = [];

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      predectionViewModelProvider.select((val) => val.isLoading),
    );

    ref.listen(
      predectionViewModelProvider,
      (_, next) {
        next.when(
          data: (data) {
            setState(() {
              _predictedDisease = data["predictedDisease"] ?? "Unknown Disease";
              _extractedSymptoms = data["extractedSymptoms"]?.split(",") ?? [];
            });
          },
          error: (error, st) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Health AI Diagnosis",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6759FF),
                ),
              ),
              const SizedBox(height: 20),
              _buildGlassInputField(),
              const SizedBox(height: 20),
              _buildPredictButton(isLoading),
              const SizedBox(height: 30),
              _predictedDisease.isNotEmpty
                  ? _buildOutputCard()
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInputField() {
    return TextField(
      controller: _controller,
      maxLines: 3,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Describe your symptoms...",
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPredictButton(bool isLoading) {
    return GestureDetector(
      onTap: () {
        ref.read(predectionViewModelProvider.notifier).predictDisease(
              input: _controller.text,
            );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : const Color(0xFF6759FF),
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
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Predict Disease",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildOutputCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: const [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  "Predicted Disease:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red),
                ),
              ],
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
      ),
    );
  }
}
