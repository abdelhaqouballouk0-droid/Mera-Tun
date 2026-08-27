import 'platform_service_stub.dart'
    if (dart.library.io) 'platform_service_io.dart'
    if (dart.library.html) 'platform_service_web.dart' as impl;

class PlatformService {
  const PlatformService._();

  static Future<bool> openExternalUrl(String url) => impl.openExternalUrl(url);
}
