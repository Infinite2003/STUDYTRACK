import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/task_viewmodel.dart';
import '../../presentation/preferences/preferences_provider.dart';
import '../../domain/task2.dart';
import '../widgets/task_card.dart';
import '../widgets/add_edit_task_sheet.dart';
import 'calendar_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  void _openEditTask(BuildContext context, Task2 task) {
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Tareas'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pending_actions), text: 'Pendientes'),
              Tab(icon: Icon(Icons.check_circle), text: 'Completadas'),
            ],
          ),
        ),
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _TaskList(
                    tasks: vm.sortedPending(prefs.sortBy),
                    emptyMessage: 'No tienes tareas pendientes 🎉',
                    emptyIcon: Icons.check_circle_outline,
                    vm: vm,
                    onEdit: (t) => _openEditTask(context, t),
                    onDelete: (t) => _confirmDelete(context, t),
                  ),
                  _TaskList(
                    tasks: vm.sortedCompleted(prefs.sortBy),
                    emptyMessage: 'Aún no has completado tareas',
                    emptyIcon: Icons.hourglass_empty,
                    vm: vm,
                    onEdit: (t) => _openEditTask(context, t),
                    onDelete: (t) => _confirmDelete(context, t),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final vm = context.read<TaskViewModel>();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (_) => ChangeNotifierProvider.value(
                value: vm,
                child: const AddEditTaskSheet(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva tarea'),
        ),
        bottomNavigationBar: const BottomNav(currentIndex: 1),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<Task2> tasks;
  final String emptyMessage;
  final IconData emptyIcon;
  final TaskViewModel vm;
  final void Function(Task2) onEdit;
  final void Function(Task2) onDelete;

  const _TaskList({
    required this.tasks,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.vm,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon,
                size: 72,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemBuilder: (_, i) {
        final task = tasks[i];
        return TaskCard(
          task: task,
          onToggleComplete: () => vm.toggleComplete(task),
          onEdit: () => onEdit(task),
          onDelete: () => onDelete(task),
        );
      },
    );
  }
}