import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../multi_ads_manager.dart';
import '../networks/ads_base.dart';

/// Reusable Widget for displaying AdMob Banner Ads in your UI.
class AdmobBannerWidget extends StatefulWidget {
  final Widget? loadingWidget;
  final EdgeInsetsGeometry margin;

  const AdmobBannerWidget({
    super.key,
    this.loadingWidget,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  State<AdmobBannerWidget> createState() => _AdmobBannerWidgetState();
}

class _AdmobBannerWidgetState extends State<AdmobBannerWidget> {
  final Key _bannerKey = UniqueKey();
  WrappedBannerAd<BannerAd>? _wrappedBannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    if (!MultiAdsManager.instance.adsData.settings.enableBanners ||
        MultiAdsManager.instance.adsData.settings.isAdFree) {
      return;
    }

    _wrappedBannerAd = MultiAdsManager.instance.activeNetwork.loadBannerAd(
      () {
        if (mounted) {
          setState(() {
            _isLoaded = true;
          });
        }
      },
      _bannerKey,
    ) as WrappedBannerAd<BannerAd>?;
  }

  @override
  Widget build(BuildContext context) {
    if (MultiAdsManager.instance.adsData.settings.isAdFree ||
        !MultiAdsManager.instance.adsData.settings.enableBanners) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _wrappedBannerAd != null && _wrappedBannerAd!.isReady) {
      return Container(
        margin: widget.margin,
        width: _wrappedBannerAd!.bannerAd.size.width.toDouble(),
        height: _wrappedBannerAd!.bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _wrappedBannerAd!.bannerAd),
      );
    }

    return widget.loadingWidget ?? const SizedBox.shrink();
  }

  @override
  void dispose() {
    _wrappedBannerAd?.bannerAd.dispose();
    super.dispose();
  }
}
