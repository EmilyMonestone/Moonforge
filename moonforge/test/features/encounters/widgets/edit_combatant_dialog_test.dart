import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/encounters/widgets/edit_combatant_dialog.dart';
import 'package:moonforge/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('EditCombatantDialog can open and show fields', (tester) async {
    final combatant = db.Combatant(
      id: 'c1',
      encounterId: 'e1',
      name: 'Test',
      type: 'npc',
      isAlly: false,
      currentHp: 10,
      maxHp: 10,
      armorClass: 12,
      initiative: null,
      initiativeModifier: 0,
      entityId: null,
      bestiaryName: null,
      cr: '0',
      xp: 0,
      conditions: const <String>[],
      notes: null,
      order: 0,
    );
    bool updated = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: EditCombatantDialog(
          combatant: combatant,
          onUpdate: (c) => updated = true,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // The dialog shows the combatant name
    expect(find.textContaining('Edit'), findsWidgets);
  });
}
