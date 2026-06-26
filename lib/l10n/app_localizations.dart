import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'StudyTrack'**
  String get appTitle;

  /// No description provided for @calendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get calendar;

  /// No description provided for @tasks.
  ///
  /// In es, this message translates to:
  /// **'Tareas'**
  String get tasks;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @preferences.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferences;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get profile;

  /// No description provided for @survey.
  ///
  /// In es, this message translates to:
  /// **'Evaluación'**
  String get survey;

  /// No description provided for @newTask.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In es, this message translates to:
  /// **'Editar tarea'**
  String get editTask;

  /// No description provided for @createTask.
  ///
  /// In es, this message translates to:
  /// **'Crear tarea'**
  String get createTask;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @deleteTask.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tarea'**
  String get deleteTask;

  /// No description provided for @confirmDelete.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{title}\"?'**
  String confirmDelete(String title);

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @taskCreated.
  ///
  /// In es, this message translates to:
  /// **'✅ Tarea creada'**
  String get taskCreated;

  /// No description provided for @taskUpdated.
  ///
  /// In es, this message translates to:
  /// **'✅ Tarea actualizada'**
  String get taskUpdated;

  /// No description provided for @titleField.
  ///
  /// In es, this message translates to:
  /// **'Título *'**
  String get titleField;

  /// No description provided for @titleRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un título'**
  String get titleRequired;

  /// No description provided for @descriptionField.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get descriptionField;

  /// No description provided for @dueDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha límite'**
  String get dueDate;

  /// No description provided for @reminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio'**
  String get reminder;

  /// No description provided for @hoursBeforeReminder.
  ///
  /// In es, this message translates to:
  /// **'{hours} horas antes'**
  String hoursBeforeReminder(int hours);

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get completed;

  /// No description provided for @noPendingTasks.
  ///
  /// In es, this message translates to:
  /// **'No tienes tareas pendientes 🎉'**
  String get noPendingTasks;

  /// No description provided for @noCompletedTasks.
  ///
  /// In es, this message translates to:
  /// **'Aún no has completado tareas'**
  String get noCompletedTasks;

  /// No description provided for @noTasksForDay.
  ///
  /// In es, this message translates to:
  /// **'No hay tareas para este día'**
  String get noTasksForDay;

  /// No description provided for @noTasksThisDay.
  ///
  /// In es, this message translates to:
  /// **'Sin tareas este día'**
  String get noTasksThisDay;

  /// No description provided for @taskCount.
  ///
  /// In es, this message translates to:
  /// **'{count} tarea(s)'**
  String taskCount(int count);

  /// No description provided for @notificationsEnabled.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas'**
  String get notificationsEnabled;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibir recordatorios de tareas'**
  String get notificationsSubtitle;

  /// No description provided for @reminderAnticipation.
  ///
  /// In es, this message translates to:
  /// **'Anticipación del recordatorio'**
  String get reminderAnticipation;

  /// No description provided for @reminderAnticipationSubtitle.
  ///
  /// In es, this message translates to:
  /// **'{hours} horas antes del vencimiento'**
  String reminderAnticipationSubtitle(int hours);

  /// No description provided for @weekStartsMonday.
  ///
  /// In es, this message translates to:
  /// **'Semana empieza el lunes'**
  String get weekStartsMonday;

  /// No description provided for @weekStartsMondaySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Afecta la vista del calendario'**
  String get weekStartsMondaySubtitle;

  /// No description provided for @showCompleted.
  ///
  /// In es, this message translates to:
  /// **'Mostrar tareas completadas'**
  String get showCompleted;

  /// No description provided for @showCompletedSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Incluir completadas en el calendario'**
  String get showCompletedSubtitle;

  /// No description provided for @sortBy.
  ///
  /// In es, this message translates to:
  /// **'Ordenar tareas por'**
  String get sortBy;

  /// No description provided for @sortByDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha límite'**
  String get sortByDate;

  /// No description provided for @sortByCreation.
  ///
  /// In es, this message translates to:
  /// **'Fecha de creación'**
  String get sortByCreation;

  /// No description provided for @darkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @preferencesAutoSave.
  ///
  /// In es, this message translates to:
  /// **'Las preferencias se guardan automáticamente.'**
  String get preferencesAutoSave;

  /// No description provided for @sectionNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get sectionNotifications;

  /// No description provided for @sectionCalendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get sectionCalendar;

  /// No description provided for @sectionTasks.
  ///
  /// In es, this message translates to:
  /// **'Tareas'**
  String get sectionTasks;

  /// No description provided for @sectionAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get sectionAppearance;

  /// No description provided for @sectionLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get sectionLanguage;

  /// No description provided for @aboutTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In es, this message translates to:
  /// **'StudyTrack es una aplicación móvil diseñada para estudiantes que buscan organizar su tiempo de estudio y evitar la sobrecarga académica.'**
  String get aboutDescription;

  /// No description provided for @aboutFeatures.
  ///
  /// In es, this message translates to:
  /// **'Características'**
  String get aboutFeatures;

  /// No description provided for @aboutTechnologies.
  ///
  /// In es, this message translates to:
  /// **'Tecnologías'**
  String get aboutTechnologies;

  /// No description provided for @surveyTitle.
  ///
  /// In es, this message translates to:
  /// **'Evaluación STUDYTRACK'**
  String get surveyTitle;

  /// No description provided for @surveyProgress.
  ///
  /// In es, this message translates to:
  /// **'{answered} / {total} respondidas'**
  String surveyProgress(int answered, int total);

  /// No description provided for @surveySend.
  ///
  /// In es, this message translates to:
  /// **'Enviar evaluación por correo'**
  String get surveySend;

  /// No description provided for @surveyAnswerAll.
  ///
  /// In es, this message translates to:
  /// **'Responde todas las preguntas'**
  String get surveyAnswerAll;

  /// No description provided for @surveyMinLabel.
  ///
  /// In es, this message translates to:
  /// **'{min} = Muy malo'**
  String surveyMinLabel(int min);

  /// No description provided for @surveyMaxLabel.
  ///
  /// In es, this message translates to:
  /// **'{max} = Excelente'**
  String surveyMaxLabel(int max);

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get share;

  /// No description provided for @shareTaskText.
  ///
  /// In es, this message translates to:
  /// **'📚 Tarea: {title}\n📝 Descripción: {description}\n⏰ Vence: {dueDate}\n✅ Estado: {status}\n\nEnviado desde StudyTrack'**
  String shareTaskText(
    String title,
    String description,
    String dueDate,
    String status,
  );

  /// No description provided for @statusCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completada'**
  String get statusCompleted;

  /// No description provided for @statusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
