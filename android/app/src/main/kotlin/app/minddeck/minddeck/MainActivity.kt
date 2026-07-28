package app.minddeck.minddeck

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            MindDeckWidgetContract.CHANNEL_NAME,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateSnapshot" -> {
                    val arguments = call.arguments as? Map<*, *>
                    val deckId = arguments?.get("deckId") as? String
                    val deckTitle = arguments?.get("deckTitle") as? String
                    val dueCardCount = arguments?.get("dueCardCount") as? Int
                    val samplePrompt = arguments?.get("samplePrompt") as? String
                    if (deckId == null || deckTitle == null ||
                        dueCardCount == null || samplePrompt == null
                    ) {
                        result.error("invalid_snapshot", "Widget snapshot fields are missing.", null)
                        return@setMethodCallHandler
                    }

                    getSharedPreferences(
                        MindDeckWidgetContract.PREFERENCES_NAME,
                        Context.MODE_PRIVATE,
                    ).edit()
                        .putString(MindDeckWidgetContract.KEY_DECK_ID, deckId)
                        .putString(MindDeckWidgetContract.KEY_DECK_TITLE, deckTitle)
                        .putInt(
                            MindDeckWidgetContract.KEY_DUE_CARD_COUNT,
                            dueCardCount.coerceAtLeast(0),
                        )
                        .putString(MindDeckWidgetContract.KEY_SAMPLE_PROMPT, samplePrompt)
                        .apply()
                    reloadWidgets()
                    result.success(true)
                }

                "clearSnapshot" -> {
                    getSharedPreferences(
                        MindDeckWidgetContract.PREFERENCES_NAME,
                        Context.MODE_PRIVATE,
                    ).edit().clear().apply()
                    reloadWidgets()
                    result.success(true)
                }

                "reloadWidgets" -> {
                    reloadWidgets()
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun reloadWidgets() {
        val manager = AppWidgetManager.getInstance(this)
        val component = ComponentName(this, MindDeckAppWidgetProvider::class.java)
        val widgetIds = manager.getAppWidgetIds(component)
        MindDeckAppWidgetProvider.updateWidgets(this, manager, widgetIds)
    }
}
