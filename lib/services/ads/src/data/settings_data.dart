/// Holds configuration settings for ad orchestration.
class SettingsData {
  final bool enableBanners;
  final bool enableInterstitials;
  final bool enableNative;
  final bool enableRewarded;
  final bool enableAppOpen;
  final int interInterval; // Interval counter between showing interstitial ads
  final bool isAdFree; // User purchased premium / remove ads

  const SettingsData({
    this.enableBanners = true,
    this.enableInterstitials = true,
    this.enableNative = true,
    this.enableRewarded = true,
    this.enableAppOpen = true,
    this.interInterval = 1,
    this.isAdFree = false,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      enableBanners: json['enableBanners'] ?? true,
      enableInterstitials: json['enableInterstitials'] ?? true,
      enableNative: json['enableNative'] ?? true,
      enableRewarded: json['enableRewarded'] ?? true,
      enableAppOpen: json['enableAppOpen'] ?? true,
      interInterval: json['interInterval'] ?? 1,
      isAdFree: json['isAdFree'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableBanners': enableBanners,
      'enableInterstitials': enableInterstitials,
      'enableNative': enableNative,
      'enableRewarded': enableRewarded,
      'enableAppOpen': enableAppOpen,
      'interInterval': interInterval,
      'isAdFree': isAdFree,
    };
  }
}
