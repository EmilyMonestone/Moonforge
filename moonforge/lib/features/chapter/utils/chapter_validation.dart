import 'package:moonforge/data/db/app_db.dart';

/// Validation utilities for chapter data
class ChapterValidation {
  /// Validate chapter name
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (name.trim().length > 200) {
      return 'Name must be less than 200 characters';
    }
    return null;
  }

  /// Validate chapter summary
  static String? validateSummary(String? summary) {
    if (summary != null && summary.trim().length > 1000) {
      return 'Summary must be less than 1000 characters';
    }
    return null;
  }

  /// Validate chapter order
  static String? validateOrder(int? order) {
    if (order == null) {
      return 'Order is required';
    }
    if (order < 0) {
      return 'Order must be non-negative';
    }
    return null;
  }

  /// Validate entire chapter object
  static Map<String, String> validateChapter(Chapter chapter) {
    final errors = <String, String>{};

    final nameError = validateName(chapter.name);
    if (nameError != null) {
      errors['name'] = nameError;
    }

    final summaryError = validateSummary(chapter.summary);
    if (summaryError != null) {
      errors['summary'] = summaryError;
    }

    final orderError = validateOrder(chapter.order);
    if (orderError != null) {
      errors['order'] = orderError;
    }

    if (chapter.campaignId.isEmpty) {
      errors['campaignId'] = 'Campaign ID is required';
    }

    return errors;
  }

  /// Check if a chapter is valid
  static bool isValid(Chapter chapter) {
    return validateChapter(chapter).isEmpty;
  }

  /// Validate chapter name uniqueness within a campaign
  static bool isNameUniqueInCampaign(
    String name,
    String campaignId,
    List<Chapter> existingChapters, {
    String? excludeChapterId,
  }) {
    final normalizedName = name.trim().toLowerCase();

    return !existingChapters.any(
      (c) =>
          c.campaignId == campaignId &&
          c.id != excludeChapterId &&
          c.name.trim().toLowerCase() == normalizedName,
    );
  }
}
