import 'package:flutter_test/flutter_test.dart';
import 'package:tryit/app/app_state.dart';
import 'package:tryit/models/chat_message.dart';
import 'package:tryit/repositories/learning_repository.dart';
import 'package:tryit/services/ai_service.dart';

import 'test_helpers.dart';

class FakeAiService extends AiService {
  @override
  Future<String> reply(List<ChatMessage> history) async => 'جرّب خطوة صغيرة.';
}

void main() {
  test('AI use is gated by persisted consent and revoke clears chat', () async {
    final store = MemoryStore();
    final state = AppState(
      repository: LearningRepository(store),
      store: store,
      aiService: FakeAiService(),
    );
    await state.initialize();

    expect(state.canUseAi, isFalse);
    await state.sendMessage('علّمني');
    expect(state.messages, isEmpty);

    await state.acceptAiConsent();
    expect(state.canUseAi, isTrue);
    await state.sendMessage('علّمني');
    expect(state.messages, hasLength(2));

    await state.revokeAiConsent();
    expect(state.canUseAi, isFalse);
    expect(state.messages, isEmpty);
  });

  test('core path workflow creates, completes, edits, and deletes', () async {
    final store = MemoryStore();
    final state = AppState(
      repository: LearningRepository(store),
      store: store,
      aiService: FakeAiService(),
    );
    await state.initialize();
    final path = await state.createPath('الرسم', 'أرسم يومياً');
    await state.completeChallenge(path.id, path.challenges.first.id);
    expect(state.completedSteps, 1);

    await state.updatePath(state.paths.single.copyWith(goal: 'أرسم بثقة'));
    expect(state.paths.single.goal, 'أرسم بثقة');

    await state.deletePath(path.id);
    expect(state.paths, isEmpty);
  });
}
