import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../multi_ads_manager.dart';
import '../utils/ad_logger.dart';

/// Reusable Widget for displaying AdMob Native Ads.
class AdmobNativeWidget extends StatefulWidget {
  final String? factoryId;
  final Widget? loadingWidget;
  final double height;

  const AdmobNativeWidget({
    super.key,
    this.factoryId,
    this.loadingWidget,
    this.height = 300,
  });

  @override
  State<AdmobNativeWidget> createState() => _AdmobNativeWidgetState();
}

class _AdmobNativeWidgetState extends State<AdmobNativeWidget> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    final adsData = MultiAdsManager.instance.adsData;
    if (!adsData.settings.enableNative || adsData.settings.isAdFree) {
      return;
    }

    if (adsData.admobData.nativeIds.isEmpty) return;

    final adUnitId = adsData.admobData.nativeIds.first;

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      factoryId: widget.factoryId ?? 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          AdLogger.log('AdmobNativeWidget >> Loaded native ad');
          if (mounted) {
            setState(() {
              _isNativeAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          AdLogger.error('AdmobNativeWidget >> Failed to load native ad: ${error.message}');
          ad.dispose();
        },
      ),
    );

    _nativeAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (MultiAdsManager.instance.adsData.settings.isAdFree ||
        !MultiAdsManager.instance.adsData.settings.enableNative) {
      return const SizedBox.shrink();
    }

    if (_isNativeAdLoaded && _nativeAd != null) {
      return SizedBox(
        height: widget.height,
        child: AdWidget(ad: _nativeAd!),
      );
    }

    return widget.loadingWidget ?? const SizedBox.shrink();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
