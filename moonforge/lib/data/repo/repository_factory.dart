import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/combatant_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/media_asset_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';

/// Factory that constructs repository instances from a concrete data source(s).
///
/// Centralizing repository construction simplifies swapping implementations
/// (e.g., for testing or different storage backends).
class RepositoryFactory {
  RepositoryFactory(this._db, {FirebaseFirestore? firestore})
    : _firestore = firestore;

  final AppDb _db;
  // The firestore handle is currently optional and unused by repos; keep it
  // available for future repository implementations that may require it.
  // ignore: unused_field
  final FirebaseFirestore? _firestore;

  CampaignRepository campaignRepo() => CampaignRepository(_db);

  ChapterRepository chapterRepo() => ChapterRepository(_db);

  AdventureRepository adventureRepo() => AdventureRepository(_db);

  SceneRepository sceneRepo() => SceneRepository(_db);

  EncounterRepository encounterRepo() => EncounterRepository(_db);

  EntityRepository entityRepo() => EntityRepository(_db);

  PartyRepository partyRepo() => PartyRepository(_db);

  SessionRepository sessionRepo() => SessionRepository(_db);

  MediaAssetRepository mediaRepo() => MediaAssetRepository(_db);

  PlayerRepository playerRepo() => PlayerRepository(_db);

  CombatantRepository combatantRepo() => CombatantRepository(_db);
}
