package com.meratun.app

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.meratun.app/platform"
    private val prefsName = "com.meratun.app.platform_store"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val prefs = getSharedPreferences(prefsName, MODE_PRIVATE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getString" -> result.success(prefs.getString(call.arguments as String, null))
                    "setString" -> {
                        val args = call.arguments as Map<*, *>
                        prefs.edit()
                            .putString(args["key"] as String, args["value"] as String)
                            .apply()
                        result.success(null)
                    }
                    "remove" -> {
                        prefs.edit().remove(call.arguments as String).apply()
                        result.success(null)
                    }
                    "openUrl" -> {
                        try {
                            val url = call.arguments as String
                            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
