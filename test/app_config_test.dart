import 'package:flutter_test/flutter_test.dart';
import 'package:tryit/app/app_config.dart';

void main() {
  test('public runtime configuration is structurally valid', () {
    expect(AppConfig.bundleId, matches(r'^[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$'));
    expect(AppConfig.version, matches(r'^\d+\.\d+\.\d+$'));
    expect(Uri.parse(AppConfig.groqProxyUrl).scheme, 'https');
    expect(Uri.parse(AppConfig.privacyPolicyUrl).scheme, 'https');
    expect(AppConfig.revenueCatEnabled, isFalse);
  });

  test('placeholder external endpoints remain a release blocker', () {
    expect(
      AppConfig.releaseConfigurationIssues(),
      containsAll(<String>[
        'GROQ_PROXY_URL',
        'PRIVACY_POLICY_URL',
        'SUPPORT_URL',
      ]),
    );
  });
}
