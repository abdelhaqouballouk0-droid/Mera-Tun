import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../core/app_strings.dart';
import '../../core/theme.dart';
import '../../widgets/page_header.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          children: [
            PageHeader(
              title: AppStrings.insights,
              subtitle: AppStrings.todayEffort,
            ),
            const SizedBox(height: 22),
            if (state.paths.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.insights_rounded,
                        size: 52,
                        color: AppTheme.violet,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.emptyInsights,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              _ProgressHero(value: state.overallProgress),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      value: '${state.completedSteps}',
                      label: AppStrings.stepsDone,
                      icon: Icons.task_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Metric(
                      value: '${state.completedPaths}',
                      label: AppStrings.pathsCompleted,
                      icon: Icons.emoji_events_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFFFE7B0),
                        child: Icon(Icons.flag_rounded, color: AppTheme.coral),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.nextMilestone,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(AppStrings.milestoneBody),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressHero extends StatelessWidget {
  const _ProgressHero({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.indigo,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: 9,
                  strokeCap: StrokeCap.round,
                  color: AppTheme.coral,
                  backgroundColor: const Color(0xFF49318E),
                ),
                Text(
                  '${(value * 100).round()}${AppStrings.percentSign}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              AppStrings.overallProgress,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.violet),
            const SizedBox(height: 14),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
