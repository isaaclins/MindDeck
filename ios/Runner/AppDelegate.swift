import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private static let widgetChannelName = "app.minddeck.minddeck/widgets"
  private static let widgetSuiteName = "group.app.minddeck.minddeck"
  private var widgetChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "MindDeckWidgetBridge"
    ) else {
      return
    }

    let channel = FlutterMethodChannel(
      name: Self.widgetChannelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard let defaults = UserDefaults(suiteName: Self.widgetSuiteName) else {
        result(
          FlutterError(
            code: "widget_storage_unavailable",
            message: "The MindDeck widget App Group is unavailable.",
            details: nil
          )
        )
        return
      }

      switch call.method {
      case "updateSnapshot":
        guard
          let arguments = call.arguments as? [String: Any],
          let deckId = arguments["deckId"] as? String,
          let deckTitle = arguments["deckTitle"] as? String,
          let dueCardCount = arguments["dueCardCount"] as? Int,
          let samplePrompt = arguments["samplePrompt"] as? String
        else {
          result(
            FlutterError(
              code: "invalid_snapshot",
              message: "Widget snapshot fields are missing.",
              details: nil
            )
          )
          return
        }
        defaults.set(deckId, forKey: "deckId")
        defaults.set(deckTitle, forKey: "deckTitle")
        defaults.set(max(0, dueCardCount), forKey: "dueCardCount")
        defaults.set(samplePrompt, forKey: "samplePrompt")
        WidgetCenter.shared.reloadAllTimelines()
        result(true)

      case "clearSnapshot":
        for key in ["deckId", "deckTitle", "dueCardCount", "samplePrompt"] {
          defaults.removeObject(forKey: key)
        }
        WidgetCenter.shared.reloadAllTimelines()
        result(true)

      case "reloadWidgets":
        WidgetCenter.shared.reloadAllTimelines()
        result(true)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
    widgetChannel = channel
  }
}
