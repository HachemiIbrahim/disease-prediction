// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:disease_prediction/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'predection_repository.g.dart';

@riverpod
PredectionRepository predectionRepository(Ref ref) {
  return PredectionRepository();
}

class PredectionRepository {
  Future<Either<AppFailure, Map<String, dynamic>>> predictDisease({
    required String input,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8000/prediction/predict'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"description": input}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract symptoms and predicted disease
        final extractedSymptoms = List<String>.from(data["symptoms"]);
        final predictedDisease = data["predicted_disease"];

        return right({
          "symptoms": extractedSymptoms,
          "predictedDisease": predictedDisease,
        });
      } else {
        return left(AppFailure(response.body));
      }
    } catch (e) {
      return left(AppFailure("Error: ${e.toString()}"));
    }
  }
}
