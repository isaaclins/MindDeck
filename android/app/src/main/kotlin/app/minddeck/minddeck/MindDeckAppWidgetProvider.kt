package app.minddeck.minddeck

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews

internal object MindDeckWidgetContract {
    const val CHANNEL_NAME = "app.minddeck.minddeck/widgets"
    const val PREFERENCES_NAME = "minddeck_widget"
    const val KEY_DECK_ID = "deckId"
    const val KEY_DECK_TITLE = "deckTitle"
    const val KEY_DUE_CARD_COUNT = "dueCardCount"
    const val KEY_SAMPLE_PROMPT = "samplePrompt"
    const val ACTION_REFRESH = "app.minddeck.minddeck.action.REFRESH_WIDGET"
}

class MindDeckAppWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        updateWidgets(context, appWidgetManager, appWidgetIds)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        updateWidget(context, appWidgetManager, appWidgetId)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == MindDeckWidgetContract.ACTION_REFRESH) {
            val manager = AppWidgetManager.getInstance(context)
            updateWidgets(
                context,
                manager,
                manager.getAppWidgetIds(
                    android.content.ComponentName(
                        context,
                        MindDeckAppWidgetProvider::class.java,
                    ),
                ),
            )
        }
    }

    companion object {
        private const val MEDIUM_WIDGET_MIN_WIDTH_DP = 250

        fun updateWidgets(
            context: Context,
            manager: AppWidgetManager,
            widgetIds: IntArray,
        ) {
            widgetIds.forEach { updateWidget(context, manager, it) }
        }

        private fun updateWidget(
            context: Context,
            manager: AppWidgetManager,
            widgetId: Int,
        ) {
            val options = manager.getAppWidgetOptions(widgetId)
            val isMedium =
                options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH) >=
                    MEDIUM_WIDGET_MIN_WIDTH_DP
            val layoutId = if (isMedium) {
                R.layout.minddeck_widget_medium
            } else {
                R.layout.minddeck_widget_small
            }
            val views = RemoteViews(context.packageName, layoutId)
            val preferences = context.getSharedPreferences(
                MindDeckWidgetContract.PREFERENCES_NAME,
                Context.MODE_PRIVATE,
            )
            val deckId = preferences.getString(
                MindDeckWidgetContract.KEY_DECK_ID,
                "",
            ).orEmpty()
            val title = preferences.getString(
                MindDeckWidgetContract.KEY_DECK_TITLE,
                context.getString(R.string.widget_empty_title),
            ).orEmpty()
            val prompt = preferences.getString(
                MindDeckWidgetContract.KEY_SAMPLE_PROMPT,
                context.getString(R.string.widget_empty_prompt),
            ).orEmpty()
            val dueCount = preferences.getInt(
                MindDeckWidgetContract.KEY_DUE_CARD_COUNT,
                0,
            )
            val hasDeck = deckId.isNotBlank()

            views.setTextViewText(R.id.widget_deck_title, title)
            views.setTextViewText(R.id.widget_prompt, prompt)
            views.setTextViewText(
                R.id.widget_due_count,
                context.resources.getQuantityString(
                    R.plurals.widget_due_cards,
                    dueCount,
                    dueCount,
                ),
            )
            views.setViewVisibility(
                R.id.widget_study_action,
                if (hasDeck) View.VISIBLE else View.GONE,
            )

            val launchIntent = if (hasDeck) {
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("minddeck://study/${Uri.encode(deckId)}"),
                    context,
                    MainActivity::class.java,
                )
            } else {
                context.packageManager.getLaunchIntentForPackage(context.packageName)
                    ?: Intent(context, MainActivity::class.java)
            }
            val launchPendingIntent = PendingIntent.getActivity(
                context,
                widgetId,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_root, launchPendingIntent)
            views.setOnClickPendingIntent(R.id.widget_study_action, launchPendingIntent)

            val refreshIntent = Intent(
                context,
                MindDeckAppWidgetProvider::class.java,
            ).apply {
                action = MindDeckWidgetContract.ACTION_REFRESH
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context,
                widgetId,
                refreshIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_refresh_action, refreshPendingIntent)
            manager.updateAppWidget(widgetId, views)
        }
    }
}
