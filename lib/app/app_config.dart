class AppConfig {
  const AppConfig._();

  static const appName = 'جرّبها';
  static const language = 'ar';
  static const bundleId = 'com.yourcompany.tryit';
  static const version = '1.0.0';
  static const buildNumber = '1';
  static const appIdea =
      'مساعد للتعلّم بالممارسة يحوّل ما تريد تعلّمه إلى تحديات صغيرة وتفاعلية.';

  static const privacyPolicyUrl = 'https://example.com/privacy';
  static const supportUrl = 'https://example.com/support';
  static const termsUrl = '';

  static const aiEnabled = true;
  static const groqProxyUrl = String.fromEnvironment(
    'GROQ_PROXY_URL',
    defaultValue: 'https://api.example.com/groq/chat',
  );
  static const groqModel = 'llama-3.3-70b-versatile';
  static const aiConsentVersion = '1';
  static const revenueCatEnabled = false;

  static List<String> releaseConfigurationIssues() {
    final issues = <String>[];
    final proxy = Uri.tryParse(groqProxyUrl);
    if (aiEnabled &&
        (proxy == null ||
            proxy.scheme != 'https' ||
            proxy.host.isEmpty ||
            proxy.host.endsWith('example.com'))) {
      issues.add('GROQ_PROXY_URL');
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
