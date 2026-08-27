import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../data/admob_data.dart';
import '../utils/ad_logger.dart';
import 'ads_base.dart';

/// Concrete AdMob network implementation using `google_mobile_ads`.
class AdmobNetwork implements AdsBase {
  final AdmobData _admobData;

  int _bannerIndex = 0;
  int _interIndex = 0;
  int _rewardIndex = 0;

  final Map<Key, WrappedBannerAd<BannerAd>> _banners = {};
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;

  int _numBannerLoadAttempts = 0;
  int _numInterstitialLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;
  final int _maxAttempts = 3;

  bool isShowingAppOpenAd = false;
  List<String> testDeviceIds = [];

  AdmobNetwork(this._admobData, {List<String>? testDevices}) {
    if (testDevices != null) {
      testDeviceIds = testDevices;
    }
  }

  @override
  Future<void> init() async {
    AdLogger.log('AdmobNetwork >> Initializing MobileAds SDK...');
    await MobileAds.instance.initialize();
    if (testDeviceIds.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testDeviceIds),
      );
    }
    AdLogger.log('AdmobNetwork >> MobileAds SDK Initialized successfully.');
  }

  // ================= BANNERS =================

  @override
  dynamic loadBannerAd(VoidCallback? onLoaded, Key key) {
    if (_admobData.bannerIds.isEmpty) {
      AdLogger.error('AdmobNetwork >> No banner IDs provided');
      return;
    }

    final adUnitId = _admobData.bannerIds[_bannerIndex % _admobData.bannerIds.length];
    _bannerIndex++;

    AdLogger.log('AdmobNetwork >> Loading Banner Ad for unit: $adUnitId');

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          AdLogger.log('AdmobNetwork >> Banner Ad loaded successfully [$key]');
          _numBannerLoadAttempts = 0;
          _banners[key]?.isReady = true;
          onLoaded?.call();
        },
        onAdFailedToLoad: (ad, err) {
          AdLogger.error('AdmobNetwork >> Failed to load banner ad [$key]: ${err.message}');
          ad.dispose();
          _banners[key]?.isReady = false;
          _numBannerLoadAttempts++;
          if (_numBannerLoadAttempts < _maxAttempts) {
            loadBannerAd(onLoaded, key);
          }
        },
      ),
    );

    _banners[key] = WrappedBannerAd(bannerAd: bannerAd, isReady: false);
    bannerAd.load();
    return _banners[key];
  }

  @override
  dynamic getBannerAd(Key key) {
    return _banners[key];
  }

  // ================= INTERSTITIALS =================

  @override
  void loadInterstitialAd() {
    if (_admobData.interIds.isEmpty) return;

    final adUnitId = _admobData.interIds[_interIndex % _admobData.interIds.length];
    _interIndex++;

    AdLogger.log('AdmobNetwork >> Loading Interstitial Ad for unit: $adUnitId');

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          AdLogger.log('AdmobNetwork >> Interstitial Ad loaded successfully');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          AdLogger.error('AdmobNetwork >> Interstitial Ad failed to load: ${error.message}');
          _interstitialAd = null;
          _numInterstitialLoadAttempts++;
          if (_numInterstitialLoadAttempts < _maxAttempts) {
            loadInterstitialAd();
          }
        },
      ),
    );
  }

  @override
  void showInterstitialAd({VoidCallback? onAdDismissed, VoidCallback? onAdFailed}) {
    if (_interstitialAd == null) {
      AdLogger.log('AdmobNetwork >> Interstitial Ad not ready. Preloading...');
      if (onAdFailed != null) {
        onAdFailed();
      } else {
        onAdDismissed?.call();
      }
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        AdLogger.log('AdmobNetwork >> Interstitial Ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        AdLogger.error('AdmobNetwork >> Interstitial Ad failed to show: ${err.message}');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        if (onAdFailed != null) {
          onAdFailed();
        } else {
          onAdDismissed?.call();
        }
      },
    );

    _interstitialAd!.show();
  }

  // ================= REWARDED =================

  @override
  void loadRewardedAd() {
    if (_admobData.rewardIds.isEmpty) return;

    final adUnitId = _admobData.rewardIds[_rewardIndex % _admobData.rewardIds.length];
    _rewardIndex++;

    AdLogger.log('AdmobNetwork >> Loading Rewarded Ad for unit: $adUnitId');

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          AdLogger.log('AdmobNetwork >> Rewarded Ad loaded successfully');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          AdLogger.error('AdmobNetwork >> Rewarded Ad failed to load: ${error.message}');
          _rewardedAd = null;
          _numRewardedLoadAttempts++;
          if (_numRewardedLoadAttempts < _maxAttempts) {
            loadRewardedAd();
          }
        },
      ),
    );
  }

  @override
  void showRewardedAd({required Function(dynamic item) onUserEarnedReward, VoidCallback? onAdDismissed}) {
    if (_rewardedAd == null) {
      AdLogger.log('AdmobNetwork >> Rewarded Ad not ready. Preloading...');
      loadRewardedAd();
      onAdDismissed?.call();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        AdLogger.log('AdmobNetwork >> Rewarded Ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        AdLogger.error('AdmobNetwork >> Rewarded Ad failed to show: ${err.message}');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdDismissed?.call();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      AdLogger.log('AdmobNetwork >> User earned reward: ${reward.amount} ${reward.type}');
      onUserEarnedReward(reward);
    });
  }

  // ================= APP OPEN ADS =================

  @override
  Future<void> loadAppOpenAd() async {
    if (_admobData.openAdsId.isEmpty) return;

    AdLogger.log('AdmobNetwork >> Loading App Open Ad...');

    AppOpenAd.load(
      adUnitId: _admobData.openAdsId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          AdLogger.log('AdmobNetwork >> App Open Ad loaded successfully');
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          AdLogger.error('AdmobNetwork >> App Open Ad failed to load: ${error.message}');
          _appOpenAd = null;
        },
      ),
    );
  }

  @override
  void showAdIfAvailableOpenAds() {
    if (_appOpenAd == null) {
      AdLogger.log('AdmobNetwork >> App Open Ad not ready. Loading for next time...');
      loadAppOpenAd();
      return;
    }

    if (isShowingAppOpenAd) {
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        isShowingAppOpenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        AdLogger.log('AdmobNetwork >> App Open Ad dismissed');
        isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        AdLogger.error('AdmobNetwork >> App Open Ad failed to show: ${error.message}');
        isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  @override
  void dispose() {
    for (var banner in _banners.values) {
      banner.bannerAd.dispose();
    }
    _banners.clear();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
  }
}
