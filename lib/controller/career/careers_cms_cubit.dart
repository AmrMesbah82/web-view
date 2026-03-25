// ******************* FILE INFO *******************
// File Name: careers_cms_cubit.dart
// Created by: Amr Mesbah

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:website_app/controller/career/careers_cms_state.dart';
import 'package:website_app/model/careers_cms_model.dart';
import 'package:website_app/repo/career/careers_cms_repo.dart';
import 'package:website_app/repo/career/careers_cms_repo_impl.dart';

class CareersCmsCubit extends Cubit<CareersCmsState> {
  final CareersCmsRepo _repo;

  CareersCmsCubit({CareersCmsRepo? repo})
      : _repo = repo ?? CareersCmsRepoImpl(),
        super(CareersCmsInitial());

  // ── Convenience getter for the current model (never null) ──────────────────

  CareersCmsModel get current {
    final s = state;
    if (s is CareersCmsLoaded) return s.data;
    if (s is CareersCmsSaved) return s.data;
    if (s is CareersCmsError && s.lastData != null) return s.lastData!;
    return CareersCmsModel.empty();
  }

  // ── Load from Firestore ────────────────────────────────────────────────────

  Future<void> load() async {
    print('🟡 [CareersCmsCubit] load()');
    emit(CareersCmsLoading());
    try {
      final model = await _repo.fetch();
      emit(CareersCmsLoaded(model));
    } catch (e) {
      print('🔴 [CareersCmsCubit] load() ERROR: $e');
      emit(CareersCmsError(e.toString()));
    }
  }

  /// Load with hardcoded demo data (no Firestore needed yet)
  void loadDemo() {
    print('🟡 [CareersCmsCubit] loadDemo()');
    emit(CareersCmsLoaded(CareersCmsModel.empty()));
  }

  // ── Save to Firestore ──────────────────────────────────────────────────────

  Future<void> save(CareersCmsModel model) async {
    print('🟡 [CareersCmsCubit] save()');
    final previous = current;
    emit(CareersCmsLoading());
    try {
      await _repo.save(model);
      print('🟢 [CareersCmsCubit] save() → OK');
      emit(CareersCmsSaved(model));
    } catch (e) {
      print('🔴 [CareersCmsCubit] save() ERROR: $e');
      emit(CareersCmsError(e.toString(), lastData: previous));
    }
  }

  // ── Local draft mutations (edit page uses these before final save) ─────────

  void updateOverviewDescription(BilingualText value) {
    final updated = current.copyWith(
      overview: current.overview.copyWith(description: value),
    );
    emit(CareersCmsLoaded(updated));
  }

  void updateOverviewActionButton(BilingualText value) {
    final updated = current.copyWith(
      overview: current.overview.copyWith(actionButtonLabel: value),
    );
    emit(CareersCmsLoaded(updated));
  }

  void addStatistic() {
    final stats = List<CareerStatItem>.from(current.statistics)
      ..add(CareerStatItem.empty());
    emit(CareersCmsLoaded(current.copyWith(statistics: stats)));
  }

  void removeStatistic(String id) {
    final stats = current.statistics.where((s) => s.id != id).toList();
    emit(CareersCmsLoaded(current.copyWith(statistics: stats)));
  }

  void updateStatistic(CareerStatItem updated) {
    final stats = current.statistics
        .map((s) => s.id == updated.id ? updated : s)
        .toList();
    emit(CareersCmsLoaded(current.copyWith(statistics: stats)));
  }
}