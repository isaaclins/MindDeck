import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/platform/widgets/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('app.minddeck.minddeck/widgets');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('publishes the complete widget snapshot to the native bridge', () async {
    MethodCall? receivedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          receivedCall = call;
          return true;
        });

    final updated = await MindDeckWidgetBridge.update(
      const MindDeckWidgetSnapshot(
        deckId: 'spanish',
        deckTitle: 'Spanish Basics',
        dueCardCount: 4,
        samplePrompt: 'Hola',
      ),
    );

    expect(updated, isTrue);
    expect(receivedCall?.method, 'updateSnapshot');
    expect(receivedCall?.arguments, {
      'deckId': 'spanish',
      'deckTitle': 'Spanish Basics',
      'dueCardCount': 4,
      'samplePrompt': 'Hola',
    });
  });

  test('native bridge failures stay non-fatal', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) {
          throw PlatformException(code: 'unavailable');
        });

    expect(await MindDeckWidgetBridge.reload(), isFalse);
  });
}
