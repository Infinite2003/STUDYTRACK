import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../viewmodels/task_viewmodel.dart';
import '../../domain/task2.dart';
import '../../presentation/preferences/preferences_provider.dart';
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
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final prefs = context.watch<PreferencesProvider>();

    // Filtra según preferencia de mostrar completadas
    List<Task2> tasksForDay(DateTime day) {
      return vm.tasksForDay(day).where((t) {
        if (!prefs.showCompletedInCalendar && t.completed) return false;
        return true;
      }).toList();
    }

    final tasksSelected = tasksForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyTrack'),
        centerTitle: true,
        actions: [

          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Mi Perfil',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
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
          TableCalendar<Task2>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: _focusedDay,
            startingDayOfWeek: prefs.startOnMonday
                ? StartingDayOfWeek.monday
                : StartingDayOfWeek.sunday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: tasksForDay,
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
                    .withValues(alpha: 0.3),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.list_alt,
                    color: Theme.of(context).colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  tasksSelected.isEmpty
                      ? 'Sin tareas este día'
                      : '${tasksSelected.length} tarea(s)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasksSelected.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_available,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3)),
                            const SizedBox(height: 12),
                            const Text('No hay tareas para este día'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasksSelected.length,
                        itemBuilder: (_, i) {
                          final task = tasksSelected[i];
                          return TaskCard(
                            task: task,
                            sortBy: prefs.sortBy,
                            onToggleComplete: () => vm.toggleComplete(task),
                            onEdit: () => _openEditTask(task),
                            onDelete: () => _confirmDelete(context, task),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
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