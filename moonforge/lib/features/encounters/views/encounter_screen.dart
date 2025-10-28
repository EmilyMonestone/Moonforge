import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/l10n/app_localizations.dart';

class EncounterScreen extends StatelessWidget {
  const EncounterScreen({super.key, required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.encounter),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l10n.edit,
            onPressed: () {
              EncounterEditRoute(encounterId: encounterId).go(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.encounter,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('ID: $encounterId'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Start initiative tracker
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.startEncounter),
            ),
          ],
        ),
      ),
    );
  }
}
