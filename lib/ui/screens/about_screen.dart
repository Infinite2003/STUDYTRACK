import 'package:flutter/material.dart';
import 'calendar_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / branding
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: color.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.menu_book,
                        size: 52, color: color.primary),
                  ),
                  const SizedBox(height: 12),
                  Text('STUDYTRACK',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color.primary)),
                  const SizedBox(height: 4),
                  Text('v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text('¿Qué es StudyTrack?',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'StudyTrack es una aplicación móvil diseñada para estudiantes '
              'que buscan organizar su tiempo de estudio y evitar la sobrecarga '
              'académica. Permite registrar tareas, asignar fechas límite y '
              'recibir recordatorios personalizados.',
            ),
            const SizedBox(height: 24),

            Text('Características',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._features(context),

            const SizedBox(height: 24),

            Text('Tecnologías',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Flutter',
                'Dart',
                'Hive',
                'Provider (MVVM)',
                'flutter_local_notifications',
                'table_calendar',
                'shared_preferences',
              ]
                  .map((t) => Chip(
                        label: Text(t),
                        backgroundColor: color.secondaryContainer,
                        labelStyle:
                            TextStyle(color: color.onSecondaryContainer),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  List<Widget> _features(BuildContext context) {
    const features = [
      (Icons.task_alt, 'Gestión de tareas (CRUD completo)'),
      (Icons.calendar_month, 'Calendario interactivo'),
      (Icons.notifications_active, 'Notificaciones de recordatorio'),
      (Icons.wifi_off, 'Modo offline con Hive'),
      (Icons.tune, 'Preferencias personalizables'),
    ];
    return features
        .map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(f.$1,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(f.$2),
                ],
              ),
            ))
        .toList();
  }
}
