// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'DoodleNote';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get cloudSync => 'Sincronización en la Nube';

  @override
  String get cloudSyncDesc => 'Respalda tus textos (sin imágenes).';

  @override
  String get signInGoogle => 'Conectar con Google';

  @override
  String get uploadNow => 'Subir Ahora';

  @override
  String get download => 'Restaurar';

  @override
  String get autoSync => 'Sincronización Automática';

  @override
  String get autoSyncDesc => 'Subir cambios al guardar o borrar';

  @override
  String get fontSettings => 'Configuración de Fuente';

  @override
  String get fontSettingsDesc => 'Ajusta el tamaño y tipo de letra.';

  @override
  String get textSize => 'Tamaño de Texto';

  @override
  String get titleSize => 'Tamaño de Título';

  @override
  String get fontType => 'Tipo de fuente';

  @override
  String get menuLayout => 'Diseño del menú';

  @override
  String get showImage => 'Mostrar imagen en notas';

  @override
  String get showDate => 'Mostrar fecha en notas';

  @override
  String get language => 'Idioma';

  @override
  String get normal => 'Normal';

  @override
  String get defaultOption => 'Predeterminado';

  @override
  String get large => 'Grande';

  @override
  String get compact => 'Compacto';

  @override
  String get about => 'Acerca de';

  @override
  String get createNote => 'Crear Nota';

  @override
  String get search => 'Buscar';

  @override
  String get noNotes => 'No hay notas. ¡Crea una nueva!';

  @override
  String get deleteNoteTitle => 'Eliminar Nota';

  @override
  String get deleteNoteContent => '¿Quieres borrar esta nota?';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get share => 'Compartir';

  @override
  String get takePhoto => 'Tomar Foto';

  @override
  String get fromGallery => 'Galería';

  @override
  String get addTagTitle => 'Agregar Etiqueta';

  @override
  String get enterTagName => 'Nombre de la etiqueta';

  @override
  String get addTabTitle => 'Agregar Pestaña';

  @override
  String get enterTabTitle => 'Título de la pestaña';

  @override
  String get enterTabContent => 'Contenido (Opcional)';

  @override
  String get add => 'Agregar';

  @override
  String get saveProgress => '¿Guardar cambios?';

  @override
  String get wantToSave => '¿Quieres guardar esta nota?';

  @override
  String get leaveWithoutSaving => '¿Salir sin guardar?';

  @override
  String get leaveLoseChanges => 'Se perderán los cambios no guardados.';

  @override
  String get leave => 'Salir';

  @override
  String get tapToAdd => 'Toca para agregar Tab o Tag';

  @override
  String get chooseAdd => '¿Qué quieres agregar?';

  @override
  String get tag => 'Etiqueta';

  @override
  String get tab => 'Pestaña';

  @override
  String get searchHint => 'Buscar en DoodleNote';

  @override
  String get noResults => 'Sin resultados para';

  @override
  String get createdDate => 'Creada';

  @override
  String get editedDate => 'Editada';

  @override
  String get aboutTitle => 'Acerca de y Feedback';

  @override
  String get aboutAppTitle => 'Acerca de DoodleNote';

  @override
  String get aboutAppDesc =>
      'DoodleNote es una aplicación de notas móvil, la cual tiene como objetivo el poder facilitar la organización y la personalización de estas.';

  @override
  String get aboutDevTitle => 'Acerca del Desarrollador';

  @override
  String get aboutDevDesc =>
      'Ivan Eduardo Obando Alcayaga es un estudiante de la Carrera de Videojuegos de la Universidad de Talca.\nSu misión con esta app es poder ayudar a la hora de creación de notas con un sistema que es más atractivo visualmente, además de poder ser personalizable.';

  @override
  String get feedbackTitle => 'Encuesta de Satisfacción';

  @override
  String get contactSection => '0. Datos de Contacto';

  @override
  String get usageSection => '1. Uso y Calificación';

  @override
  String get opinionSection => '2. Opiniones';

  @override
  String get verdictSection => '3. Opinión final';

  @override
  String get sendEmailBtn => 'Enviar Feedback por Email';

  @override
  String get reloadForm => 'Recargar Formulario';

  @override
  String emailDisclaimer(Object email) {
    return 'Al presionar, se abrirá tu aplicación de correo para enviar los resultados a $email.';
  }

  @override
  String get nameLabel => 'Tu Nombre (Opcional)';

  @override
  String get emailLabel => 'Tu Email';

  @override
  String get emailHint => 'ejemplo@correo.com';

  @override
  String get emailError => 'Por favor, ingresa un email válido.';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get notProvided => 'No Proporcionado';

  @override
  String get notAnswered => 'No respondida';

  @override
  String get emailSubject => 'Feedback de Usuario - DoodleNote';

  @override
  String get emailBodyHeader => 'Feedback de DoodleNote de:';

  @override
  String get sectionUsageHeader => '--- Sección de Uso (Calificaciones) ---';

  @override
  String get sectionOpinionHeader => '--- Sección de Opinión (Textual) ---';

  @override
  String get sectionVerdictHeader => '--- Veredicto Final ---';

  @override
  String get qLabel => 'P:';

  @override
  String get aLabel => 'Respuesta:';

  @override
  String get rateLabel => 'Calificación:';

  @override
  String get errorLoading => 'Error al cargar el formulario.';

  @override
  String get errorUnknown => 'Error desconocido.';

  @override
  String errorEmailOpen(Object email) {
    return 'No se pudo abrir la app de correo. Copia: $email';
  }
}
