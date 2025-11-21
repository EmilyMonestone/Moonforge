import 'package:flutter/material.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Provider for managing chapter state, navigation, and form state
class ChapterProvider with ChangeNotifier {
  static const String _currentChapterKey = 'current_chapter_id';
  final PersistenceService _persistence = PersistenceService();

  Chapter? _currentChapter;
  bool _hasUnsavedChanges = false;
  List<Chapter> _chapters = [];

  Chapter? get currentChapter => _currentChapter;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  List<Chapter> get chapters => _chapters;

  ChapterProvider() {
    _loadPersistedChapterId();
  }

  /// Load the persisted chapter ID on initialization
  void _loadPersistedChapterId() {
    try {
      final chapterId = _persistence.read<String>(_currentChapterKey);
      if (chapterId != null) {
        logger.i('Loaded persisted chapter ID: $chapterId');
      }
    } catch (e) {
      logger.e('Failed to load persisted chapter ID: $e');
    }
  }

  /// Get the persisted chapter ID
  String? getPersistedChapterId() {
    return _persistence.read<String>(_currentChapterKey);
  }

  /// Set the current chapter
  void setCurrentChapter(Chapter? chapter) {
    _currentChapter = chapter;

    // Persist the chapter ID
    if (chapter != null) {
      _persistence.write(_currentChapterKey, chapter.id);
      logger.i('Persisted chapter ID: ${chapter.id}');
    } else {
      _persistence.remove(_currentChapterKey);
      logger.i('Removed persisted chapter ID');
    }

    notifyListeners();
  }

  /// Update the list of chapters (for navigation)
  void setChapters(List<Chapter> chapters) {
    _chapters = chapters;
    notifyListeners();
  }

  /// Navigate to next chapter in the list
  Chapter? getNextChapter() {
    if (_currentChapter == null || _chapters.isEmpty) return null;

    final currentIndex = _chapters.indexWhere(
      (c) => c.id == _currentChapter!.id,
    );
    if (currentIndex == -1 || currentIndex >= _chapters.length - 1) {
      return null;
    }

    return _chapters[currentIndex + 1];
  }

  /// Navigate to previous chapter in the list
  Chapter? getPreviousChapter() {
    if (_currentChapter == null || _chapters.isEmpty) return null;

    final currentIndex = _chapters.indexWhere(
      (c) => c.id == _currentChapter!.id,
    );
    if (currentIndex <= 0) {
      return null;
    }

    return _chapters[currentIndex - 1];
  }

  /// Get the current chapter's position in the list
  int? getCurrentChapterIndex() {
    if (_currentChapter == null || _chapters.isEmpty) return null;

    final index = _chapters.indexWhere((c) => c.id == _currentChapter!.id);
    return index >= 0 ? index : null;
  }

  /// Mark form as having unsaved changes
  void setHasUnsavedChanges(bool value) {
    _hasUnsavedChanges = value;
    notifyListeners();
  }

  /// Clear unsaved changes flag (e.g., after saving)
  void clearUnsavedChanges() {
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  /// Clear the persisted chapter
  void clearPersistedChapter() {
    _persistence.remove(_currentChapterKey);
    _currentChapter = null;
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  /// Get chapter by ID from the list
  Chapter? getChapterById(String id) {
    try {
      return _chapters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
