package com.mantresh.weatherify.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.app.PendingIntent
import com.mantresh.weatherify.R

class SmallWeatherWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateSmallWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "com.mantresh.weatherify.WIDGET_UPDATE") {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = android.content.ComponentName(context, SmallWeatherWidget::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"

        fun updateSmallWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.widget_small)

            // Get data from SharedPreferences (set by Flutter)
            val temperature = prefs.getString("temperature", "--°") ?: "--°"
            val cityName = prefs.getString("city_name", "Loading...") ?: "Loading..."
            val condition = prefs.getString("condition", "") ?: ""

            views.setTextViewText(R.id.widget_temperature, temperature)
            views.setTextViewText(R.id.widget_city, cityName)
            views.setImageViewResource(R.id.widget_icon, getWeatherIcon(condition))

            // Set click intent to open app
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                context.packageManager.getLaunchIntentForPackage(context.packageName),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun getWeatherIcon(condition: String?): Int {
            return when {
                condition == null -> R.drawable.ic_weather_sunny
                condition.contains("rain", ignoreCase = true) ||
                condition.contains("drizzle", ignoreCase = true) -> R.drawable.ic_weather_rainy
                condition.contains("cloud", ignoreCase = true) -> R.drawable.ic_weather_cloudy
                condition.contains("snow", ignoreCase = true) -> R.drawable.ic_weather_snow
                condition.contains("storm", ignoreCase = true) ||
                condition.contains("thunder", ignoreCase = true) -> R.drawable.ic_weather_storm
                else -> R.drawable.ic_weather_sunny
            }
        }
    }
}
