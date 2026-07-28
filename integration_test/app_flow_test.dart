import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:minddeck/app/minddeck_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens a deck and completes a study interaction', (tester) async {
    await tester.pumpWidget(const MindDeckApp());
    await _pumpUntilFound(tester, find.text('Spanish Basics'));

    await tester.tap(find.text('Spanish Basics').first);
    await _pumpUntilFound(tester, find.byKey(const Key('study-deck-button')));

    await tester.tap(find.byKey(const Key('study-deck-button')));
    await _pumpUntilFound(tester, find.byKey(const Key('study-card')));

    await tester.tap(find.byKey(const Key('study-card')));
    await _pumpUntilFound(tester, find.byKey(const Key('correct-button')));
    expect(find.byKey(const Key('grade-controls')), findsOneWidget);

    await tester.tap(find.byKey(const Key('correct-button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('grade-controls')), findsNothing);
  });
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 15),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsWidgets);
}
