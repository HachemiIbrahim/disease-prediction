// ignore_for_file: non_constant_identifier_names

import 'package:disease_prediction/features/disease_predection/repository/predection_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'predection_view_model.g.dart';

@riverpod
class PredectionViewModel extends _$PredectionViewModel {
  late final PredectionRepository _repository;

  @override
  AsyncValue<Map<String, dynamic>> build() {
    _repository = ref.watch(predectionRepositoryProvider);
    return const AsyncValue.data({}); // Initialize state with an empty map
  }

  Future<void> predictDisease({
    required String input,
  }) async {
    state = const AsyncValue.loading();

    final result = await _repository.predictDisease(input: input);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (data) => AsyncValue.data(data),
    );
  }
}
