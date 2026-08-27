import 'admob_data.dart';
import 'settings_data.dart';

/// Master container for AdMob configuration and settings.
class AdsData {
  final AdmobData admobData;
  final SettingsData settings;

  const AdsData({
    required this.admobData,
    this.settings = const SettingsData(),
  });

  factory AdsData.test() {
    return AdsData(
      admobData: AdmobData.test(),
      settings: const SettingsData(),
    );
  }

  factory AdsData.fromJson(Map<String, dynamic> json) {
    return AdsData(
      admobData: AdmobData.fromJson(json['admob'] ?? json['admobData'] ?? {}),
      settings: SettingsData.fromJson(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admobData': admobData.toJson(),
      'settings': settings.toJson(),
    };
  }
}
