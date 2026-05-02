import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);


  final List<Task>listMaqueta = [

    Task(
      title: 'Calculo 2', 
      description: 'Resolver guía N° 2. Otorga 5 décimas', 
      dueDate: DateTime.now().add(const Duration(days: 5)), 
      priority: 'Media'
      ),

    Task(
      title: 'Programación Orientada a Objetos',
      description: 'Terminar Taller: Crear una herencia y polimorfismo', 
      dueDate: DateTime.now().add(const Duration(days: 2)), 
      priority: 'Alta'
      ),

      Task(
        title: 'Física', 
        description: 'Realizar ejercicios de calculo de péndulo', 
        dueDate: DateTime.now().add(const Duration(days: 8)), 
        priority: 'Baja'
        ),

      Task(
        title: 'Ética', 
        description: 'Realizar informe de Propuesta de Solucion', 
        dueDate: DateTime.now().add(const Duration(days: 6)), 
        priority: 'Alta'
        )
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month), 
            tooltip: 'Ver Calendario',
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),

          IconButton(
            icon: const Icon(Icons.info), 
            tooltip: 'Acerca de',
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemBuilder: (context, index) {

          final task = listMaqueta[index];
          return TaskCard(task: task);
        },

        itemCount: listMaqueta.length,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Agregar Nueva Tarea')),
          );
        },
        
        child: const Icon(Icons.add),
      ),
    );
  }
}