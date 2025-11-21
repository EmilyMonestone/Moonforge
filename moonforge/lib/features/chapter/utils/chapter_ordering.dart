import 'package:moonforge/data/db/app_db.dart';

/// Utilities for managing chapter ordering
class ChapterOrdering {
  /// Sort chapters by order field
  static List<Chapter> sortByOrder(List<Chapter> chapters) {
    final sorted = List<Chapter>.from(chapters);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  /// Get the next available order value for a new chapter
  static int getNextOrder(List<Chapter> existingChapters) {
    if (existingChapters.isEmpty) return 0;

    final maxOrder = existingChapters
        .map((c) => c.order)
        .reduce((a, b) => a > b ? a : b);

    return maxOrder + 1;
  }

  /// Reorder chapters to maintain sequential order (0, 1, 2, ...)
  static List<Chapter> normalizeOrder(List<Chapter> chapters) {
    final sorted = sortByOrder(chapters);
    final normalized = <Chapter>[];

    for (int i = 0; i < sorted.length; i++) {
      final chapter = sorted[i];
      if (chapter.order != i) {
        normalized.add(chapter.copyWith(order: i));
      } else {
        normalized.add(chapter);
      }
    }

    return normalized;
  }

  /// Move a chapter to a new position
  static List<Chapter> moveChapter(
    List<Chapter> chapters,
    String chapterId,
    int newOrder,
  ) {
    final sorted = sortByOrder(chapters);
    final chapterIndex = sorted.indexWhere((c) => c.id == chapterId);

    if (chapterIndex == -1) {
      throw Exception('Chapter not found: $chapterId');
    }

    final chapter = sorted.removeAt(chapterIndex);
    sorted.insert(newOrder, chapter);

    return normalizeOrder(sorted);
  }

  /// Swap two chapters' positions
  static List<Chapter> swapChapters(
    List<Chapter> chapters,
    String chapterId1,
    String chapterId2,
  ) {
    final sorted = sortByOrder(chapters);
    final index1 = sorted.indexWhere((c) => c.id == chapterId1);
    final index2 = sorted.indexWhere((c) => c.id == chapterId2);

    if (index1 == -1 || index2 == -1) {
      throw Exception('One or both chapters not found');
    }

    final chapter1 = sorted[index1];
    final chapter2 = sorted[index2];

    sorted[index1] = chapter2.copyWith(order: chapter1.order);
    sorted[index2] = chapter1.copyWith(order: chapter2.order);

    return sorted;
  }

  /// Insert a chapter at a specific position
  static List<Chapter> insertAtPosition(
    List<Chapter> existingChapters,
    Chapter newChapter,
    int position,
  ) {
    final chapters = List<Chapter>.from(existingChapters);
    chapters.insert(position, newChapter);
    return normalizeOrder(chapters);
  }

  /// Get chapter position (1-based index)
  static int? getChapterPosition(List<Chapter> chapters, String chapterId) {
    final sorted = sortByOrder(chapters);
    final index = sorted.indexWhere((c) => c.id == chapterId);
    return index >= 0 ? index + 1 : null;
  }

  /// Check if chapter is first in list
  static bool isFirst(List<Chapter> chapters, String chapterId) {
    final sorted = sortByOrder(chapters);
    return sorted.isNotEmpty && sorted.first.id == chapterId;
  }

  /// Check if chapter is last in list
  static bool isLast(List<Chapter> chapters, String chapterId) {
    final sorted = sortByOrder(chapters);
    return sorted.isNotEmpty && sorted.last.id == chapterId;
  }
}
