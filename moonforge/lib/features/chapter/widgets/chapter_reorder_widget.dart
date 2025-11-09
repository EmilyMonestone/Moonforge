import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Widget for reordering chapters via drag-and-drop
class ChapterReorderWidget extends StatefulWidget {
  const ChapterReorderWidget({
    super.key,
    required this.chapters,
    required this.onReorder,
  });

  final List<Chapter> chapters;
  final void Function(List<Chapter> reorderedChapters) onReorder;

  @override
  State<ChapterReorderWidget> createState() => _ChapterReorderWidgetState();
}

class _ChapterReorderWidgetState extends State<ChapterReorderWidget> {
  late List<Chapter> _chapters;

  @override
  void initState() {
    super.initState();
    _chapters = List<Chapter>.from(widget.chapters)
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  void didUpdateWidget(ChapterReorderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chapters != oldWidget.chapters) {
      _chapters = List<Chapter>.from(widget.chapters)
        ..sort((a, b) => a.order.compareTo(b.order));
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _chapters.removeAt(oldIndex);
      _chapters.insert(newIndex, item);
    });

    // Call the callback with reordered chapters
    widget.onReorder(_chapters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_chapters.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'No chapters to reorder',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _chapters.length,
      onReorder: _handleReorder,
      itemBuilder: (context, index) {
        final chapter = _chapters[index];
        return Card(
          key: ValueKey(chapter.id),
          color: theme.colorScheme.surfaceContainer,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.drag_handle,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: Text('${index + 1}'),
                ),
              ],
            ),
            title: Text(
              chapter.name,
              style: theme.textTheme.titleMedium,
            ),
            subtitle: chapter.summary != null && chapter.summary!.isNotEmpty
                ? Text(
                    chapter.summary!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
          ),
        );
      },
    );
  }
}
