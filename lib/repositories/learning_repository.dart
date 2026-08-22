import 'dart:convert';

import '../models/learning_path.dart';
import '../services/local_store.dart';

class LearningRepository {
  LearningRepository(this._store);

  static const _storageKey = 'learning_paths_v1';
  final LocalStore _store;

  Future<List<LearningPath>> load() async {
    final raw = await _store.read(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final items = jsonDecode(raw) as List<Object?>;
      return items
          .map((item) => LearningPath.fromJson(item! as Map<String, Object?>))
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<void> save(List<LearningPath> paths) async {
    await _store.write(
      _storageKey,
      jsonEncode(paths.map((path) => path.toJson()).toList()),
    );
  }
}
