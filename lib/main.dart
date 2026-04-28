import 'package:flutter/material.dart';
import 'ui/screens/calendar_screen.dart';
import 'ui/screens/tasks_screen.dart';
import 'ui/screens/about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.blue,
          secondary: Colors.lightBlue
        ),

        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),

      initialRoute: '/calendar',
      routes: {
        '/calendar' : (context) => const CalendarScreen(),
        '/tasks' : (context) =>  TasksScreen(),
        '/about' : (context) => const AboutScreen(),
      },
      
    );
  }
}


