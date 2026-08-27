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
      ).showSnackBar(SnackBar(content: Text(AppStrings.openLinkError)));
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
            PageHeader(title: AppStrings.settings),
            const SizedBox(height: 22),
            _SectionLabel(AppStrings.general),
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language_rounded),
                            const SizedBox(width: 32),
                            Text(AppStrings.language),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<AppLanguage>(
                          segments: [
                            ButtonSegment(
                              value: AppLanguage.ar,
                              label: Text(AppStrings.arabic),
                            ),
                            ButtonSegment(
                              value: AppLanguage.en,
                              label: Text(AppStrings.english),
                            ),
                          ],
                          selected: {state.language},
                          onSelectionChanged: (selection) =>
                              state.setLanguage(selection.first),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: Text(AppStrings.version),
                    subtitle: Text(
                      '${AppConfig.version} (${AppConfig.buildNumber})',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel(AppStrings.aiPrivacy),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.shield_outlined),
                    title: Text(AppStrings.aiPrivacy),
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
                      title: Text(AppStrings.revokeConsent),
                      textColor: Theme.of(context).colorScheme.error,
                      iconColor: Theme.of(context).colorScheme.error,
                      onTap: () => _revoke(context),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel(AppStrings.support),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(AppStrings.privacy),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => _open(context, AppConfig.privacyPolicyUrl),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.support_agent_rounded),
                    title: Text(AppStrings.support),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => _open(context, AppConfig.supportUrl),
                  ),
                  if (AppConfig.termsUrl.isNotEmpty) ...[
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text(AppStrings.terms),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                      onTap: () => _open(context, AppConfig.termsUrl),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel(AppStrings.about),
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
                    Expanded(child: Text(AppStrings.aboutBody)),
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
        title: Text(AppStrings.revokeConsent),
        content: Text(AppStrings.revokeConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.revokeConsent),
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
