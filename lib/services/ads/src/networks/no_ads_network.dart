import 'package:flutter/material.dart';
import 'ads_base.dart';
import '../utils/ad_logger.dart';

/// No-op implementation for ad-free mode or when ads are disabled.
class NoAdsNetwork implements AdsBase {
  @override
  Future<void> init() async {
    AdLogger.log('NoAdsNetwork >> Initialized (Ads disabled)');
  }

  @override
  dynamic loadBannerAd(VoidCallback? onLoaded, Key key) {
    return null;
  }

  @override
  dynamic getBannerAd(Key key) {
    return null;
  }

  @override
  void loadInterstitialAd() {}

  @override
  void showInterstitialAd({VoidCallback? onAdDismissed, VoidCallback? onAdFailed}) {
    AdLogger.log('NoAdsNetwork >> Interstitial requested, executing callback directly');
    onAdDismissed?.call();
  }

  @override
  void loadRewardedAd() {}

  @override
  void showRewardedAd({required Function(dynamic item) onUserEarnedReward, VoidCallback? onAdDismissed}) {
    AdLogger.log('NoAdsNetwork >> Rewarded ad requested, executing reward directly');
    onUserEarnedReward(null);
    onAdDismissed?.call();
  }

  @override
  Future<void> loadAppOpenAd() async {}

  @override
  void showAdIfAvailableOpenAds() {}

  @override
  void dispose() {}
}
