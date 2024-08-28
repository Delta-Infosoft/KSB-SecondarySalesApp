import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static late SharedPreferences _preferences;
  static initialize() async {

    _preferences = await SharedPreferences.getInstance();
    // _preferences.clear();
  }

  static Future<void> setBool(String key, bool val) async {
    await _preferences.setBool(key, val);
  }

  static bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }

  static Future<void> setString(String key, String val) async {
    await _preferences.setString(key, val);
  }

  static String getString(String key) {
    return _preferences.getString(key) ?? '';
  }
}
