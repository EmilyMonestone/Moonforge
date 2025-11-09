import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/session/utils/session_formatters.dart';

/// Simple calendar widget for displaying and selecting session dates
class SessionCalendarWidget extends StatefulWidget {
  const SessionCalendarWidget({
    super.key,
    required this.sessions,
    this.onDateSelected,
    this.selectedDate,
  });

  final List<Session> sessions;
  final void Function(DateTime)? onDateSelected;
  final DateTime? selectedDate;

  @override
  State<SessionCalendarWidget> createState() => _SessionCalendarWidgetState();
}

class _SessionCalendarWidgetState extends State<SessionCalendarWidget> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
      widget.selectedDate?.year ?? DateTime.now().year,
      widget.selectedDate?.month ?? DateTime.now().month,
    );
    _selectedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return SurfaceContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(theme, colorScheme),
            const SizedBox(height: 16),
            _buildCalendarGrid(theme, colorScheme),
            if (_selectedDay != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildSessionsForDay(_selectedDay!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _focusedMonth = DateTime(
                _focusedMonth.year,
                _focusedMonth.month - 1,
              );
            });
          },
        ),
        Text(
          _getMonthYearString(_focusedMonth),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _focusedMonth = DateTime(
                _focusedMonth.year,
                _focusedMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(ThemeData theme, ColorScheme colorScheme) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final days = <Widget>[];
    
    // Add day headers
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    for (final name in dayNames) {
      days.add(
        Center(
          child: Text(
            name,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // Add empty cells for days before month starts
    for (var i = 0; i < startWeekday; i++) {
      days.add(const SizedBox());
    }

    // Add day cells
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isSelected = _selectedDay != null && _isSameDay(date, _selectedDay!);
      final isToday = _isSameDay(date, DateTime.now());
      final hasEvents = _getEventsForDay(date).isNotEmpty;

      days.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDay = date;
            });
            widget.onDateSelected?.call(date);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : isToday
                      ? colorScheme.primaryContainer
                      : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : isToday
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                      fontWeight: isToday || isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: days,
    );
  }

  List<Session> _getEventsForDay(DateTime day) {
    return widget.sessions.where((session) {
      if (session.datetime == null) return false;
      return _isSameDay(session.datetime, day);
    }).toList();
  }

  Widget _buildSessionsForDay(DateTime day) {
    final sessions = _getEventsForDay(day);
    final theme = Theme.of(context);

    if (sessions.isEmpty) {
      return Text(
        'No sessions on this day',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sessions (${sessions.length})',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...sessions.map((session) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              Icon(
                Icons.event,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  session.datetime != null
                      ? SessionFormatters.formatTimeUntilSession(
                          session.datetime!,
                        )
                      : 'No time set',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
