import 'package:flutter/services.dart';

import 'local_store.dart';

LocalStore createLocalStore() => SharedPreferencesStore();

class SharedPreferencesStore implements LocalStore {
  static const _channel = MethodChannel('com.meratun.app/platform');

  @override
  Future<String?> read(String key) =>
      _channel.invokeMethod<String>('getString', key);

  @override
  Future<void> write(String key, String value) async {
    await _channel.invokeMethod<void>('setString', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<void> remove(String key) async {
    await _channel.invokeMethod<void>('remove', key);
  }
}
