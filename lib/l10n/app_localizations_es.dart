// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'StudyTrack';

  @override
  String get calendar => 'Calendario';

  @override
  String get tasks => 'Tareas';

  @override
  String get about => 'Acerca de';

  @override
  String get preferences => 'Preferencias';

  @override
  String get profile => 'Mi Perfil';

  @override
  String get survey => 'Evaluación';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get createTask => 'Crear tarea';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get deleteTask => 'Eliminar tarea';

  @override
  String confirmDelete(String title) {
    return '¿Eliminar \"$title\"?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get taskCreated => '✅ Tarea creada';

  @override
  String get taskUpdated => '✅ Tarea actualizada';

  @override
  String get titleField => 'Título *';

  @override
  String get titleRequired => 'Ingresa un título';

  @override
  String get descriptionField => 'Descripción (opcional)';

  @override
  String get dueDate => 'Fecha límite';

  @override
  String get reminder => 'Recordatorio';

  @override
  String hoursBeforeReminder(int hours) {
    return '$hours horas antes';
  }

  @override
  String get pending => 'Pendientes';

  @override
  String get completed => 'Completadas';

  @override
  String get noPendingTasks => 'No tienes tareas pendientes 🎉';

  @override
  String get noCompletedTasks => 'Aún no has completado tareas';

  @override
  String get noTasksForDay => 'No hay tareas para este día';

  @override
  String get noTasksThisDay => 'Sin tareas este día';

  @override
  String taskCount(int count) {
    return '$count tarea(s)';
  }

  @override
  String get notificationsEnabled => 'Notificaciones activadas';

  @override
  String get notificationsSubtitle => 'Recibir recordatorios de tareas';

  @override
  String get reminderAnticipation => 'Anticipación del recordatorio';

  @override
  String reminderAnticipationSubtitle(int hours) {
    return '$hours horas antes del vencimiento';
  }

  @override
  String get weekStartsMonday => 'Semana empieza el lunes';

  @override
  String get weekStartsMondaySubtitle => 'Afecta la vista del calendario';

  @override
  String get showCompleted => 'Mostrar tareas completadas';

  @override
  String get showCompletedSubtitle => 'Incluir completadas en el calendario';

  @override
  String get sortBy => 'Ordenar tareas por';

  @override
  String get sortByDate => 'Fecha límite';

  @override
  String get sortByCreation => 'Fecha de creación';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get preferencesAutoSave =>
      'Las preferencias se guardan automáticamente.';

  @override
  String get sectionNotifications => 'Notificaciones';

  @override
  String get sectionCalendar => 'Calendario';

  @override
  String get sectionTasks => 'Tareas';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutDescription =>
      'StudyTrack es una aplicación móvil diseñada para estudiantes que buscan organizar su tiempo de estudio y evitar la sobrecarga académica.';

  @override
  String get aboutFeatures => 'Características';

  @override
  String get aboutTechnologies => 'Tecnologías';

  @override
  String get surveyTitle => 'Evaluación STUDYTRACK';

  @override
  String surveyProgress(int answered, int total) {
    return '$answered / $total respondidas';
  }

  @override
  String get surveySend => 'Enviar evaluación por correo';

  @override
  String get surveyAnswerAll => 'Responde todas las preguntas';

  @override
  String surveyMinLabel(int min) {
    return '$min = Muy malo';
  }

  @override
  String surveyMaxLabel(int max) {
    return '$max = Excelente';
  }

  @override
  String get edit => 'Editar';

  @override
  String get share => 'Compartir';

  @override
  String shareTaskText(
    String title,
    String description,
    String dueDate,
    String status,
  ) {
    return '📚 Tarea: $title\n📝 Descripción: $description\n⏰ Vence: $dueDate\n✅ Estado: $status\n\nEnviado desde StudyTrack';
  }

  @override
  String get statusCompleted => 'Completada';

  @override
  String get statusPending => 'Pendiente';
}
