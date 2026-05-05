import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Calendario',
            onPressed: () => Navigator.pushNamed(context, '/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            tooltip: 'Tareas',
            onPressed: () => Navigator.pushNamed(context, '/tasks'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Acerca de',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildFaqItem(
              question: '¿Cómo agrego una nueva tarea?',
              answer: 'Presiona el botón "+" en la pantalla de Tareas. Completa el formulario con título, descripción, fecha límite y prioridad.',
              icon: Icons.add_task,
            ),
            const Divider(),
            _buildFaqItem(
              question: '¿Cómo funcionan las notificaciones?',
              answer: 'STUDYTRACK te enviará recordatorios automáticos antes de la fecha límite de cada tarea. Puedes configurar el tiempo de anticipación en la configuración.',
              icon: Icons.notifications_active,
            ),
            const Divider(),
            _buildFaqItem(
              question: '¿Puedo usar la app sin internet?',
              answer: 'Sí, STUDYTRACK funciona en modo offline. Todas tus tareas se guardan localmente y se sincronizan cuando vuelves a tener conexión.',
              icon: Icons.offline_bolt,
            ),
            const Divider(),
            _buildFaqItem(
              question: '¿Cómo marco una tarea como completada?',
              answer: 'En la pantalla de Tareas, toca el círculo junto al nombre de la tarea. La tarea se marcará como completada con una línea tachada.',
              icon: Icons.check_circle,
            ),
            const Divider(),
            _buildFaqItem(
              question: '¿Cómo edito o elimino una tarea?',
              answer: 'Para editar, toca sobre la tarea para ver el detalle y luego el ícono de edición. Para eliminar, desliza la tarea hacia la izquierda.',
              icon: Icons.edit,
            ),
            const Divider(),
            _buildFaqItem(
              question: '¿Qué significan los colores de prioridad?',
              answer: 'Rojo = Prioridad Alta (urgente), Naranja = Prioridad Media, Verde = Prioridad Baja.',
              icon: Icons.flag,
            ),
            const Divider(),
            const SizedBox(height: 30),
            // Contacto
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email, color: Colors.blue, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¿Necesitas más ayuda?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Contáctanos a soporte@studytrack.cl',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[600], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}