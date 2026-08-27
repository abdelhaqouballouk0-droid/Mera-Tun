class AppConfig {
  const AppConfig._();

  static const appName = 'Mera Tune';
  static const language = 'ar';
  static const bundleId = 'com.meratun.app';
  static const version = '1.0.0';
  static const buildNumber = '1';
  static const appIdea =
      'مساعد للتعلّم بالممارسة يحوّل ما تريد تعلّمه إلى تحديات صغيرة وتفاعلية.';

  static const privacyPolicyUrl = 'https://example.com/privacy';
  static const supportUrl = 'https://example.com/support';
  static const termsUrl = '';

  static const aiEnabled = true;
  static const groqDirectUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const groqApiKey = String.fromEnvironment('GROQ_API_KEY');
  static const groqModel = 'openai/gpt-oss-120b';
  static const aiConsentVersion = '1';
  static const revenueCatEnabled = false;

  // AdMob (via the vendored multi_ads_admob module, lib/services/ads/).
  // Real IDs from the publisher account (pub-1950848698072572) are used
  // where already created in the AdMob console; anything not created yet
  // falls back to Google's public test ID for that slot (safe placeholder,
  // never a real ad unit ID by accident). Replace the remaining `// TODO`
  // entries as you create the corresponding ad units.
  // Disabled: no ads for this release. initAds() no-ops entirely and the
  // banner/interstitial widgets render nothing — set back to true to
  // re-enable once ready to ship ads again.
  static const adsEnabled = false;
  static const admobAndroidAppId = 'ca-app-pub-1950848698072572~7085690584';
  static const admobIosAppId = 'ca-app-pub-1950848698072572~2681637643';

  static const admobBannerIdAndroid = 'ca-app-pub-1950848698072572/9739774080';
  static const admobBannerIdIos = 'ca-app-pub-1950848698072572/7722211330';

  static const admobInterstitialIdAndroid = 'ca-app-pub-1950848698072572/5417385691';
  static const admobInterstitialIdIos = 'ca-app-pub-1950848698072572/9773659601';

  // Not wired into any screen yet — kept for future use.
  // TODO: replace with real ad unit IDs once created and used in the UI.
  static const admobRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const admobRewardedIdIos = 'ca-app-pub-3940256099942544/1712485313';
  static const admobNativeIdAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const admobNativeIdIos = 'ca-app-pub-3940256099942544/3986624511';
  static const admobAppOpenIdAndroid = 'ca-app-pub-3940256099942544/9257395921';
  static const admobAppOpenIdIos = 'ca-app-pub-3940256099942544/5662855259';

  // Show an interstitial every N completed challenges.
  static const interstitialChallengeInterval = 3;

  // Optional remote override for ad unit IDs (config/ads_config.json in the
  // repo root, uploaded to Google Drive as "Anyone with the link"). File ID
  // 1iU19zP5aNf3rM0_GFkKtpQNRreEMuWF_ — override with --dart-define if you
  // re-upload to a different file/host.
  // Fetched once at startup with a short timeout; on any failure (offline,
  // Drive unavailable, malformed JSON) the app silently falls back to the
  // IDs above, so a bad/missing remote config can never break ads.
  static const adsRemoteConfigUrl = String.fromEnvironment(
    'ADS_REMOTE_CONFIG_URL',
    defaultValue:
        'https://drive.google.com/uc?export=download&id=1iU19zP5aNf3rM0_GFkKtpQNRreEMuWF_',
  );

  static List<String> releaseConfigurationIssues() {
    final issues = <String>[];
    if (aiEnabled && groqApiKey.isEmpty) {
      issues.add('GROQ_API_KEY');
    }
    for (final entry in {
      'PRIVACY_POLICY_URL': privacyPolicyUrl,
      'SUPPORT_URL': supportUrl,
    }.entries) {
      final uri = Uri.tryParse(entry.value);
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host.isEmpty ||
          uri.host.endsWith('example.com')) {
        issues.add(entry.key);
      }
    }
    return issues;
  }
}
