import 'package:flutter/material.dart';
import '../../data/preferences_storage.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesStorage storage = PreferencesStorage();

  bool notificationsEnabled = true;
  bool darkMode = false;
  int reminderHours = 24;
  String sortBy = 'date';
  bool showCompletedInCalendar = true;
  bool startOnMonday = true;
  Locale locale = const Locale('es');

  Future<void> loadPreferences() async {
    notificationsEnabled = await storage.getNotifications();
    darkMode = await storage.getDarkMode();
    reminderHours = await storage.getReminderHours();
    sortBy = await storage.getSortBy();
    showCompletedInCalendar = await storage.getShowCompletedInCalendar();
    startOnMonday = await storage.getStartOnMonday();
    final localeCode = await storage.getLocale();
    locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    await storage.saveNotifications(value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    await storage.saveDarkMode(value);
    notifyListeners();
  }

  Future<void> setReminderHours(double value) async {
    reminderHours = value.toInt();
    await storage.saveReminderHours(reminderHours);
    notifyListeners();
  }

  Future<void> setSortBy(String value) async {
    sortBy = value;
    await storage.saveSortBy(value);
    notifyListeners();
  }

  Future<void> setShowCompletedInCalendar(bool value) async {
    showCompletedInCalendar = value;
    await storage.saveShowCompletedInCalendar(value);
    notifyListeners();
  }

  Future<void> setStartOnMonday(bool value) async {
    startOnMonday = value;
    await storage.saveStartOnMonday(value);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    locale = Locale(languageCode);
    await storage.saveLocale(languageCode);
    notifyListeners();
  }
}