import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../core/app_strings.dart';
import '../../core/theme.dart';
import '../../models/learning_path.dart';
import '../../widgets/page_header.dart';
import '../../widgets/progress_ring.dart';

Future<bool> showCreatePathSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => const _PathEditorSheet(),
  );
  return result ?? false;
}

class JourneysPage extends StatelessWidget {
  const JourneysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paths = context.watch<AppState>().paths;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            children: [
              const PageHeader(
                title: AppStrings.journeys,
                subtitle: AppStrings.homeIntro,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: paths.isEmpty
                    ? const _JourneysEmpty()
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 96),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: paths.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _PathCard(path: paths[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newJourney',
        onPressed: () => showCreatePathSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.startJourney),
      ),
    );
  }
}

class _JourneysEmpty extends StatelessWidget {
  const _JourneysEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.route_rounded, size: 60, color: AppTheme.violet),
            const SizedBox(height: 16),
            Text(
              AppStrings.noJourneysTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(AppStrings.noJourneysBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({required this.path});
  final LearningPath path;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => JourneyDetailPage(pathId: path.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              ProgressRing(value: path.progress),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      path.topic,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      path.goal,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _PathEditorSheet extends StatefulWidget {
  const _PathEditorSheet({this.path});
  final LearningPath? path;

  @override
  State<_PathEditorSheet> createState() => _PathEditorSheetState();
}

class _PathEditorSheetState extends State<_PathEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _topic;
  late final TextEditingController _goal;

  @override
  void initState() {
    super.initState();
    _topic = TextEditingController(text: widget.path?.topic);
    _goal = TextEditingController(text: widget.path?.goal);
  }

  @override
  void dispose() {
    _topic.dispose();
    _goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.path == null
                    ? AppStrings.newJourney
                    : AppStrings.editJourney,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('topicField'),
                controller: _topic,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: AppStrings.topicLabel,
                  hintText: AppStrings.topicHint,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.requiredField;
                  }
                  if (value.trim().length < 3) return AppStrings.topicTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('goalField'),
                controller: _goal,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: AppStrings.goalLabel,
                  hintText: AppStrings.goalHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? AppStrings.requiredField
                    : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('savePathButton'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final state = context.read<AppState>();
                  if (widget.path == null) {
                    await state.createPath(_topic.text, _goal.text);
                  } else {
                    await state.updatePath(
                      widget.path!.copyWith(
                        topic: _topic.text,
                        goal: _goal.text,
                      ),
                    );
                  }
                  if (context.mounted) Navigator.pop(context, true);
                },
                child: Text(
                  widget.path == null ? AppStrings.create : AppStrings.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JourneyDetailPage extends StatelessWidget {
  const JourneyDetailPage({super.key, required this.pathId});
  final String pathId;

  @override
  Widget build(BuildContext context) {
    final paths = context.watch<AppState>().paths;
    final matches = paths.where((item) => item.id == pathId);
    if (matches.isEmpty) return const SizedBox.shrink();
    final path = matches.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(path.topic),
        actions: [
          IconButton(
            tooltip: AppStrings.editJourney,
            onPressed: () => showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              useSafeArea: true,
              builder: (_) => _PathEditorSheet(path: path),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value != 'delete') return;
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text(AppStrings.deleteJourney),
                  content: const Text(AppStrings.deleteConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text(AppStrings.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text(AppStrings.delete),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await context.read<AppState>().deletePath(path.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'delete',
                child: Text(AppStrings.deleteJourney),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ProgressRing(value: path.progress, size: 68),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.progress,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(path.goal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (path.isComplete)
            const _CompletionCard()
          else ...[
            Text(
              AppStrings.currentChallenge,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            _CurrentChallenge(path: path, challenge: path.currentChallenge!),
          ],
          const SizedBox(height: 22),
          Text(
            AppStrings.upcomingChallenges,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          for (final challenge in path.challenges)
            _ChallengeRow(
              challenge: challenge,
              complete: path.completedChallengeIds.contains(challenge.id),
            ),
        ],
      ),
    );
  }
}

class _CurrentChallenge extends StatelessWidget {
  const _CurrentChallenge({required this.path, required this.challenge});
  final LearningPath path;
  final LearningChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.indigo,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bolt_rounded, color: AppTheme.gold),
          const SizedBox(height: 12),
          Text(
            challenge.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            challenge.instruction,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFECE7FF)),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.read<AppState>().completeChallenge(
              path.id,
              challenge.id,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.coral,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.check_rounded),
            label: const Text(AppStrings.done),
          ),
        ],
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  const _ChallengeRow({required this.challenge, required this.complete});
  final LearningChallenge challenge;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: CircleAvatar(
          backgroundColor: complete
              ? const Color(0xFFE5F6E9)
              : const Color(0xFFF0ECF8),
          child: Icon(
            complete ? Icons.check_rounded : Icons.circle_outlined,
            color: complete ? Colors.green.shade700 : AppTheme.violet,
          ),
        ),
        title: Text(challenge.title),
        subtitle: complete ? const Text(AppStrings.completed) : null,
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2D3),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppTheme.coral,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.allDone,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          const Text(AppStrings.allDoneBody, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
