import 'package:web/web.dart' as web;

import 'local_store.dart';

LocalStore createLocalStore() => BrowserLocalStore();

class BrowserLocalStore implements LocalStore {
  @override
  Future<String?> read(String key) async => web.window.localStorage.getItem(key);

  @override
  Future<void> write(String key, String value) async {
    web.window.localStorage.setItem(key, value);
  }

  @override
  Future<void> remove(String key) async {
    web.window.localStorage.removeItem(key);
  }
}
