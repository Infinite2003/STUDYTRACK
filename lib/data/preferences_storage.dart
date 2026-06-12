import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorage {
  static const String notificationsKey = "notifications_enabled";
  static const String darkModeKey = "dark_mode";
  static const String reminderHoursKey = "reminder_hours";
  static const String sortByKey = "sort_by"; // 'date' | 'creation'
  static const String showCompletedInCalendarKey = "show_completed_calendar";
  static const String startOnMondayKey = "start_on_monday"; 

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

  Future<void> saveSortBy(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sortByKey, value);
  }
  Future<String> getSortBy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sortByKey) ?? 'date';
  }

  Future<void> saveShowCompletedInCalendar(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(showCompletedInCalendarKey, value);
  }
  Future<bool> getShowCompletedInCalendar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(showCompletedInCalendarKey) ?? true;
  }

  Future<void> saveStartOnMonday(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(startOnMondayKey, value);
  }
  Future<bool> getStartOnMonday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(startOnMondayKey) ?? true;
  }
  
}