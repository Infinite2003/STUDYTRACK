import 'package:flutter/material.dart';
import '../../domain/task2.dart';
import 'package:share_plus/share_plus.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: urgency.withOpacity(0.4), width: 1.5),
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
            decoration:
                task.completed ? TextDecoration.lineThrough : null,
            color: task.completed
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
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
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            const SizedBox(height: 4),
            // Fecha límite — siempre visible
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
            // Fecha de creación — solo visible cuando sortBy == 'creation'
            if (sortBy == 'creation') ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.edit_calendar, size: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    'Creada: ${_formatDate(DateTime.fromMillisecondsSinceEpoch(int.parse(task.id)))}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(value: 'share', child: Text('Compartir')),
            PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar',
                  style: TextStyle(color: Colors.red)),
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
    return '${date.day} ${months[date.month]} ${date.year}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _shareTask(BuildContext context) {
    final fechaVence = '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} '
        '${task.dueDate.hour.toString().padLeft(2, '0')}:'
        '${task.dueDate.minute.toString().padLeft(2, '0')}';

    final texto = ' Tarea: ${task.title}\n'
        'Descripción: ${task.description}\n'
        'Vence: $fechaVence\n'
        'Estado: ${task.completed ? "Completada" : "Pendiente"}\n\n'
        'Enviado desde StudyTrack';

    SharePlus.instance.share(
      ShareParams(
        text: texto,
        subject: 'Tarea: ${task.title}',
      ),
    );
  }

}
