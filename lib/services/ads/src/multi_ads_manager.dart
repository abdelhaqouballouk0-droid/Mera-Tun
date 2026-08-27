import 'package:flutter/material.dart';
import 'data/admob_data.dart';
import 'data/ads_data.dart';
import 'data/settings_data.dart';
import 'networks/admob_network.dart';
import 'networks/ads_base.dart';
import 'networks/no_ads_network.dart';
import 'service/app_lifecycle_observer.dart';
import 'utils/ad_logger.dart';

/// Central singleton/factory manager for AdMob orchestration.
class MultiAdsManager {
  static final MultiAdsManager _instance = MultiAdsManager._internal();
  static MultiAdsManager get instance => _instance;
  MultiAdsManager._internal();

  // Safe no-op defaults so widgets that read [adsData]/[activeNetwork]
  // before [init] runs (e.g. widget tests, or a build racing startup)
  // render as "no ads" instead of hitting a LateInitializationError.
  AdsData adsData = const AdsData(
    admobData: AdmobData(
      bannerIds: [],
      interIds: [],
      nativeIds: [],
      rewardIds: [],
      openAdsId: '',
    ),
  );
  AdsBase activeNetwork = NoAdsNetwork();
  bool _isInitialized = false;
  int _interstitialCounter = 0;

  /// Whether [init] has completed.
  bool get isInitialized => _isInitialized;

  /// Initialize the AdMob Manager with configuration [data].
  Future<void> init({
    required AdsData data,
    List<String>? testDevices,
    bool enableAppOpenOnResume = true,
  }) async {
    if (_isInitialized) return;

    adsData = data;

    if (adsData.settings.isAdFree) {
      activeNetwork = NoAdsNetwork();
    } else {
      activeNetwork = AdmobNetwork(adsData.admobData, testDevices: testDevices);
    }

    await activeNetwork.init();

    // Preload ads if enabled
    if (!adsData.settings.isAdFree) {
      if (adsData.settings.enableInterstitials) {
        activeNetwork.loadInterstitialAd();
      }
      if (adsData.settings.enableRewarded) {
        activeNetwork.loadRewardedAd();
      }
      if (adsData.settings.enableAppOpen) {
        await activeNetwork.loadAppOpenAd();
        if (enableAppOpenOnResume) {
          AppLifecycleObserver().startListening();
        }
      }
    }

    _isInitialized = true;
    AdLogger.log('MultiAdsManager initialized successfully.');
  }

  /// Show Interstitial Ad respecting frequency interval setting.
  void showInterstitialAd({VoidCallback? onAdDismissed, VoidCallback? onAdFailed}) {
    if (!_isInitialized || adsData.settings.isAdFree || !adsData.settings.enableInterstitials) {
      onAdDismissed?.call();
      return;
    }

    _interstitialCounter++;
    if (_interstitialCounter % adsData.settings.interInterval == 0) {
      activeNetwork.showInterstitialAd(
        onAdDismissed: onAdDismissed,
        onAdFailed: onAdFailed,
      );
    } else {
      onAdDismissed?.call();
    }
  }

  /// Show Rewarded Ad.
  void showRewardedAd({
    required Function(dynamic item) onUserEarnedReward,
    VoidCallback? onAdDismissed,
  }) {
    if (!_isInitialized || adsData.settings.isAdFree || !adsData.settings.enableRewarded) {
      onUserEarnedReward(null);
      onAdDismissed?.call();
      return;
    }

    activeNetwork.showRewardedAd(
      onUserEarnedReward: onUserEarnedReward,
      onAdDismissed: onAdDismissed,
    );
  }

  /// Show App Open Ad manually or via lifecycle.
  void showAppOpenAdIfAvailable() {
    if (!_isInitialized || adsData.settings.isAdFree || !adsData.settings.enableAppOpen) {
      return;
    }
    activeNetwork.showAdIfAvailableOpenAds();
  }

  /// Toggle Ad-Free mode dynamically (e.g. after In-App Purchase).
  void setAdFreeMode(bool isAdFree) {
    adsData = AdsData(
      admobData: adsData.admobData,
      settings: SettingsData(
        enableBanners: !isAdFree,
        enableInterstitials: !isAdFree,
        enableNative: !isAdFree,
        enableRewarded: !isAdFree,
        enableAppOpen: !isAdFree,
        isAdFree: isAdFree,
      ),
    );

    if (isAdFree) {
      activeNetwork.dispose();
      activeNetwork = NoAdsNetwork();
      AppLifecycleObserver().stopListening();
      AdLogger.log('Switched to Ad-Free Mode.');
    }
  }

  /// Dispose resources.
  void dispose() {
    activeNetwork.dispose();
    AppLifecycleObserver().stopListening();
    _isInitialized = false;
  }
}
