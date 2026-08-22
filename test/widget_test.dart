import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tryit/app/app.dart';
import 'package:tryit/app/app_state.dart';
import 'package:tryit/core/app_strings.dart';
import 'package:tryit/models/chat_message.dart';
import 'package:tryit/repositories/learning_repository.dart';
import 'package:tryit/services/ai_service.dart';

import 'test_helpers.dart';

class NoopAiService extends AiService {
  @override
  Future<String> reply(List<ChatMessage> history) async => 'تحدٍ جديد';
}

void main() {
  testWidgets('bottom navigation reaches journeys and AI consent gate', (
    tester,
  ) async {
    final store = MemoryStore();
    final state = AppState(
      repository: LearningRepository(store),
      store: store,
      aiService: NoopAiService(),
    );
    await state.initialize();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: state, child: const TryItApp()),
    );

    expect(find.text(AppStrings.appTagline), findsWidgets);
    await tester.tap(find.text(AppStrings.journeys).last);
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.text(AppStrings.coach).last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('acceptAiConsent')), findsOneWidget);
    expect(find.byKey(const Key('chatInput')), findsNothing);
  });
}
