import 'package:flutter_test/flutter_test.dart';
import 'package:tryit/models/learning_path.dart';
import 'package:tryit/repositories/learning_repository.dart';

import 'test_helpers.dart';

void main() {
  test('learning paths round-trip with progress', () async {
    final repository = LearningRepository(MemoryStore());
    final created = LearningPath.create(
      topic: 'التصوير بالهاتف',
      goal: 'التقاط صور سفر أفضل',
    );
    final progressed = created.copyWith(
      completedChallengeIds: {created.challenges.first.id},
    );

    await repository.save([progressed]);
    final loaded = await repository.load();

    expect(loaded, hasLength(1));
    expect(loaded.single.topic, 'التصوير بالهاتف');
    expect(loaded.single.completedChallengeIds, hasLength(1));
    expect(loaded.single.progress, 0.25);
  });
}
