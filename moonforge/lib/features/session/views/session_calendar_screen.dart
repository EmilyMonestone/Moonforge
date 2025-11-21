import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/session/widgets/session_calendar_widget.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for viewing sessions in a calendar format
class SessionCalendarScreen extends StatefulWidget {
  const SessionCalendarScreen({super.key, required this.partyId});

  final String partyId;

  @override
  State<SessionCalendarScreen> createState() => _SessionCalendarScreenState();
}

class _SessionCalendarScreenState extends State<SessionCalendarScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session Calendar')),
        body: Center(child: Text(l10n.noCampaignSelected)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Calendar'),
        actions: [
          if (_selectedDate != null)
            IconButton(
              icon: const Icon(Icons.today),
              tooltip: 'Go to today',
              onPressed: () {
                setState(() {
                  _selectedDate = DateTime.now();
                });
              },
            ),
        ],
      ),
      body: StreamBuilder<List<Session>>(
        stream: context.read<SessionRepository>().watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final sessions = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SessionCalendarWidget(
                sessions: sessions,
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
