import 'package:flutter/material.dart';
import '../multi_ads_manager.dart';

/// App Lifecycle Observer to handle App Open Ads on resume.
class AppLifecycleObserver with WidgetsBindingObserver {
  static final AppLifecycleObserver _instance = AppLifecycleObserver._internal();
  factory AppLifecycleObserver() => _instance;
  AppLifecycleObserver._internal();

  bool _isListening = false;

  void startListening() {
    if (!_isListening) {
      WidgetsBinding.instance.addObserver(this);
      _isListening = true;
    }
  }

  void stopListening() {
    if (_isListening) {
      WidgetsBinding.instance.removeObserver(this);
      _isListening = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      MultiAdsManager.instance.showAppOpenAdIfAvailable();
    }
  }
}
