import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.preferences),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ── NOTIFICACIONES ──
          _SectionHeader(l10n.sectionNotifications),
          SwitchListTile(
            title: Text(l10n.notificationsEnabled),
            subtitle: Text(l10n.notificationsSubtitle),
            secondary: const Icon(Icons.notifications),
            value: prefs.notificationsEnabled,
            onChanged: prefs.setNotifications,
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(l10n.reminderAnticipation),
            subtitle: Text(l10n.reminderAnticipationSubtitle(prefs.reminderHours)),
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

          // ── CALENDARIO ──
          _SectionHeader(l10n.sectionCalendar),
          SwitchListTile(
            title: Text(l10n.weekStartsMonday),
            subtitle: Text(l10n.weekStartsMondaySubtitle),
            secondary: const Icon(Icons.calendar_month),
            value: prefs.startOnMonday,
            onChanged: prefs.setStartOnMonday,
          ),
          SwitchListTile(
            title: Text(l10n.showCompleted),
            subtitle: Text(l10n.showCompletedSubtitle),
            secondary: const Icon(Icons.check_circle_outline),
            value: prefs.showCompletedInCalendar,
            onChanged: prefs.setShowCompletedInCalendar,
          ),

          const Divider(),

          // ── TAREAS ──
          _SectionHeader(l10n.sectionTasks),
          ListTile(
            leading: const Icon(Icons.sort),
            title: Text(l10n.sortBy),
            subtitle: Text(
              prefs.sortBy == 'date' ? l10n.sortByDate : l10n.sortByCreation,
            ),
          ),
          RadioListTile<String>(
            title: Text(l10n.sortByDate),
            secondary: const Icon(Icons.event),
            value: 'date',
            groupValue: prefs.sortBy,
            onChanged: (v) => prefs.setSortBy(v!),
          ),
          RadioListTile<String>(
            title: Text(l10n.sortByCreation),
            secondary: const Icon(Icons.add_circle_outline),
            value: 'creation',
            groupValue: prefs.sortBy,
            onChanged: (v) => prefs.setSortBy(v!),
          ),

          const Divider(),

          // ── APARIENCIA ──
          _SectionHeader(l10n.sectionAppearance),
          SwitchListTile(
            title: Text(l10n.darkMode),
            secondary: const Icon(Icons.dark_mode),
            value: prefs.darkMode,
            onChanged: prefs.setDarkMode,
          ),

          const Divider(),

          // ── IDIOMA ──
          _SectionHeader(l10n.sectionLanguage),
          RadioListTile<String>(
            title: const Text('Español'),
            secondary: const Text('🇨🇱'),
            value: 'es',
            groupValue: prefs.locale.languageCode,
            onChanged: (v) => prefs.setLocale(v!),
          ),
          RadioListTile<String>(
            title: const Text('English'),
            secondary: const Text('🇺🇸'),
            value: 'en',
            groupValue: prefs.locale.languageCode,
            onChanged: (v) => prefs.setLocale(v!),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.preferencesAutoSave,
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