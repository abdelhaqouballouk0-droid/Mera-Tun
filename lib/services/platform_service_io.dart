import 'package:flutter/services.dart';

const _channel = MethodChannel('com.meratun.app/platform');

Future<bool> openExternalUrl(String url) async {
  try {
    return await _channel.invokeMethod<bool>('openUrl', url) ?? false;
  } on PlatformException {
    return false;
  }
}
