import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/features/encounters/widgets/add_combatant_dialog.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TestBestiaryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  List<Map<String, dynamic>> monsters = [
    {'name': 'Goblin', 'cr': '1', 'hp': 6, 'ac': 15},
  ];
  void loadMonsters({bool forceSync = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget makeTestable({
    required Widget child,
    required TestBestiaryProvider provider,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChangeNotifierProvider<TestBestiaryProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  testWidgets('AddCombatantDialog renders and adds a combatant', (
    tester,
  ) async {
    final provider = TestBestiaryProvider();
    bool added = false;

    await tester.pumpWidget(
      makeTestable(
        provider: provider,
        child: AddCombatantDialog(onAdd: (c) => added = true),
      ),
    );

    await tester.pumpAndSettle();

    // Should show the monster list item
    expect(find.text('Goblin'), findsOneWidget);

    // Tap the add icon
    final addIcon = find.byIcon(Icons.add_circle_outline).first;
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    expect(added, isTrue);
  });
}
