package com.mantresh.weatherify.widget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import androidx.work.*
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource
import com.google.android.gms.tasks.Tasks
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

class WeatherWidgetWorker(
    private val context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    private val client = OkHttpClient()
    private val fusedLocationClient: FusedLocationProviderClient =
        LocationServices.getFusedLocationProviderClient(context)

    companion object {
        private const val WORK_NAME = "weather_widget_update"
        private const val PREFS_NAME = "HomeWidgetPreferences"

        fun schedulePeriodicUpdate(context: Context) {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

            val periodicWorkRequest = PeriodicWorkRequestBuilder<WeatherWidgetWorker>(
                30, TimeUnit.MINUTES,
                15, TimeUnit.MINUTES
            )
                .setConstraints(constraints)
                .setBackoffCriteria(
                    BackoffPolicy.LINEAR,
                    WorkRequest.MIN_BACKOFF_MILLIS,
                    TimeUnit.MILLISECONDS
                )
                .build()

            WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,
                periodicWorkRequest
            )
        }

        fun triggerImmediateUpdate(context: Context) {
            val oneTimeWorkRequest = OneTimeWorkRequestBuilder<WeatherWidgetWorker>()
                .setConstraints(
                    Constraints.Builder()
                        .setRequiredNetworkType(NetworkType.CONNECTED)
                        .build()
                )
                .build()

            WorkManager.getInstance(context).enqueue(oneTimeWorkRequest)
        }
    }

    override suspend fun doWork(): Result {
        return try {
            val location = getLastKnownLocation()
            if (location != null) {
                val weatherData = fetchWeather(location.first, location.second)
                if (weatherData != null) {
                    saveWeatherData(weatherData)
                    updateAllWidgets()
                }
            }
            Result.success()
        } catch (e: Exception) {
            e.printStackTrace()
            Result.retry()
        }
    }

    private fun getLastKnownLocation(): Pair<Double, Double>? {
        return try {
            val cancellationToken = CancellationTokenSource()
            val locationTask = fusedLocationClient.getCurrentLocation(
                Priority.PRIORITY_BALANCED_POWER_ACCURACY,
                cancellationToken.token
            )
            val location = Tasks.await(locationTask, 30, TimeUnit.SECONDS)
            location?.let { Pair(it.latitude, it.longitude) }
        } catch (e: SecurityException) {
            // Fallback to last known location from SharedPreferences
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val lat = prefs.getFloat("flutter.last_lat", 0f)
            val lon = prefs.getFloat("flutter.last_lon", 0f)
            if (lat != 0f && lon != 0f) Pair(lat.toDouble(), lon.toDouble()) else null
        } catch (e: Exception) {
            // Fallback to last known location from SharedPreferences
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val lat = prefs.getFloat("flutter.last_lat", 0f)
            val lon = prefs.getFloat("flutter.last_lon", 0f)
            if (lat != 0f && lon != 0f) Pair(lat.toDouble(), lon.toDouble()) else null
        }
    }

    private suspend fun fetchWeather(lat: Double, lon: Double): JSONObject? {
        return withContext(Dispatchers.IO) {
            try {
                val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                val apiKey = prefs.getString("flutter.api_key", null) ?: return@withContext null

                val url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey"
                val request = Request.Builder().url(url).build()
                val response = client.newCall(request).execute()

                if (response.isSuccessful) {
                    response.body?.string()?.let { JSONObject(it) }
                } else null
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }

    private fun saveWeatherData(json: JSONObject) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = prefs.edit()

        val main = json.getJSONObject("main")
        val weather = json.getJSONArray("weather").getJSONObject(0)
        val cityName = json.getString("name")

        val temp = main.getDouble("temp")
        val feelsLike = main.getDouble("feels_like")
        val tempMin = main.getDouble("temp_min")
        val tempMax = main.getDouble("temp_max")
        val humidity = main.getInt("humidity")
        val condition = weather.getString("main")

        val timeFormat = SimpleDateFormat("h:mm a", Locale.getDefault())
        val lastUpdate = timeFormat.format(Date())

        editor.putString("temperature", "${temp.toInt()}°")
        editor.putString("feels_like", "${feelsLike.toInt()}°")
        editor.putString("temp_min", "${tempMin.toInt()}°")
        editor.putString("temp_max", "${tempMax.toInt()}°")
        editor.putString("humidity", humidity.toString())
        editor.putString("condition", condition)
        editor.putString("city_name", cityName)
        editor.putString("last_update", "Updated $lastUpdate")
        editor.apply()
    }

    private fun updateAllWidgets() {
        val appWidgetManager = AppWidgetManager.getInstance(context)

        // Update small widgets
        val smallWidgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, SmallWeatherWidget::class.java)
        )
        for (id in smallWidgetIds) {
            SmallWeatherWidget.updateSmallWidget(context, appWidgetManager, id)
        }

        // Update medium widgets
        val mediumWidgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(context, MediumWeatherWidget::class.java)
        )
        for (id in mediumWidgetIds) {
            MediumWeatherWidget.updateMediumWidget(context, appWidgetManager, id)
        }
    }
}
