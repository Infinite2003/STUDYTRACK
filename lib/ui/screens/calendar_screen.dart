import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../viewmodels/task_viewmodel.dart';
import '../../domain/task2.dart';
import '../widgets/task_card.dart';
import '../widgets/add_edit_task_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void _openAddTask() {
    final vm = context.read<TaskViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: const AddEditTaskSheet(),
      ),
    );
  }

  void _openEditTask(Task2 task) {
    final vm = context.read<TaskViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: AddEditTaskSheet(taskToEdit: task),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Task2 task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${task.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskViewModel>().deleteTask(task.id);
            },
            child:
                const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final tasksForDay = vm.tasksForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyTrack'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Preferencias',
            onPressed: () => Navigator.pushNamed(context, '/preferences'),
          ),
          IconButton(
            icon: const Icon(Icons.star_rate),
            tooltip: 'Evaluar app',
            onPressed: () => Navigator.pushNamed(context, '/survey'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendario
          TableCalendar<Task2>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: vm.tasksForDay,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) {
              setState(() => _focusedDay = focused);
            },
          ),

          const Divider(height: 1),

          // Lista de tareas del día seleccionado
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.list_alt,
                    color: Theme.of(context).colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  tasksForDay.isEmpty
                      ? 'Sin tareas este día'
                      : '${tasksForDay.length} tarea(s)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasksForDay.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_available,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3)),
                            const SizedBox(height: 12),
                            const Text('No hay tareas para este día'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasksForDay.length,
                        itemBuilder: (_, i) {
                          final task = tasksForDay[i];
                          return TaskCard(
                            task: task,
                            onToggleComplete: () =>
                                vm.toggleComplete(task),
                            onEdit: () => _openEditTask(task),
                            onDelete: () => _confirmDelete(context, task),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  const BottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/calendar');
        if (i == 1) Navigator.pushReplacementNamed(context, '/tasks');
        if (i == 2) Navigator.pushReplacementNamed(context, '/about');
      },
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.calendar_month), label: 'Calendario'),
        NavigationDestination(icon: Icon(Icons.task), label: 'Tareas'),
        NavigationDestination(icon: Icon(Icons.info), label: 'Acerca de'),
      ],
    );
  }
}
