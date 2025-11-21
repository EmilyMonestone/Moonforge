import 'package:drift/drift.dart' show Value;
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:uuid/uuid.dart';

/// Service for chapter operations, statistics, and progression
class ChapterService {
  final ChapterRepository _repository;
  final AppDb _db;

  ChapterService({required ChapterRepository repository, required AppDb db})
    : _repository = repository,
      _db = db;

  /// Get chapter statistics
  Future<ChapterStats> getChapterStats(String chapterId) async {
    final chapter = await _repository.getById(chapterId);
    if (chapter == null) {
      throw Exception('Chapter not found: $chapterId');
    }

    // Get adventures in this chapter
    final adventures = await _db.adventureDao.customQuery(
      filter: (a) => a.chapterId.equals(chapterId),
    );

    // Get scenes across all adventures in the chapter
    int totalScenes = 0;
    for (final adventure in adventures) {
      final scenes = await _db.sceneDao.customQuery(
        filter: (s) => s.adventureId.equals(adventure.id),
      );
      totalScenes += scenes.length;
    }

    // Count entities
    final entityCount = chapter.entityIds.length;

    return ChapterStats(
      chapterId: chapterId,
      adventureCount: adventures.length,
      sceneCount: totalScenes,
      entityCount: entityCount,
    );
  }

  /// Calculate chapter progression (completed adventures vs total)
  Future<double> calculateProgression(String chapterId) async {
    final adventures = await _db.adventureDao.customQuery(
      filter: (a) => a.chapterId.equals(chapterId),
    );

    if (adventures.isEmpty) return 0.0;

    // For now, we don't have a "completed" flag on adventures
    // This is a placeholder that could be extended when that feature is added
    return 0.0;
  }

  /// Get total word count for chapter content
  int getWordCount(Chapter chapter) {
    int count = 0;

    // Count summary words
    if (chapter.summary != null && chapter.summary!.isNotEmpty) {
      count += chapter.summary!.split(RegExp(r'\s+')).length;
    }

    // Count content words (from Quill delta)
    if (chapter.content != null) {
      final ops = chapter.content!['ops'] as List<dynamic>?;
      if (ops != null) {
        for (final op in ops) {
          if (op is Map && op['insert'] is String) {
            final text = op['insert'] as String;
            count += text.split(RegExp(r'\s+')).length;
          }
        }
      }
    }

    return count;
  }

  /// Duplicate a chapter with a new name
  Future<Chapter> duplicateChapter(Chapter source, String newName) async {
    final newId = const Uuid().v7();

    final newChapter = Chapter(
      id: newId,
      campaignId: source.campaignId,
      name: newName,
      order: source.order + 1,
      // Place after the source chapter
      summary: source.summary,
      content: source.content,
      entityIds: source.entityIds,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await _repository.create(newChapter);
    return newChapter;
  }

  /// Reorder chapters in a campaign
  Future<void> reorderChapters(
    String campaignId,
    List<String> chapterIds,
  ) async {
    final chapters = await _repository.getByCampaign(campaignId);

    for (int i = 0; i < chapterIds.length; i++) {
      final chapterId = chapterIds[i];
      final chapter = chapters.firstWhere((c) => c.id == chapterId);

      if (chapter.order != i) {
        final updated = chapter.copyWith(
          order: i,
          updatedAt: Value(DateTime.now()),
        );
        await _repository.update(updated);
      }
    }
  }
}

/// Statistics for a chapter
class ChapterStats {
  final String chapterId;
  final int adventureCount;
  final int sceneCount;
  final int entityCount;

  ChapterStats({
    required this.chapterId,
    required this.adventureCount,
    required this.sceneCount,
    required this.entityCount,
  });
}
