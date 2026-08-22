import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/app_state.dart';
import 'repositories/learning_repository.dart';
import 'screenshots/screenshot_fixture.dart';
import 'services/ai_service.dart';
import 'services/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = SharedPreferencesStore();
  final screenshotScene = screenshotSceneFromBuild();
  if (screenshotScene != null) await seedScreenshotFixture(store);
  final state = AppState(
    repository: LearningRepository(store),
    store: store,
    aiService: AiService(),
  );
  await state.initialize();
  runApp(
    ChangeNotifierProvider.value(
      value: state,
      child: TryItApp(screenshotScene: screenshotScene),
    ),
  );
}
