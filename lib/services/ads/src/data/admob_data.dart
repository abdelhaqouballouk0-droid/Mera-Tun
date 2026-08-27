/// Holds AdMob Ad Unit IDs for various ad types.
class AdmobData {
  final List<String> bannerIds;
  final List<String> interIds;
  final List<String> nativeIds;
  final List<String> rewardIds;
  final String openAdsId;

  const AdmobData({
    required this.bannerIds,
    required this.interIds,
    required this.nativeIds,
    required this.rewardIds,
    required this.openAdsId,
  });

  /// Factory constructor for Google official test ad unit IDs.
  factory AdmobData.test() {
    return const AdmobData(
      bannerIds: ['ca-app-pub-3940256099942544/6300978111'],
      interIds: ['ca-app-pub-3940256099942544/1033173712'],
      nativeIds: ['ca-app-pub-3940256099942544/2247696110'],
      rewardIds: ['ca-app-pub-3940256099942544/5224354917'],
      openAdsId: 'ca-app-pub-3940256099942544/9257395921',
    );
  }

  factory AdmobData.fromJson(Map<String, dynamic> json) {
    return AdmobData(
      bannerIds: List<String>.from(json['bannerIds'] ?? []),
      interIds: List<String>.from(json['interIds'] ?? json['interstitialIds'] ?? []),
      nativeIds: List<String>.from(json['nativeIds'] ?? []),
      rewardIds: List<String>.from(json['rewardIds'] ?? json['rewardedIds'] ?? []),
      openAdsId: json['openAdsId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerIds': bannerIds,
      'interIds': interIds,
      'nativeIds': nativeIds,
      'rewardIds': rewardIds,
      'openAdsId': openAdsId,
    };
  }
}
