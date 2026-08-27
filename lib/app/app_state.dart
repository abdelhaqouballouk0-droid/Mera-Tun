import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/app_strings.dart';
import '../models/chat_message.dart';
import '../models/learning_path.dart';
import '../repositories/learning_repository.dart';
import '../services/ai_service.dart';
import '../services/local_store.dart';
import 'app_config.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this._repository,
    required this._store,
    required this._aiService,
  });

  static const _consentKey = 'ai_consent_version';
  static const _chatKey = 'ai_chat_v1';
  static const _languageKey = 'app_language';
  final LearningRepository _repository;
  final LocalStore _store;
  final AiService _aiService;

  List<LearningPath> _paths = [];
  List<ChatMessage> _messages = [];
  bool _initialized = false;
  bool _sending = false;
  bool _hasAiConsent = false;
  String? _chatError;
  String? _lastFailedPrompt;

  List<LearningPath> get paths => List.unmodifiable(_paths);
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get initialized => _initialized;
  bool get isSending => _sending;
  bool get hasAiConsent => _hasAiConsent;
  bool get canUseAi => AppConfig.aiEnabled && _hasAiConsent;
  AppLanguage get language => AppStrings.currentLanguage;
  String? get chatError => _chatError;
  int get completedSteps => _paths.fold(
    0,
    (total, path) => total + path.completedChallengeIds.length,
  );
  int get completedPaths => _paths.where((path) => path.isComplete).length;
  double get overallProgress {
    final all = _paths.fold(0, (total, path) => total + path.challenges.length);
    return all == 0 ? 0 : completedSteps / all;
  }

  Future<void> initialize() async {
    _paths = await _repository.load();
    final storedLanguage = await _store.read(_languageKey);
    AppStrings.setLanguage(
      storedLanguage == 'en' ? AppLanguage.en : AppLanguage.ar,
    );
    _hasAiConsent =
        await _store.read(_consentKey) == AppConfig.aiConsentVersion;
    final rawChat = await _store.read(_chatKey);
    if (rawChat != null) {
      try {
        final items = jsonDecode(rawChat) as List<Object?>;
        _messages = items
            .map((item) => ChatMessage.fromJson(item! as Map<String, Object?>))
            .take(12)
            .toList();
      } on FormatException {
        _messages = [];
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<LearningPath> createPath(String topic, String goal) async {
    final path = LearningPath.create(topic: topic, goal: goal);
    _paths = [path, ..._paths];
    await _persistPaths();
    return path;
  }

  Future<void> updatePath(LearningPath updated) async {
    _paths = [
      for (final path in _paths)
        if (path.id == updated.id) updated else path,
    ];
    await _persistPaths();
  }

  Future<void> deletePath(String id) async {
    _paths = _paths.where((path) => path.id != id).toList();
    await _persistPaths();
  }

  Future<void> completeChallenge(String pathId, String challengeId) async {
    final path = _paths.firstWhere((item) => item.id == pathId);
    final completed = {...path.completedChallengeIds, challengeId};
    await updatePath(path.copyWith(completedChallengeIds: completed));
  }

  Future<void> _persistPaths() async {
    await _repository.save(_paths);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (language == AppStrings.currentLanguage) return;
    AppStrings.setLanguage(language);
    await _store.write(_languageKey, language == AppLanguage.en ? 'en' : 'ar');
    notifyListeners();
  }

  Future<void> acceptAiConsent() async {
    _hasAiConsent = true;
    await _store.write(_consentKey, AppConfig.aiConsentVersion);
    notifyListeners();
  }

  Future<void> revokeAiConsent() async {
    _hasAiConsent = false;
    _messages = [];
    _chatError = null;
    await _store.remove(_consentKey);
    await _store.remove(_chatKey);
    notifyListeners();
  }

  Future<void> clearChat() async {
    _messages = [];
    _chatError = null;
    await _store.remove(_chatKey);
    notifyListeners();
  }

  Future<void> sendMessage(String prompt) async {
    final trimmed = prompt.trim();
    if (!canUseAi || trimmed.isEmpty || _sending) return;
    final message = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      createdAt: DateTime.now(),
    );
    _messages = [..._messages, message].takeLast(12);
    _sending = true;
    _chatError = null;
    _lastFailedPrompt = null;
    notifyListeners();
    try {
      final reply = await _aiService.reply(_messages);
      _messages = [
        ..._messages,
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: reply,
          isUser: false,
          createdAt: DateTime.now(),
        ),
      ].takeLast(12);
      await _persistChat();
    } on AiException catch (error) {
      _chatError = switch (error.failure) {
        AiFailure.offline => AppStrings.aiOffline,
        AiFailure.timeout => AppStrings.aiTimeout,
        AiFailure.rateLimited => AppStrings.aiRateLimit,
        AiFailure.malformed => AppStrings.aiMalformed,
        AiFailure.server => AppStrings.aiGenericError,
      };
      _lastFailedPrompt = trimmed;
    } catch (_) {
      _chatError = AppStrings.aiGenericError;
      _lastFailedPrompt = trimmed;
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  Future<void> retryLastMessage() async {
    final prompt = _lastFailedPrompt;
    if (prompt == null) return;
    if (_messages.isNotEmpty &&
        _messages.last.isUser &&
        _messages.last.text == prompt) {
      _messages = _messages.sublist(0, _messages.length - 1);
    }
    await sendMessage(prompt);
  }

  Future<void> _persistChat() async {
    await _store.write(
      _chatKey,
      jsonEncode(_messages.map((message) => message.toJson()).toList()),
    );
  }
}

extension<T> on Iterable<T> {
  List<T> takeLast(int count) {
    final items = toList();
    return items.length <= count ? items : items.sublist(items.length - count);
  }
}
