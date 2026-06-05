import 'package:flutter/material.dart';

import '../../data/preferences_storage.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesStorage storage = PreferencesStorage();

  bool notificationsEnabled = true;
  bool darkMode = false;
  int reminderHours = 24;

  Future<void> loadPreferences() async {
    notificationsEnabled = await storage.getNotifications();

    darkMode = await storage.getDarkMode();

    reminderHours = await storage.getReminderHours();

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
}