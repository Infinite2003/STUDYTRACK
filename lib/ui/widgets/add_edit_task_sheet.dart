import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/task2.dart';
import '../../viewmodels/task_viewmodel.dart';

class AddEditTaskSheet extends StatefulWidget {
  final Task2? taskToEdit; // null = crear nueva

  const AddEditTaskSheet({super.key, this.taskToEdit});

  @override
  State<AddEditTaskSheet> createState() => _AddEditTaskSheetState();
}

class _AddEditTaskSheetState extends State<AddEditTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late DateTime _dueDate;
  late int _reminderHours;
  bool _isLoading = false;

  bool get _isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    final t = widget.taskToEdit;
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _descCtrl = TextEditingController(text: t?.description ?? '');
    _dueDate = t?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _reminderHours = t?.reminderHours ?? 24;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (pickedTime == null) return;

    setState(() {
      _dueDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final vm = context.read<TaskViewModel>();
    final task = Task2(
      id: _isEditing
          ? widget.taskToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      dueDate: _dueDate,
      completed: _isEditing ? widget.taskToEdit!.completed : false,
      reminderHours: _reminderHours,
    );

    final success =
        _isEditing ? await vm.editTask(task) : await vm.addTask(task);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? '✅ Tarea actualizada'
              : '✅ Tarea creada'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${d.day} de ${months[d.month]} ${d.year},  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _isEditing ? Icons.edit : Icons.add_task,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _isEditing ? 'Editar tarea' : 'Nueva tarea',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Título
            TextFormField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingresa un título' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),

            // Descripción
            TextFormField(
              controller: _descCtrl,
              decoration: InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.notes),
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),

            // Fecha límite
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Fecha límite'),
              subtitle: Text(
                _formatDate(_dueDate),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _pickDate,
              trailing:
                  const Icon(Icons.arrow_forward_ios, size: 14),
            ),
            const Divider(),

            // Horas de recordatorio
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications,
                  color: Theme.of(context).colorScheme.secondary),
              title: const Text('Recordatorio'),
              subtitle: Text(
                '$_reminderHours horas antes',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Slider(
              value: _reminderHours.toDouble(),
              min: 1,
              max: 72,
              divisions: 71,
              label: '$_reminderHours h',
              onChanged: (v) => setState(() => _reminderHours = v.toInt()),
            ),
            const SizedBox(height: 16),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isEditing ? 'Guardar cambios' : 'Crear tarea'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
