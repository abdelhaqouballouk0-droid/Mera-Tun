import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../core/app_strings.dart';
import '../../core/theme.dart';
import '../../models/chat_message.dart';
import '../../widgets/page_header.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? starter]) async {
    final text = starter ?? _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    await context.read<AppState>().sendMessage(text);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            children: [
              PageHeader(
                title: AppStrings.coachTitle,
                subtitle: AppStrings.coachIntro,
                action: state.messages.isEmpty
                    ? null
                    : IconButton(
                        tooltip: AppStrings.clearChat,
                        onPressed: () => _confirmClear(context),
                        icon: const Icon(Icons.delete_sweep_outlined),
                      ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: !state.hasAiConsent
                    ? const _ConsentCard()
                    : _Conversation(
                        controller: _scrollController,
                        messages: state.messages,
                        isSending: state.isSending,
                        error: state.chatError,
                        onStarter: _send,
                        onRetry: state.retryLastMessage,
                      ),
              ),
              if (state.hasAiConsent)
                _Composer(
                  controller: _controller,
                  enabled: !state.isSending,
                  onSend: _send,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final state = context.read<AppState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.clearChat),
        content: const Text(AppStrings.clearChatConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(AppStrings.clearChat),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.clearChat();
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9E1FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppTheme.indigo,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  AppStrings.consentTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                const Text(AppStrings.consentBody),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const Key('acceptAiConsent'),
                    onPressed: context.read<AppState>().acceptAiConsent,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text(AppStrings.consentAccept),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.consentDeclinedNotice),
                      ),
                    ),
                    child: const Text(AppStrings.consentDecline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Conversation extends StatelessWidget {
  const _Conversation({
    required this.controller,
    required this.messages,
    required this.isSending,
    required this.error,
    required this.onStarter,
    required this.onRetry,
  });

  final ScrollController controller;
  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;
  final ValueChanged<String> onStarter;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isSending && error == null) {
      return ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          const SizedBox(height: 18),
          const Icon(
            Icons.auto_awesome_rounded,
            size: 54,
            color: AppTheme.violet,
          ),
          const SizedBox(height: 12),
          for (final starter in const [
            AppStrings.starterOne,
            AppStrings.starterTwo,
            AppStrings.starterThree,
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton.icon(
                onPressed: () => onStarter(starter),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Align(
                  alignment: Alignment.centerRight,
                  child: Text(starter),
                ),
              ),
            ),
        ],
      );
    }
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.only(bottom: 14),
      itemCount:
          messages.length + (isSending ? 1 : 0) + (error == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < messages.length) return _MessageBubble(messages[index]);
        if (isSending && index == messages.length) {
          return const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          );
        }
        return Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(child: Text(error!)),
                TextButton(
                  onPressed: onRetry,
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble(this.message);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser ? AppTheme.indigo : Colors.white,
          borderRadius: BorderRadius.circular(20).copyWith(
            topRight: message.isUser ? const Radius.circular(6) : null,
            topLeft: message.isUser ? null : const Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.isUser ? AppStrings.you : AppStrings.ai,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: message.isUser
                    ? const Color(0xFFD9CFFF)
                    : AppTheme.violet,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : null,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.enabled,
    required this.onSend,
  });
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              key: const Key('chatInput'),
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: AppStrings.messageHint,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            tooltip: AppStrings.send,
            onPressed: enabled ? onSend : null,
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
        ],
      ),
    );
  }
}
