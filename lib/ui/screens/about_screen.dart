import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Acerca de STUDYTRACK'),
        actions: [

          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Ver Calendario',
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),

          IconButton(
            icon: const Icon(Icons.checklist),
            tooltip: 'Ver Tareas',
            onPressed: () {
              Navigator.pushNamed(context, '/tasks');
            },
          )
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.school,
                    size: 64,
                    color:  Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'STUDYTRACK',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Versión: 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                '¿Qué es STUDYTRACK?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Una aplicación diseñada para estudiantes que buscan organizar su tiempo de estudio de manera efectiva, evitando la procrastinación y la sobrecarga académica.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              const Text(
                'Características',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FeatureCard(
                icon: Icons.task_alt,
                title: 'Gestión de Tareas',
                description: 'Registra tareas, exámenes y proyectos con fechas límite.',
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              FeatureCard(
                icon: Icons.calendar_month,
                title: 'Calendario Interactivo',
                description: 'Visualiza tu carga académica mes a mes.',
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              FeatureCard(
                icon: Icons.notifications_active,
                title: 'Recordatorios Inteligentes',
                description: 'Recibe notificaciones personalizadas antes de tus fechas clave.',
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              FeatureCard(
                icon: Icons.offline_bolt,
                title: 'Modo Offline',
                description: 'Funciona sin internet, tus datos siempre contigo.',
                color: Colors.purple,
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.code, color: Colors.blue),
                    SizedBox(height: 12),
                    Text(
                      'Desarrollado con Flutter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Disponible para iOS y Android',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}