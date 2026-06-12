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
    final prefs = context.watch<PreferencesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ── NOTIFICACIONES ──────────────────────────
          _SectionHeader('Notificaciones'),
          SwitchListTile(
            title: const Text('Notificaciones activadas'),
            subtitle: const Text('Recibir recordatorios de tareas'),
            secondary: const Icon(Icons.notifications),
            value: prefs.notificationsEnabled,
            onChanged: prefs.setNotifications,
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Anticipación del recordatorio'),
            subtitle: Text('${prefs.reminderHours} horas antes del vencimiento'),
          ),
          Slider(
            min: 1,
            max: 72,
            divisions: 71,
            value: prefs.reminderHours.toDouble(),
            label: '${prefs.reminderHours} h',
            onChanged: prefs.setReminderHours,
          ),

          const Divider(),

          // ── CALENDARIO ──────────────────────────────
          _SectionHeader('Calendario'),
          SwitchListTile(
            title: const Text('Semana empieza el lunes'),
            subtitle: const Text('Afecta la vista del calendario'),
            secondary: const Icon(Icons.calendar_month),
            value: prefs.startOnMonday,
            onChanged: prefs.setStartOnMonday,
          ),
          SwitchListTile(
            title: const Text('Mostrar tareas completadas'),
            subtitle: const Text('Incluir completadas en el calendario'),
            secondary: const Icon(Icons.check_circle_outline),
            value: prefs.showCompletedInCalendar,
            onChanged: prefs.setShowCompletedInCalendar,
          ),

          const Divider(),

          // ── TAREAS ──────────────────────────────────
          _SectionHeader('Tareas'),
          ListTile(
            leading: const Icon(Icons.sort),
            title: const Text('Ordenar tareas por'),
            subtitle: Text(
              prefs.sortBy == 'date' ? 'Fecha límite' : 'Fecha de creación',
            ),
          ),
          RadioListTile<String>(
            title: const Text('Fecha límite'),
            secondary: const Icon(Icons.event),
            value: 'date',
            groupValue: prefs.sortBy,
            onChanged: (v) => prefs.setSortBy(v!),
          ),
          RadioListTile<String>(
            title: const Text('Fecha de creación'),
            secondary: const Icon(Icons.add_circle_outline),
            value: 'creation',
            groupValue: prefs.sortBy,
            onChanged: (v) => prefs.setSortBy(v!),
          ),

          const Divider(),

          // ── APARIENCIA (secundario) ─────────────────
          _SectionHeader('Apariencia'),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            secondary: const Icon(Icons.dark_mode),
            value: prefs.darkMode,
            onChanged: prefs.setDarkMode,
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Las preferencias se guardan automáticamente.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}