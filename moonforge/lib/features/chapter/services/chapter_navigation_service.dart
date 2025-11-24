import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';

/// Service for navigating between chapters and tracking progress
class ChapterNavigationService extends BaseService {
  final ChapterRepository _repository;

  @override
  String get serviceName => 'ChapterNavigationService';

  ChapterNavigationService({required ChapterRepository repository})
    : _repository = repository;

  /// Get the next chapter in the campaign
  Future<Chapter?> getNextChapter(String currentChapterId) async {
    return execute(() async {
      final currentChapter = await _repository.getById(currentChapterId);
      if (currentChapter == null) return null;

      final allChapters = await _repository.getByCampaign(
        currentChapter.campaignId,
      );

      // Find next chapter by order
      final sortedChapters = allChapters
        ..sort((a, b) => a.order.compareTo(b.order));
      final currentIndex = sortedChapters.indexWhere(
        (c) => c.id == currentChapterId,
      );

      if (currentIndex == -1 || currentIndex >= sortedChapters.length - 1) {
        return null;
      }

      return sortedChapters[currentIndex + 1];
    }, operationName: 'getNextChapter');
  }

  /// Get the previous chapter in the campaign
  Future<Chapter?> getPreviousChapter(String currentChapterId) async {
    return execute(() async {
      final currentChapter = await _repository.getById(currentChapterId);
      if (currentChapter == null) return null;

      final allChapters = await _repository.getByCampaign(
        currentChapter.campaignId,
      );

      // Find previous chapter by order
      final sortedChapters = allChapters
        ..sort((a, b) => a.order.compareTo(b.order));
      final currentIndex = sortedChapters.indexWhere(
        (c) => c.id == currentChapterId,
      );

      if (currentIndex <= 0) {
        return null;
      }

      return sortedChapters[currentIndex - 1];
    }, operationName: 'getPreviousChapter');
  }

  /// Get the first chapter in a campaign
  Future<Chapter?> getFirstChapter(String campaignId) async {
    return execute(() async {
      final chapters = await _repository.getByCampaign(campaignId);
      if (chapters.isEmpty) return null;

      chapters.sort((a, b) => a.order.compareTo(b.order));
      return chapters.first;
    }, operationName: 'getFirstChapter');
  }

  /// Get the last chapter in a campaign
  Future<Chapter?> getLastChapter(String campaignId) async {
    return execute(() async {
      final chapters = await _repository.getByCampaign(campaignId);
      if (chapters.isEmpty) return null;

      chapters.sort((a, b) => a.order.compareTo(b.order));
      return chapters.last;
    }, operationName: 'getLastChapter');
  }

  /// Get chapter position (1-based index) in campaign
  Future<int?> getChapterPosition(String chapterId) async {
    return execute(() async {
      final chapter = await _repository.getById(chapterId);
      if (chapter == null) return null;

      final allChapters = await _repository.getByCampaign(chapter.campaignId);
      final sortedChapters = allChapters
        ..sort((a, b) => a.order.compareTo(b.order));

      final index = sortedChapters.indexWhere((c) => c.id == chapterId);
      return index >= 0 ? index + 1 : null;
    }, operationName: 'getChapterPosition');
  }

  /// Get total number of chapters in campaign
  Future<int> getTotalChapters(String campaignId) async {
    return execute(() async {
      final chapters = await _repository.getByCampaign(campaignId);
      return chapters.length;
    }, operationName: 'getTotalChapters');
  }

  /// Check if chapter is first in campaign
  Future<bool> isFirstChapter(String chapterId) async {
    return execute(() async {
      final position = await getChapterPosition(chapterId);
      return position == 1;
    }, operationName: 'isFirstChapter');
  }

  /// Check if chapter is last in campaign
  Future<bool> isLastChapter(String chapterId) async {
    return execute(() async {
      final chapter = await _repository.getById(chapterId);
      if (chapter == null) return false;

      final total = await getTotalChapters(chapter.campaignId);
      final position = await getChapterPosition(chapterId);

      return position == total;
    }, operationName: 'isLastChapter');
  }
}
