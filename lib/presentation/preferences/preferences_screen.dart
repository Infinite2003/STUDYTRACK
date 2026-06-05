import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'preferences_provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PreferencesProvider>().loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<PreferencesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferencias"),
      ),

      body: ListView(
        children: [

          SwitchListTile(
            title: const Text("Notificaciones"),
            subtitle: const Text(
              "Activar recordatorios de tareas",
            ),
            value: provider.notificationsEnabled,
            onChanged: provider.setNotifications,
          ),

          const Divider(),

          SwitchListTile(
            title: const Text("Modo oscuro"),
            subtitle: const Text(
              "Preferencia de apariencia",
            ),
            value: provider.darkMode,
            onChanged: provider.setDarkMode,
          ),

          const Divider(),

          ListTile(
            title: const Text("Horas de anticipación"),
            subtitle: Text(
              "${provider.reminderHours} horas",
            ),
          ),

          Slider(
            min: 1,
            max: 72,
            divisions: 71,
            value: provider.reminderHours.toDouble(),
            label: "${provider.reminderHours}",
            onChanged: provider.setReminderHours,
          ),
        ],
      ),
    );
  }
}