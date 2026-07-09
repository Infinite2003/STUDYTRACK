import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/task2.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../l10n/app_localizations.dart';

class TaskCard extends StatelessWidget {
  final Task2 task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String sortBy;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    required this.sortBy,
  });

  Color _urgencyColor(BuildContext context) {
    final diff = task.dueDate.difference(DateTime.now()).inHours;
    if (task.completed) return Colors.green.shade300;
    if (diff < 24) return Colors.red.shade400;
    if (diff < 72) return Colors.orange.shade400;
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final urgency = _urgencyColor(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: urgency.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: onToggleComplete,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.completed ? Colors.green : Colors.transparent,
              border: Border.all(
                color: task.completed ? Colors.green : urgency,
                width: 2,
              ),
            ),
            child: task.completed
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: urgency),
                const SizedBox(width: 4),
                Text(
                  'Vence: ${_formatDate(task.dueDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: urgency,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (sortBy == 'creation') ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.edit_calendar,
                      size: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    'Creada: ${_formatDate(DateTime.fromMillisecondsSinceEpoch(int.parse(task.id)))}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
            if (value == 'share') _shareTask(context);
            if (value == 'share_task') _showShareDialog(context, task);
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
            PopupMenuItem(
                value: 'share_task',
                child: const Text('Compartir con usuario')),
            PopupMenuItem(
              value: 'delete',
              child: Text(l10n.delete,
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month]} ${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  void _shareTask(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final fechaVence =
        '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} '
        '${task.dueDate.hour.toString().padLeft(2, '0')}:'
        '${task.dueDate.minute.toString().padLeft(2, '0')}';

    final status = task.completed ? l10n.statusCompleted : l10n.statusPending;
    final texto = l10n.shareTaskText(
        task.title, task.description, fechaVence, status);

    // ✅ API nueva de share_plus
    await SharePlus.instance.share(ShareParams(text: texto));
  }

  void _showShareDialog(BuildContext context, Task2 task) {
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        String? errorMsg;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text('Compartir tarea'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ingresa el correo del usuario con quien compartir "${task.title}"',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorText: errorMsg,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = emailCtrl.text.trim();
                  if (email.isEmpty) return;

                  // Captura vm y messenger ANTES del await
                  final vm = context.read<TaskViewModel>();
                  final messenger = ScaffoldMessenger.of(context);

                  final error =
                      await vm.shareTaskWithEmail(task.id, email);

                  if (!ctx.mounted) return;

                  if (error == null) {
                    Navigator.pop(ctx);
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('✅ Tarea compartida correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    setState(() => errorMsg = error);
                  }
                },
                child: const Text('Compartir'),
              ),
            ],
          ),
        );
      },
    );
  }
}