import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../domain/task2.dart';
import '../../presentation/preferences/preferences_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/add_edit_task_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    final vm = context.read<TaskViewModel>();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      vm.listenTasks(uid);
    }
  }

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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text(l10n.confirmDelete(task.title)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskViewModel>().deleteTask(task.id);
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final prefs = context.watch<PreferencesProvider>();
    final l10n = AppLocalizations.of(context)!;

    List<Task2> tasksForDay(DateTime day) {
      return vm.tasksForDay(day).where((t) {
        if (!prefs.showCompletedInCalendar && t.completed) return false;
        return true;
      }).toList();
    }

    final tasksSelected = tasksForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.preferences,
            onPressed: () => Navigator.pushNamed(context, '/preferences'),
          ),
          IconButton(
            icon: const Icon(Icons.star_rate),
            tooltip: l10n.survey,
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
                      ? l10n.noTasksThisDay
                      : l10n.taskCount(tasksSelected.length),
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
                            Text(l10n.noTasksForDay),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        icon: const Icon(Icons.add),
        label: Text(l10n.newTask),
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
    final l10n = AppLocalizations.of(context)!;
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/calendar');
        if (i == 1) Navigator.pushReplacementNamed(context, '/tasks');
        if (i == 2) Navigator.pushReplacementNamed(context, '/about');
        if (i == 3) Navigator.pushReplacementNamed(context, '/profile');
      },
      destinations: [
        NavigationDestination(
            icon: const Icon(Icons.calendar_month), label: l10n.calendar),
        NavigationDestination(icon: const Icon(Icons.task), label: l10n.tasks),
        NavigationDestination(icon: const Icon(Icons.info), label: l10n.about),
        NavigationDestination(icon: const Icon(Icons.person), label: l10n.profile),
      ],
    );
  }
}
