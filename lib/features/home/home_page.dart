import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../app/app_config.dart';
import '../../core/app_strings.dart';
import '../../core/theme.dart';
import '../journeys/journeys_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenJourneys});

  final VoidCallback onOpenJourneys;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final active = state.paths.where((path) => !path.isComplete).length;
    final nextPath = state.paths.where((path) => !path.isComplete).firstOrNull;
    return SafeArea(
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            sliver: SliverList.list(
              children: [
                _BrandHeader(),
                const SizedBox(height: 22),
                _HeroCard(
                  onPressed: () async {
                    final created = await showCreatePathSheet(context);
                    if (created && context.mounted) onOpenJourneys();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.route_rounded,
                        value: '$active',
                        label: AppStrings.activeJourneys,
                        color: AppTheme.violet,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.task_alt_rounded,
                        value: '${state.completedSteps}',
                        label: AppStrings.completedSteps,
                        color: AppTheme.coral,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                if (nextPath != null)
                  _ContinueCard(
                    topic: nextPath.topic,
                    progress: nextPath.progress,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => JourneyDetailPage(pathId: nextPath.id),
                      ),
                    ),
                  )
                else
                  _EmptyCard(
                    onPressed: () async {
                      final created = await showCreatePathSheet(context);
                      if (created && context.mounted) onOpenJourneys();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/app_icon.png', width: 52, height: 52),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConfig.appName,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.indigo),
            ),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppTheme.indigo, AppTheme.violet],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3324106A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppTheme.gold,
            size: 34,
          ),
          const SizedBox(height: 22),
          Text(
            AppStrings.appTagline,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.homeIntro,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFECE7FF)),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.coral,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text(AppStrings.startJourney),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 14),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.topic,
    required this.progress,
    required this.onTap,
  });
  final String topic;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.continueLearning,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(topic, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 18),
              LinearProgressIndicator(value: progress, minHeight: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.explore_rounded, size: 42, color: AppTheme.coral),
            const SizedBox(height: 12),
            Text(
              AppStrings.noJourneysTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(AppStrings.noJourneysBody, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onPressed,
              child: const Text(AppStrings.startJourney),
            ),
          ],
        ),
      ),
    );
  }
}
