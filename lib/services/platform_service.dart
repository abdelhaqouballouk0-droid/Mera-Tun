import 'package:flutter/services.dart';

class PlatformService {
  const PlatformService._();

  static const _channel = MethodChannel('com.yourcompany.tryit/platform');

  static Future<bool> openExternalUrl(String url) async {
    try {
      return await _channel.invokeMethod<bool>('openUrl', url) ?? false;
    } on PlatformException {
      return false;
    }
  }
}
