import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String userData = "userData";
  static const String firebaseBackgroundNotificationData = "firebaseBackgroundNotificationData";

  static Future<String?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userData);
  }

  static Future<bool> setUserData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userData, value);
  }

  static Future<String?> getBackgroundNotificationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebaseBackgroundNotificationData);
  }

  static Future<bool> setBackgroundNotificationData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firebaseBackgroundNotificationData, value);
  }

  static Future<bool> clearPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }
}
