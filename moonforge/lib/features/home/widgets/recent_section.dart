import 'package:flutter/material.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/features/home/widgets/placeholders.dart';
import 'package:moonforge/features/home/widgets/section_header.dart';

/// A reusable section widget for the Home screen that shows a header and
/// an async list of items as cards.
class RecentSection<T> extends StatelessWidget {
  const RecentSection({
    super.key,
    required this.title,
    required this.icon,
    required this.future,
    required this.titleOf,
    this.subtitleOf,
    this.onTap,
    this.onError,
  });

  final String title;
  final IconData icon;
  final Future<List<T>> future;
  final String Function(T item) titleOf;
  final String Function(T item)? subtitleOf;
  final void Function(T item)? onTap;
  final void Function(Object error, StackTrace stackTrace)? onError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, icon: icon),
        const SizedBox(height: 8),
        FutureBuilder<List<T>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPlaceholder();
            }
            if (snapshot.hasError) {
              final error = snapshot.error ?? 'Unknown error';
              final st = snapshot.stackTrace ?? StackTrace.empty;
              if (onError != null) {
                onError!(error, st);
              }
              return const ErrorPlaceholder();
            }
            final items = snapshot.data ?? List<T>.empty();
            if (items.isEmpty) {
              return const EmptyPlaceholder();
            }
            return CardList<T>(
              items: items,
              titleOf: titleOf,
              subtitleOf: subtitleOf,
              onTap: onTap,
            );
          },
        ),
      ],
    );
  }
}
