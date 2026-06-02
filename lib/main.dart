import 'package:flutter/material.dart';
import 'theme/material_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/hive_datasource.dart';
import 'data/task_repository_impl.dart';
import 'data/notification_service.dart';

import 'domain/create_task_usecase.dart';

import 'presentation/task_provider.dart';
import 'presentation/poc_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox(HiveDatasource.boxName);

  final notificationService = NotificationService();

  await notificationService.init();

  final repository = TaskRepositoryImpl(
    hiveDatasource: HiveDatasource(),
    notificationService: notificationService,
  );

  runApp(
    MyApp(repository: repository),
  );
}

class MyApp extends StatelessWidget {
  final TaskRepositoryImpl repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            CreateTaskUseCase(repository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: MaterialTheme(
          ThemeData.light().textTheme,
        ).light(),

        home: const PocScreen(),
      ),
    );
  }
}
