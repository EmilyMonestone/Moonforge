import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/models/campaign.dart';
import 'package:moonforge/core/providers/firebase_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All campaigns stream.
final campaignsProvider = StreamProvider<List<Campaign>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final col = firestore.collection('campaigns');
  return col.snapshots().map(
    (snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      // Ensure id is present for Campaign.fromJson
      final map = <String, dynamic>{...data, 'id': doc.id};
      return Campaign.fromJson(map);
    }).toList(),
  );
});

/// Persisted selected campaign id key
const _kSelectedCampaignIdKey = 'selected_campaign_id';

/// Async notifier for the selected campaign id with persistence.
class SelectedCampaignId extends AsyncNotifier<String?> {
  SharedPreferences? _prefs;

  @override
  FutureOr<String?> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!.getString(_kSelectedCampaignIdKey);
  }

  Future<void> set(String? id) async {
    state = const AsyncLoading();
    try {
      _prefs ??= await SharedPreferences.getInstance();
      if (id == null) {
        await _prefs!.remove(_kSelectedCampaignIdKey);
      } else {
        await _prefs!.setString(_kSelectedCampaignIdKey, id);
      }
      state = AsyncData(id);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> clear() => set(null);
}

final selectedCampaignIdProvider =
    AsyncNotifierProvider<SelectedCampaignId, String?>(SelectedCampaignId.new);

/// Stream of the selected campaign document. Emits null if no id is selected.
final selectedCampaignProvider = StreamProvider<Campaign?>((ref) {
  final idAsync = ref.watch(selectedCampaignIdProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);

  return idAsync.when(
    data: (id) {
      if (id == null || id.isEmpty) {
        return Stream<Campaign?>.value(null);
      }
      return firestore.collection('campaigns').doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        final data = doc.data()!;
        final map = <String, dynamic>{...data, 'id': doc.id};
        return Campaign.fromJson(map);
      });
    },
    loading: () => const Stream<Campaign?>.empty(),
    error: (error, stackTrace) => const Stream<Campaign?>.empty(),
  );
});
