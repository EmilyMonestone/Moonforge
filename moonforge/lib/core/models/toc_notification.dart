import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_entry.dart';

/// Notification sent by pages to declare their TOC entries
class TocEntriesNotification extends Notification {
  final List<TocEntry> entries;

  const TocEntriesNotification(this.entries);
}
