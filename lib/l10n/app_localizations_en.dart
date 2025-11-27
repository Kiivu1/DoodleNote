// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DoodleNote';

  @override
  String get settingsTitle => 'Configuration';

  @override
  String get cloudSync => 'Cloud Synchronization';

  @override
  String get cloudSyncDesc => 'Backup your text notes (no images).';

  @override
  String get signInGoogle => 'Connect with Google';

  @override
  String get uploadNow => 'Upload Now';

  @override
  String get download => 'Restore';

  @override
  String get autoSync => 'Auto Sync';

  @override
  String get autoSyncDesc => 'Upload changes on save or delete';

  @override
  String get fontSettings => 'Font Settings';

  @override
  String get fontSettingsDesc => 'Adjust font size and type.';

  @override
  String get textSize => 'Text Size';

  @override
  String get titleSize => 'Title Size';

  @override
  String get fontType => 'Font Type';

  @override
  String get menuLayout => 'Menu Layout';

  @override
  String get showImage => 'Show image in notes';

  @override
  String get showDate => 'Show date in notes';

  @override
  String get language => 'Language';

  @override
  String get normal => 'Normal';

  @override
  String get defaultOption => 'Default';

  @override
  String get large => 'Large';

  @override
  String get compact => 'Compact';

  @override
  String get about => 'About';

  @override
  String get createNote => 'Create Note';

  @override
  String get search => 'Search';

  @override
  String get noNotes => 'No notes found. Create a new one!';

  @override
  String get deleteNoteTitle => 'Delete Note';

  @override
  String get deleteNoteContent => 'Do you want to delete this Note?';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get fromGallery => 'Gallery';

  @override
  String get addTagTitle => 'Add New Tag';

  @override
  String get enterTagName => 'Enter Tag Name';

  @override
  String get addTabTitle => 'Add New Tab';

  @override
  String get enterTabTitle => 'Enter Tab Title';

  @override
  String get enterTabContent => 'Enter Content (Optional)';

  @override
  String get add => 'Add';

  @override
  String get saveProgress => 'Save Progress?';

  @override
  String get wantToSave => 'Want to save this Note?';

  @override
  String get leaveWithoutSaving => 'Leave Without Saving?';

  @override
  String get leaveLoseChanges => 'Any unsaved changes will be lost.';

  @override
  String get leave => 'Leave';

  @override
  String get tapToAdd => 'Tap to Add Tab or Tag';

  @override
  String get chooseAdd => 'What do you want to add?';

  @override
  String get tag => 'Tag';

  @override
  String get tab => 'Tab';

  @override
  String get searchHint => 'Search DoodleNote';

  @override
  String get noResults => 'No results found for';

  @override
  String get createdDate => 'Created';

  @override
  String get editedDate => 'Edited';

  @override
  String get aboutTitle => 'About & Feedback';

  @override
  String get aboutAppTitle => 'About DoodleNote';

  @override
  String get aboutAppDesc =>
      'DoodleNote is a mobile notes app designed to facilitate organization and customization of your information.';

  @override
  String get aboutDevTitle => 'About the Developer';

  @override
  String get aboutDevDesc =>
      'Ivan Eduardo Obando Alcayaga is a Video Game Development student at the University of Talca.\nHis mission is to assist in note creation with a system that is visually attractive and highly customizable.';

  @override
  String get feedbackTitle => 'Satisfaction Survey';

  @override
  String get contactSection => '0. Contact Info';

  @override
  String get usageSection => '1. Usage & Rating';

  @override
  String get opinionSection => '2. Opinions';

  @override
  String get verdictSection => '3. Final Verdict';

  @override
  String get sendEmailBtn => 'Send Feedback via Email';

  @override
  String get reloadForm => 'Reload Form';

  @override
  String emailDisclaimer(Object email) {
    return 'Pressing this will open your email app to send results to $email.';
  }

  @override
  String get nameLabel => 'Your Name (Optional)';

  @override
  String get emailLabel => 'Your Email';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get emailError => 'Please enter a valid email.';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get notProvided => 'Not Provided';

  @override
  String get notAnswered => 'Not answered';

  @override
  String get emailSubject => 'User Feedback - DoodleNote';

  @override
  String get emailBodyHeader => 'DoodleNote Feedback from:';

  @override
  String get sectionUsageHeader => '--- Usage Section (Ratings) ---';

  @override
  String get sectionOpinionHeader => '--- Opinion Section (Text) ---';

  @override
  String get sectionVerdictHeader => '--- Final Verdict ---';

  @override
  String get qLabel => 'Q:';

  @override
  String get aLabel => 'Answer:';

  @override
  String get rateLabel => 'Rating:';

  @override
  String get errorLoading => 'Error loading feedback form.';

  @override
  String get errorUnknown => 'Unknown error.';

  @override
  String errorEmailOpen(Object email) {
    return 'Could not open email app. Copy: $email';
  }

  @override
  String get dictate => 'Dictate';

  @override
  String get listening => 'Listening...';

  @override
  String get readAloud => 'Read Aloud';

  @override
  String get stopReading => 'Stop Reading';
}
