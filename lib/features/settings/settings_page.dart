import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_config.dart';
import '../../app/app_state.dart';
import '../../core/app_strings.dart';
import '../../core/theme.dart';
import '../../services/platform_service.dart';
import '../../widgets/page_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    final opened = uri != null && await PlatformService.openExternalUrl(url);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.openLinkError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          children: [
            const PageHeader(title: AppStrings.settings),
            const SizedBox(height: 22),
            const _SectionLabel(AppStrings.general),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.language_rounded),
                    title: Text(AppStrings.language),
                    subtitle: Text(AppStrings.arabic),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text(AppStrings.version),
                    subtitle: const Text(
                      '${AppConfig.version} (${AppConfig.buildNumber})',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel(AppStrings.aiPrivacy),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.shield_outlined),
                    title: const Text(AppStrings.aiPrivacy),
                    subtitle: Text(
                      state.hasAiConsent
                          ? AppStrings.aiConsentGranted
                          : AppStrings.aiConsentNotGranted,
                    ),
                  ),
                  if (state.hasAiConsent) ...[
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.no_accounts_outlined),
                      title: const Text(AppStrings.revokeConsent),
                      textColor: Theme.of(context).colorScheme.error,
                      iconColor: Theme.of(context).colorScheme.error,
                      onTap: () => _revoke(context),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel(AppStrings.support),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text(AppStrings.privacy),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => _open(context, AppConfig.privacyPolicyUrl),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.support_agent_rounded),
                    title: const Text(AppStrings.support),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => _open(context, AppConfig.supportUrl),
                  ),
                  if (AppConfig.termsUrl.isNotEmpty) ...[
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text(AppStrings.terms),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                      onTap: () => _open(context, AppConfig.termsUrl),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel(AppStrings.about),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/app_icon.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(child: Text(AppStrings.aboutBody)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _revoke(BuildContext context) async {
    final state = context.read<AppState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.revokeConsent),
        content: const Text(AppStrings.revokeConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(AppStrings.revokeConsent),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.revokeAiConsent();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppTheme.violet,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
