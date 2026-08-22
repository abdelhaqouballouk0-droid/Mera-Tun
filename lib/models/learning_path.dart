import '../core/app_strings.dart';

class LearningChallenge {
  const LearningChallenge({
    required this.id,
    required this.title,
    required this.instruction,
  });

  final String id;
  final String title;
  final String instruction;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'instruction': instruction,
  };

  factory LearningChallenge.fromJson(Map<String, Object?> json) {
    return LearningChallenge(
      id: json['id']! as String,
      title: json['title']! as String,
      instruction: json['instruction']! as String,
    );
  }
}

class LearningPath {
  const LearningPath({
    required this.id,
    required this.topic,
    required this.goal,
    required this.createdAt,
    required this.challenges,
    this.completedChallengeIds = const {},
  });

  final String id;
  final String topic;
  final String goal;
  final DateTime createdAt;
  final List<LearningChallenge> challenges;
  final Set<String> completedChallengeIds;

  double get progress =>
      challenges.isEmpty ? 0 : completedChallengeIds.length / challenges.length;
  bool get isComplete =>
      challenges.isNotEmpty &&
      completedChallengeIds.length == challenges.length;
  LearningChallenge? get currentChallenge {
    for (final challenge in challenges) {
      if (!completedChallengeIds.contains(challenge.id)) return challenge;
    }
    return null;
  }

  factory LearningPath.create({required String topic, required String goal}) {
    final now = DateTime.now();
    final id = now.microsecondsSinceEpoch.toString();
    return LearningPath(
      id: id,
      topic: topic.trim(),
      goal: goal.trim(),
      createdAt: now,
      challenges: [
        LearningChallenge(
          id: '${id}_1',
          title: AppStrings.challengeOneTitle,
          instruction: AppStrings.challengeOneBody(topic.trim()),
        ),
        LearningChallenge(
          id: '${id}_2',
          title: AppStrings.challengeTwoTitle,
          instruction: AppStrings.challengeTwoBody(topic.trim()),
        ),
        LearningChallenge(
          id: '${id}_3',
          title: AppStrings.challengeThreeTitle,
          instruction: AppStrings.challengeThreeBody(topic.trim()),
        ),
        LearningChallenge(
          id: '${id}_4',
          title: AppStrings.challengeFourTitle,
          instruction: AppStrings.challengeFourBody(topic.trim()),
        ),
      ],
    );
  }

  LearningPath copyWith({
    String? topic,
    String? goal,
    Set<String>? completedChallengeIds,
  }) {
    return LearningPath(
      id: id,
      topic: topic ?? this.topic,
      goal: goal ?? this.goal,
      createdAt: createdAt,
      challenges: challenges,
      completedChallengeIds:
          completedChallengeIds ?? this.completedChallengeIds,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'topic': topic,
    'goal': goal,
    'createdAt': createdAt.toIso8601String(),
    'challenges': challenges.map((item) => item.toJson()).toList(),
    'completedChallengeIds': completedChallengeIds.toList(),
  };

  factory LearningPath.fromJson(Map<String, Object?> json) {
    return LearningPath(
      id: json['id']! as String,
      topic: json['topic']! as String,
      goal: json['goal']! as String,
      createdAt: DateTime.parse(json['createdAt']! as String),
      challenges: (json['challenges']! as List<Object?>)
          .map(
            (item) => LearningChallenge.fromJson(item! as Map<String, Object?>),
          )
          .toList(),
      completedChallengeIds: Set<String>.from(
        json['completedChallengeIds']! as List<Object?>,
      ),
    );
  }
}
