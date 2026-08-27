import 'package:flutter/material.dart';

/// Wrapped banner ad object with readiness flag.
class WrappedBannerAd<T> {
  final T bannerAd;
  bool isReady;

  WrappedBannerAd({
    required this.bannerAd,
    this.isReady = false,
  });
}

/// Abstract base interface for ad network implementations.
abstract class AdsBase {
  /// Initialize the ad SDK.
  Future<void> init();

  /// Load a Banner ad for a specific widget [key].
  dynamic loadBannerAd(VoidCallback? onLoaded, Key key);

  /// Get loaded Banner ad widget or instance for a specific widget [key].
  dynamic getBannerAd(Key key);

  /// Load an Interstitial ad.
  void loadInterstitialAd();

  /// Show an Interstitial ad if ready.
  void showInterstitialAd({VoidCallback? onAdDismissed, VoidCallback? onAdFailed});

  /// Load a Rewarded ad.
  void loadRewardedAd();

  /// Show a Rewarded ad if ready.
  void showRewardedAd({required Function(dynamic item) onUserEarnedReward, VoidCallback? onAdDismissed});

  /// Load an App Open ad.
  Future<void> loadAppOpenAd();

  /// Show App Open ad if available.
  void showAdIfAvailableOpenAds();

  /// Dispose resources.
  void dispose();
}
