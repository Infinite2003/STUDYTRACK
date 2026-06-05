import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorage {
  static const String notificationsKey = "notifications_enabled";
  static const String darkModeKey = "dark_mode";
  static const String reminderHoursKey = "reminder_hours";

  Future<void> saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(notificationsKey, value);
  }

  Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(notificationsKey) ?? true;
  }

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(darkModeKey, value);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(darkModeKey) ?? false;
  }

  Future<void> saveReminderHours(int hours) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(reminderHoursKey, hours);
  }

  Future<int> getReminderHours() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(reminderHoursKey) ?? 24;
  }
}