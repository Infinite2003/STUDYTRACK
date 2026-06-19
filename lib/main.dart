import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/hive_datasource.dart';
import 'data/task_repository_impl.dart';
import 'data/notification_service.dart';

import 'domain/create_task_usecase.dart';

import 'viewmodels/task_viewmodel.dart';
import 'viewmodels/survey_viewmodel.dart';
import 'services/survey_loader.dart';

import 'presentation/preferences/preferences_provider.dart';
import 'presentation/preferences/preferences_screen.dart';
import 'ui/screens/calendar_screen.dart';
import 'ui/screens/tasks_screen.dart';
import 'ui/screens/about_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'survey/survey_screen.dart';
import 'theme/material_theme.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz_data.initializeTimeZones();
  // Obtener el offset actual del dispositivo y encontrar la zona
  final offsetMs = DateTime.now().timeZoneOffset.inMilliseconds;
  tz.Location localLoc = tz.UTC;
  for (final loc in tz.timeZoneDatabase.locations.values) {
    if (loc.currentTimeZone.offset == offsetMs) {
      localLoc = loc;
      break;
    }
  }
  tz.setLocalLocation(localLoc);
  print('=== Zona detectada: ${localLoc.name} ===');

  await Hive.initFlutter();
  await Hive.openBox(HiveDatasource.boxName);

  // Limpieza de registros legacy sin 'id'
  final box = Hive.box(HiveDatasource.boxName);
  final keysToDelete = box.keys.where((key) {
    final val = box.get(key);
    if (val is Map) return val['id'] == null;
    return true;
  }).toList();
  await box.deleteAll(keysToDelete);

  // A partir de aquí todo lo demás que ya tenías
  final notificationService = NotificationService();
  await notificationService.init();

  final repository = TaskRepositoryImpl(
    hiveDatasource: HiveDatasource(),
    notificationService: notificationService,
  );

  await notificationService.init();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepositoryImpl repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(
            createTaskUseCase: CreateTaskUseCase(repository),
            getTasksUseCase: GetTasksUseCase(repository),
            updateTaskUseCase: UpdateTaskUseCase(repository),
            deleteTaskUseCase: DeleteTaskUseCase(repository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider()..loadPreferences(),
        ),
        ChangeNotifierProvider(
          create: (_) => SurveyViewModel(SurveyLoader())..loadQuestions(),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, prefs, _) {
          final theme = MaterialTheme(Theme.of(context).textTheme);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'StudyTrack',
            themeMode: prefs.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: theme.light(),
            darkTheme: theme.dark(),
            initialRoute: '/calendar',
            routes: {
              '/calendar': (_) => const CalendarScreen(),
              '/tasks': (_) => const TasksScreen(),
              '/about': (_) => const AboutScreen(),
              '/preferences': (_) => const PreferencesScreen(),
              '/survey': (_) => const SurveyScreen(),
              '/profile': (_) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
