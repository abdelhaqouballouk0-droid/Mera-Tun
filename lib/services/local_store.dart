import 'package:flutter/services.dart';

abstract class LocalStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}

class SharedPreferencesStore implements LocalStore {
  static const _channel = MethodChannel('com.yourcompany.tryit/platform');

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
