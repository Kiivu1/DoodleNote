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
  /// In en, this message translates to:
  /// **'DoodleNote'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get settingsTitle;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Synchronization'**
  String get cloudSync;

  /// No description provided for @cloudSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Backup your text notes (no images).'**
  String get cloudSyncDesc;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get signInGoogle;

  /// No description provided for @uploadNow.
  ///
  /// In en, this message translates to:
  /// **'Upload Now'**
  String get uploadNow;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get download;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get autoSync;

  /// No description provided for @autoSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload changes on save or delete'**
  String get autoSyncDesc;

  /// No description provided for @fontSettings.
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get fontSettings;

  /// No description provided for @fontSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust font size and type.'**
  String get fontSettingsDesc;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @titleSize.
  ///
  /// In en, this message translates to:
  /// **'Title Size'**
  String get titleSize;

  /// No description provided for @fontType.
  ///
  /// In en, this message translates to:
  /// **'Font Type'**
  String get fontType;

  /// No description provided for @menuLayout.
  ///
  /// In en, this message translates to:
  /// **'Menu Layout'**
  String get menuLayout;

  /// No description provided for @showImage.
  ///
  /// In en, this message translates to:
  /// **'Show image in notes'**
  String get showImage;

  /// No description provided for @showDate.
  ///
  /// In en, this message translates to:
  /// **'Show date in notes'**
  String get showDate;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @defaultOption.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultOption;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @compact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get compact;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @createNote.
  ///
  /// In en, this message translates to:
  /// **'Create Note'**
  String get createNote;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes found. Create a new one!'**
  String get noNotes;

  /// No description provided for @deleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get deleteNoteTitle;

  /// No description provided for @deleteNoteContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this Note?'**
  String get deleteNoteContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get fromGallery;

  /// No description provided for @addTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Tag'**
  String get addTagTitle;

  /// No description provided for @enterTagName.
  ///
  /// In en, this message translates to:
  /// **'Enter Tag Name'**
  String get enterTagName;

  /// No description provided for @addTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Tab'**
  String get addTabTitle;

  /// No description provided for @enterTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Tab Title'**
  String get enterTabTitle;

  /// No description provided for @enterTabContent.
  ///
  /// In en, this message translates to:
  /// **'Enter Content (Optional)'**
  String get enterTabContent;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save Progress?'**
  String get saveProgress;

  /// No description provided for @wantToSave.
  ///
  /// In en, this message translates to:
  /// **'Want to save this Note?'**
  String get wantToSave;

  /// No description provided for @leaveWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Leave Without Saving?'**
  String get leaveWithoutSaving;

  /// No description provided for @leaveLoseChanges.
  ///
  /// In en, this message translates to:
  /// **'Any unsaved changes will be lost.'**
  String get leaveLoseChanges;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to Add Tab or Tag'**
  String get tapToAdd;

  /// No description provided for @chooseAdd.
  ///
  /// In en, this message translates to:
  /// **'What do you want to add?'**
  String get chooseAdd;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @tab.
  ///
  /// In en, this message translates to:
  /// **'Tab'**
  String get tab;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search DoodleNote'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found for'**
  String get noResults;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdDate;

  /// No description provided for @editedDate.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get editedDate;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About & Feedback'**
  String get aboutTitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About DoodleNote'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppDesc.
  ///
  /// In en, this message translates to:
  /// **'DoodleNote is a mobile notes app designed to facilitate organization and customization of your information.'**
  String get aboutAppDesc;

  /// No description provided for @aboutDevTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Developer'**
  String get aboutDevTitle;

  /// No description provided for @aboutDevDesc.
  ///
  /// In en, this message translates to:
  /// **'Ivan Eduardo Obando Alcayaga is a Video Game Development student at the University of Talca.\nHis mission is to assist in note creation with a system that is visually attractive and highly customizable.'**
  String get aboutDevDesc;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Satisfaction Survey'**
  String get feedbackTitle;

  /// No description provided for @contactSection.
  ///
  /// In en, this message translates to:
  /// **'0. Contact Info'**
  String get contactSection;

  /// No description provided for @usageSection.
  ///
  /// In en, this message translates to:
  /// **'1. Usage & Rating'**
  String get usageSection;

  /// No description provided for @opinionSection.
  ///
  /// In en, this message translates to:
  /// **'2. Opinions'**
  String get opinionSection;

  /// No description provided for @verdictSection.
  ///
  /// In en, this message translates to:
  /// **'3. Final Verdict'**
  String get verdictSection;

  /// No description provided for @sendEmailBtn.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback via Email'**
  String get sendEmailBtn;

  /// No description provided for @reloadForm.
  ///
  /// In en, this message translates to:
  /// **'Reload Form'**
  String get reloadForm;

  /// No description provided for @emailDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Pressing this will open your email app to send results to {email}.'**
  String emailDisclaimer(Object email);

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name (Optional)'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailHint;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get emailError;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not Provided'**
  String get notProvided;

  /// No description provided for @notAnswered.
  ///
  /// In en, this message translates to:
  /// **'Not answered'**
  String get notAnswered;

  /// No description provided for @emailSubject.
  ///
  /// In en, this message translates to:
  /// **'User Feedback - DoodleNote'**
  String get emailSubject;

  /// No description provided for @emailBodyHeader.
  ///
  /// In en, this message translates to:
  /// **'DoodleNote Feedback from:'**
  String get emailBodyHeader;

  /// No description provided for @sectionUsageHeader.
  ///
  /// In en, this message translates to:
  /// **'--- Usage Section (Ratings) ---'**
  String get sectionUsageHeader;

  /// No description provided for @sectionOpinionHeader.
  ///
  /// In en, this message translates to:
  /// **'--- Opinion Section (Text) ---'**
  String get sectionOpinionHeader;

  /// No description provided for @sectionVerdictHeader.
  ///
  /// In en, this message translates to:
  /// **'--- Final Verdict ---'**
  String get sectionVerdictHeader;

  /// No description provided for @qLabel.
  ///
  /// In en, this message translates to:
  /// **'Q:'**
  String get qLabel;

  /// No description provided for @aLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer:'**
  String get aLabel;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating:'**
  String get rateLabel;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading feedback form.'**
  String get errorLoading;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error.'**
  String get errorUnknown;

  /// No description provided for @errorEmailOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app. Copy: {email}'**
  String errorEmailOpen(Object email);

  /// No description provided for @dictate.
  ///
  /// In en, this message translates to:
  /// **'Dictate'**
  String get dictate;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @readAloud.
  ///
  /// In en, this message translates to:
  /// **'Read Aloud'**
  String get readAloud;

  /// No description provided for @stopReading.
  ///
  /// In en, this message translates to:
  /// **'Stop Reading'**
  String get stopReading;
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
