// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StudyTrack';

  @override
  String get calendar => 'Calendar';

  @override
  String get tasks => 'Tasks';

  @override
  String get about => 'About';

  @override
  String get preferences => 'Preferences';

  @override
  String get profile => 'My Profile';

  @override
  String get survey => 'Survey';

  @override
  String get newTask => 'New task';

  @override
  String get editTask => 'Edit task';

  @override
  String get createTask => 'Create task';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteTask => 'Delete task';

  @override
  String confirmDelete(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get taskCreated => '✅ Task created';

  @override
  String get taskUpdated => '✅ Task updated';

  @override
  String get titleField => 'Title *';

  @override
  String get titleRequired => 'Enter a title';

  @override
  String get descriptionField => 'Description (optional)';

  @override
  String get dueDate => 'Due date';

  @override
  String get reminder => 'Reminder';

  @override
  String hoursBeforeReminder(int hours) {
    return '$hours hours before';
  }

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get noPendingTasks => 'No pending tasks 🎉';

  @override
  String get noCompletedTasks => 'No completed tasks yet';

  @override
  String get noTasksForDay => 'No tasks for this day';

  @override
  String get noTasksThisDay => 'No tasks this day';

  @override
  String taskCount(int count) {
    return '$count task(s)';
  }

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsSubtitle => 'Receive task reminders';

  @override
  String get reminderAnticipation => 'Reminder anticipation';

  @override
  String reminderAnticipationSubtitle(int hours) {
    return '$hours hours before due date';
  }

  @override
  String get weekStartsMonday => 'Week starts on Monday';

  @override
  String get weekStartsMondaySubtitle => 'Affects the calendar view';

  @override
  String get showCompleted => 'Show completed tasks';

  @override
  String get showCompletedSubtitle => 'Include completed tasks in calendar';

  @override
  String get sortBy => 'Sort tasks by';

  @override
  String get sortByDate => 'Due date';

  @override
  String get sortByCreation => 'Creation date';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get preferencesAutoSave => 'Preferences are saved automatically.';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get sectionCalendar => 'Calendar';

  @override
  String get sectionTasks => 'Tasks';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutDescription =>
      'StudyTrack is a mobile app designed for students looking to organize their study time and avoid academic overload.';

  @override
  String get aboutFeatures => 'Features';

  @override
  String get aboutTechnologies => 'Technologies';

  @override
  String get surveyTitle => 'STUDYTRACK Survey';

  @override
  String surveyProgress(int answered, int total) {
    return '$answered / $total answered';
  }

  @override
  String get surveySend => 'Send survey by email';

  @override
  String get surveyAnswerAll => 'Answer all questions';

  @override
  String surveyMinLabel(int min) {
    return '$min = Very bad';
  }

  @override
  String surveyMaxLabel(int max) {
    return '$max = Excellent';
  }

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String shareTaskText(
    String title,
    String description,
    String dueDate,
    String status,
  ) {
    return '📚 Task: $title\n📝 Description: $description\n⏰ Due: $dueDate\n✅ Status: $status\n\nSent from StudyTrack';
  }

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusPending => 'Pending';
}
