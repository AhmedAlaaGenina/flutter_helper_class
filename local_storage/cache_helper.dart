import 'package:shared_preferences/shared_preferences.dart';


/* =========================
   LOCAL PERSISTENCE
========================= */
// Future<void> _registerLocalPersistence() async {
//   final sharedPreferences = await SharedPreferences.getInstance();
//   const flutterSecureStorage = FlutterSecureStorage();

//   getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
//   getIt.registerLazySingleton<FlutterSecureStorage>(() => flutterSecureStorage);

//   getIt.registerLazySingleton<CacheStorage>(
//     () => CacheStorageImpl(getIt<SharedPreferences>()),
//   );

//   getIt.registerLazySingleton<SecureStorage>(
//     () => SecureStorageImpl(getIt<FlutterSecureStorage>()),
//   );
// }


abstract class CacheStorage {
  Future<void> write<T>({required String key, required T value});

  T? read<T>({required String key});

  Future<void> delete({required String key});

  Future<void> clear();

  bool containsKey({required String key});
}

class CacheStorageImpl implements CacheStorage {
  final SharedPreferences _preferences;

  CacheStorageImpl(this._preferences);

  @override
  Future<void> write<T>({
    required String key,
    required T value,
  }) async {
    if (value is String) {
      await _preferences.setString(key, value);
      return;
    }

    if (value is int) {
      await _preferences.setInt(key, value);
      return;
    }

    if (value is bool) {
      await _preferences.setBool(key, value);
      return;
    }

    if (value is double) {
      await _preferences.setDouble(key, value);
      return;
    }

    if (value is List<String>) {
      await _preferences.setStringList(key, value);
      return;
    }

    throw UnsupportedError(
      'Type ${value.runtimeType} is not supported in CacheStorage',
    );
  }

  @override
  T? read<T>({
    required String key,
  }) {
    final value = _preferences.get(key);
    return value as T?;
  }

  @override
  Future<void> delete({
    required String key,
  }) async {
    await _preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  @override
  bool containsKey({
    required String key,
  }) {
    return _preferences.containsKey(key);
  }
}
