import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The device-local data rendered by the MindDeck home-screen widgets.
///
/// Widget snapshots intentionally contain no card answers or learning history.
/// [deckId] is used only to create `minddeck://study/<deckId>` deep links.
@immutable
class MindDeckWidgetSnapshot {
  const MindDeckWidgetSnapshot({
    required this.deckId,
    required this.deckTitle,
    required this.dueCardCount,
    required this.samplePrompt,
  });

  final String deckId;
  final String deckTitle;
  final int dueCardCount;
  final String samplePrompt;

  Map<String, Object> toMap() => <String, Object>{
    'deckId': deckId,
    'deckTitle': deckTitle,
    'dueCardCount': dueCardCount,
    'samplePrompt': samplePrompt,
  };
}

/// Publishes data to the native iOS and Android home-screen widgets.
///
/// Call [update] after deck or study progress persistence succeeds. Both native
/// implementations atomically persist the snapshot and immediately request a
/// widget reload. Calls are safe no-ops on platforms without widget support.
abstract final class MindDeckWidgetBridge {
  static const MethodChannel _channel = MethodChannel(
    'app.minddeck.minddeck/widgets',
  );

  static bool get isSupported {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  static Future<bool> update(MindDeckWidgetSnapshot snapshot) async {
    if (!isSupported) return false;
    return _invoke('updateSnapshot', snapshot.toMap());
  }

  /// Removes previously published content and restores the widget empty state.
  static Future<bool> clear() async {
    if (!isSupported) return false;
    return _invoke('clearSnapshot');
  }

  /// Requests a redraw without changing the current widget snapshot.
  static Future<bool> reload() async {
    if (!isSupported) return false;
    return _invoke('reloadWidgets');
  }

  static Future<bool> _invoke(
    String method, [
    Map<String, Object>? arguments,
  ]) async {
    try {
      return await _channel.invokeMethod<bool>(method, arguments) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
