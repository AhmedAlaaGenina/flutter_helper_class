import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    }
    return false;
  }

  static Future<bool> remove({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clear() async {
    return await sharedPreferences.clear();
  }
}
