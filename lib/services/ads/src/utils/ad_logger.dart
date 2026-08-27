import 'package:flutter/foundation.dart';

/// Logging utility for AdMob ad events.
class AdLogger {
  static bool enableLogs = true;

  static void log(String message) {
    if (enableLogs) {
      debugPrint('[MultiAdsAdmob] $message');
    }
  }

  static void error(String message, [dynamic err]) {
    if (enableLogs) {
      debugPrint('[MultiAdsAdmob ERROR] $message ${err != null ? ': $err' : ''}');
    }
  }
}
