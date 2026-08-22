import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../app/app_config.dart';
import '../models/chat_message.dart';
import '../models/learning_path.dart';
import '../services/local_store.dart';

const _screenshotScene = String.fromEnvironment('SCREENSHOT_SCENE');

String? screenshotSceneFromBuild() {
  if (kReleaseMode || _screenshotScene.isEmpty) return null;
  return _screenshotScene;
}

Future<void> seedScreenshotFixture(LocalStore store) async {
  if (kReleaseMode) return;

  final photography = LearningPath.create(
    topic: 'التصوير بالهاتف',
    goal: 'التقاط صور سفر أكثر وضوحاً وجمالاً',
  );
  final publicSpeaking = LearningPath.create(
    topic: 'التحدث أمام الجمهور',
    goal: 'تقديم عرض قصير بثقة وتركيز',
  );
  final sketching = LearningPath.create(
    topic: 'الرسم اليومي',
    goal: 'بناء عادة إبداعية في عشر دقائق',
  );

  final paths = [
    photography.copyWith(
      completedChallengeIds: {
        photography.challenges[0].id,
        photography.challenges[1].id,
      },
    ),
    publicSpeaking.copyWith(
      completedChallengeIds: {publicSpeaking.challenges[0].id},
    ),
    sketching.copyWith(
      completedChallengeIds: sketching.challenges
          .map((challenge) => challenge.id)
          .toSet(),
    ),
  ];
  await store.write(
    'learning_paths_v1',
    jsonEncode(paths.map((path) => path.toJson()).toList()),
  );
  await store.write('ai_consent_version', AppConfig.aiConsentVersion);

  final timestamp = DateTime(2026, 8, 17, 9, 41);
  final messages = [
    ChatMessage(
      id: 'demo-user-1',
      text: 'أريد تحدياً سريعاً لتحسين تكوين الصورة.',
      isUser: true,
      createdAt: timestamp,
    ),
    ChatMessage(
      id: 'demo-coach-1',
      text:
          'اختر مشهداً بسيطاً، ثم التقطه ثلاث مرات: مرة من مستوى العين، ومرة من زاوية منخفضة، ومرة مع ترك مساحة فارغة حول العنصر. قارن النتائج وحدد الأقوى.',
      isUser: false,
      createdAt: timestamp.add(const Duration(minutes: 1)),
    ),
    ChatMessage(
      id: 'demo-user-2',
      text: 'أعطني تلميحاً واحداً فقط.',
      isUser: true,
      createdAt: timestamp.add(const Duration(minutes: 2)),
    ),
    ChatMessage(
      id: 'demo-coach-2',
      text: 'ضع العنصر المهم قرب أحد تقاطعات شبكة الثلث.',
      isUser: false,
      createdAt: timestamp.add(const Duration(minutes: 3)),
    ),
  ];
  await store.write(
    'ai_chat_v1',
    jsonEncode(messages.map((message) => message.toJson()).toList()),
  );
}
