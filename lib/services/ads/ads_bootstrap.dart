import 'dart:convert';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:http/http.dart' as http;

import '../../app/app_config.dart';
import 'ads.dart';

/// Initializes [MultiAdsManager] using AdMob IDs.
///
/// Tries [AppConfig.adsRemoteConfigUrl] first (a JSON file such as
/// config/ads_config.json hosted on Google Drive) so ad unit IDs — and
/// whether ads run at all (its `isAdFree`/`enable*` fields) — can be
/// changed without shipping a new app build; falls back to the local IDs
/// and [AppConfig.adsEnabled] whenever the remote fetch fails or isn't
/// configured. The remote value is only picked up on app start (no live
/// polling), so a toggle in the JSON takes effect on the next launch.
/// Call once from `main()` before `runApp`.
///
/// No-ops on web: `google_mobile_ads` only supports Android/iOS, and this
/// app also ships a web build (see lib/services/*_web.dart).
Future<void> initAds() async {
  if (kIsWeb) return;

  final isIos = defaultTargetPlatform == TargetPlatform.iOS;

  await MultiAdsManager.instance.init(
    data: await _resolveAdsData(isIos),
    enableAppOpenOnResume: true,
  );
}

Future<AdsData> _resolveAdsData(bool isIos) async {
  final local = AdsData(
    admobData: _localAdmobData(isIos),
    settings: SettingsData(
      interInterval: AppConfig.interstitialChallengeInterval,
      isAdFree: !AppConfig.adsEnabled,
    ),
  );

  final url = AppConfig.adsRemoteConfigUrl;
  if (url.isEmpty) return local;

  try {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode != 200) return local;

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return local;

    final platformJson = decoded[isIos ? 'ios' : 'android'];
    if (platformJson is! Map<String, dynamic>) return local;

    return AdsData.fromJson(platformJson);
  } catch (_) {
    // Offline, Drive unreachable, rate-limited, malformed JSON, etc. —
    // never let a bad remote config break ad loading.
    return local;
  }
}

AdmobData _localAdmobData(bool isIos) => AdmobData(
  bannerIds: [
    isIos ? AppConfig.admobBannerIdIos : AppConfig.admobBannerIdAndroid,
  ],
  interIds: [
    isIos
        ? AppConfig.admobInterstitialIdIos
        : AppConfig.admobInterstitialIdAndroid,
  ],
  nativeIds: [
    isIos ? AppConfig.admobNativeIdIos : AppConfig.admobNativeIdAndroid,
  ],
  rewardIds: [
    isIos ? AppConfig.admobRewardedIdIos : AppConfig.admobRewardedIdAndroid,
  ],
  openAdsId:
      isIos ? AppConfig.admobAppOpenIdIos : AppConfig.admobAppOpenIdAndroid,
);
