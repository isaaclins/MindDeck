import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/design/minddeck_theme.dart';

void main() {
  test('theme uses bundled display and body fonts', () {
    final theme = MindDeckTheme.light();

    expect(theme.scaffoldBackgroundColor, MindDeckColors.cream);
    expect(theme.textTheme.headlineLarge?.fontFamily, 'PatrickHand');
    expect(theme.textTheme.bodyLarge?.fontFamily, 'Nunito');
  });

  testWidgets('StickerButton exposes its action and responds to taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: MindDeckTheme.light(),
        home: Scaffold(
          body: Center(
            child: StickerButton(
              label: 'Make a card',
              semanticLabel: 'Create a new flash card',
              icon: Icons.add_rounded,
              onPressed: () => taps += 1,
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(StickerButton)),
      matchesSemantics(
        label: 'Create a new flash card',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );

    await tester.tap(find.byType(StickerButton));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('PaperPanel makes tappable surfaces accessible', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: MindDeckTheme.light(),
        home: Scaffold(
          body: PaperPanel(
            semanticLabel: 'Open Spanish deck',
            onTap: () => tapped = true,
            child: const Text('Spanish'),
          ),
        ),
      ),
    );

    expect(find.text('Spanish'), findsOneWidget);
    await tester.tap(find.byType(PaperPanel));
    expect(tapped, isTrue);
  });
}
