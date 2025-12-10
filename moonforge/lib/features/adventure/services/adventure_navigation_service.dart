import 'dart:async';

import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';

class AdventureNavigationService extends BaseService {
  AdventureNavigationService(this._repository);

  final AdventureRepository _repository;
  final _stateController = StreamController<AdventureNavState>.broadcast();

  @override
  String get serviceName => 'AdventureNavigationService';

  Stream<AdventureNavState> watchState(
    String chapterId,
    String adventureId,
  ) async* {
    yield await _buildState(chapterId, adventureId);
    yield* _stateController.stream.where(
      (state) =>
          state.chapterId == chapterId && state.adventureId == adventureId,
    );
  }

  Future<void> refresh(String chapterId, String adventureId) async {
    final state = await _buildState(chapterId, adventureId);
    _stateController.add(state);
  }

  Future<Adventure?> getAdjacentAdventure(
    String chapterId,
    String adventureId, {
    required bool forward,
  }) async {
    final adventures = await _repository.getByChapter(chapterId)
      ..sort((a, b) => a.order.compareTo(b.order));
    final index = adventures.indexWhere((a) => a.id == adventureId);
    if (index == -1) return null;
    final targetIndex = forward ? index + 1 : index - 1;
    if (targetIndex < 0 || targetIndex >= adventures.length) return null;
    return adventures[targetIndex];
  }

  Future<AdventureNavState> _buildState(
    String chapterId,
    String adventureId,
  ) async {
    final adventures = await _repository.getByChapter(chapterId)
      ..sort((a, b) => a.order.compareTo(b.order));
    if (adventures.isEmpty) {
      return AdventureNavState.empty();
    }
    final index = adventures.indexWhere((a) => a.id == adventureId);
    if (index == -1) {
      return AdventureNavState.empty();
    }
    final adventure = adventures[index];
    return AdventureNavState(
      chapterId: chapterId,
      adventureId: adventureId,
      currentName: adventure.name,
      position: index + 1,
      total: adventures.length,
      hasPrevious: index > 0,
      hasNext: index < adventures.length - 1,
    );
  }
}

class AdventureNavState {
  AdventureNavState({
    required this.chapterId,
    required this.adventureId,
    required this.currentName,
    required this.position,
    required this.total,
    required this.hasPrevious,
    required this.hasNext,
  });

  factory AdventureNavState.empty() => AdventureNavState(
    chapterId: '',
    adventureId: '',
    currentName: '',
    position: 0,
    total: 0,
    hasPrevious: false,
    hasNext: false,
  );

  final String chapterId;
  final String adventureId;
  final String currentName;
  final int position;
  final int total;
  final bool hasPrevious;
  final bool hasNext;
}
