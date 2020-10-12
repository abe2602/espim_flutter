// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `SENSEM`
  String get sensem_label {
    return Intl.message(
      'SENSEM',
      name: 'sensem_label',
      desc: '',
      args: [],
    );
  }

  /// `SENSEM is an application used to receive and execute tasks. Your doctor, your therapist, your family or even you can schedule these tasks in this website: espim.com.br`
  String get sensem_description {
    return Intl.message(
      'SENSEM is an application used to receive and execute tasks. Your doctor, your therapist, your family or even you can schedule these tasks in this website: espim.com.br',
      name: 'sensem_description',
      desc: '',
      args: [],
    );
  }

  /// `TASKS`
  String get tasks_label {
    return Intl.message(
      'TASKS',
      name: 'tasks_label',
      desc: '',
      args: [],
    );
  }

  /// `The tasks can be varied, such as answering questions, taking a picture, or recording an audio.`
  String get tasks_description {
    return Intl.message(
      'The tasks can be varied, such as answering questions, taking a picture, or recording an audio.',
      name: 'tasks_description',
      desc: '',
      args: [],
    );
  }

  /// `NOTIFICATIONS`
  String get notifications_label {
    return Intl.message(
      'NOTIFICATIONS',
      name: 'notifications_label',
      desc: '',
      args: [],
    );
  }

  /// `If you have a task  scheduled, you will receive alerts on your device to remember to execute them. To start the tasks, simply click on the notification icon or respond to the sound alert.`
  String get notifications_description {
    return Intl.message(
      'If you have a task  scheduled, you will receive alerts on your device to remember to execute them. To start the tasks, simply click on the notification icon or respond to the sound alert.',
      name: 'notifications_description',
      desc: '',
      args: [],
    );
  }

  /// `GOT IT`
  String get got_it_label {
    return Intl.message(
      'GOT IT',
      name: 'got_it_label',
      desc: '',
      args: [],
    );
  }

  /// `BEGIN`
  String get begin_label {
    return Intl.message(
      'BEGIN',
      name: 'begin_label',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Something went wrong!`
  String get generic_error_primary_text {
    return Intl.message(
      'Oops! Something went wrong!',
      name: 'generic_error_primary_text',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later.`
  String get generic_error_secondary_text {
    return Intl.message(
      'Please try again later.',
      name: 'generic_error_secondary_text',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get generic_error_button_text {
    return Intl.message(
      'Close',
      name: 'generic_error_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you're offline!`
  String get no_internet_primary_text {
    return Intl.message(
      'Looks like you\'re offline!',
      name: 'no_internet_primary_text',
      desc: '',
      args: [],
    );
  }

  /// `Try connection to the Internet.`
  String get no_internet_secondary_text {
    return Intl.message(
      'Try connection to the Internet.',
      name: 'no_internet_secondary_text',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get no_internet_button_text {
    return Intl.message(
      'Close',
      name: 'no_internet_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events_label {
    return Intl.message(
      'Events',
      name: 'events_label',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_label {
    return Intl.message(
      'Settings',
      name: 'settings_label',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get sign_out_label {
    return Intl.message(
      'Sign out',
      name: 'sign_out_label',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google!`
  String get google_sign_in {
    return Intl.message(
      'Sign in with Google!',
      name: 'google_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, `
  String get welcome {
    return Intl.message(
      'Welcome, ',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `{howMany, plural, one{1 ongoing event} other{{howMany} ongoing events}}`
  String ongoing_events(num howMany) {
    return Intl.plural(
      howMany,
      one: '1 ongoing event',
      other: '$howMany ongoing events',
      name: 'ongoing_events',
      desc: '',
      args: [howMany],
    );
  }

  /// `No events`
  String get no_events_label {
    return Intl.message(
      'No events',
      name: 'no_events_label',
      desc: '',
      args: [],
    );
  }

  /// `You don't have events yet`
  String get no_events_description {
    return Intl.message(
      'You don\'t have events yet',
      name: 'no_events_description',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh_label {
    return Intl.message(
      'Refresh',
      name: 'refresh_label',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question_label {
    return Intl.message(
      'Question',
      name: 'question_label',
      desc: '',
      args: [],
    );
  }

  /// `Empty Field`
  String get empty_field_error {
    return Intl.message(
      'Empty Field',
      name: 'empty_field_error',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Field`
  String get invalid_field_error {
    return Intl.message(
      'Invalid Field',
      name: 'invalid_field_error',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get open_question_label {
    return Intl.message(
      'Answer',
      name: 'open_question_label',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message(
      'NEXT',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `FINISH`
  String get finish {
    return Intl.message(
      'FINISH',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Upload files`
  String get upload_files {
    return Intl.message(
      'Upload files',
      name: 'upload_files',
      desc: '',
      args: [],
    );
  }

  /// `Touch to upload files`
  String get upload_files_action_label {
    return Intl.message(
      'Touch to upload files',
      name: 'upload_files_action_label',
      desc: '',
      args: [],
    );
  }

  /// `Change file`
  String get change_file_label {
    return Intl.message(
      'Change file',
      name: 'change_file_label',
      desc: '',
      args: [],
    );
  }

  /// `Task {currentPage} of {flowSize}`
  String task_flow_pages(Object currentPage, Object flowSize) {
    return Intl.message(
      'Task $currentPage of $flowSize',
      name: 'task_flow_pages',
      desc: '',
      args: [currentPage, flowSize],
    );
  }

  /// `Start`
  String get open_outside_link {
    return Intl.message(
      'Start',
      name: 'open_outside_link',
      desc: '',
      args: [],
    );
  }

  /// `Set home address`
  String get home_address_title_label {
    return Intl.message(
      'Set home address',
      name: 'home_address_title_label',
      desc: '',
      args: [],
    );
  }

  /// `Current address: {address}`
  String home_address_subtitle_label(Object address) {
    return Intl.message(
      'Current address: $address',
      name: 'home_address_subtitle_label',
      desc: '',
      args: [address],
    );
  }

  /// `Delete medias to free up space`
  String get delete_medias_title_label {
    return Intl.message(
      'Delete medias to free up space',
      name: 'delete_medias_title_label',
      desc: '',
      args: [],
    );
  }

  /// `Delete medias that were downloaded nd captured using the SENSEM`
  String get delete_medias_subtitle_label {
    return Intl.message(
      'Delete medias that were downloaded nd captured using the SENSEM',
      name: 'delete_medias_subtitle_label',
      desc: '',
      args: [],
    );
  }

  /// `Enable notification on doze media`
  String get enable_notifications_title_label {
    return Intl.message(
      'Enable notification on doze media',
      name: 'enable_notifications_title_label',
      desc: '',
      args: [],
    );
  }

  /// `Enable accurate notifications`
  String get enable_notifications_subtitle_label {
    return Intl.message(
      'Enable accurate notifications',
      name: 'enable_notifications_subtitle_label',
      desc: '',
      args: [],
    );
  }

  /// `Enable mobile network usage`
  String get enable_mobile_network_title_label {
    return Intl.message(
      'Enable mobile network usage',
      name: 'enable_mobile_network_title_label',
      desc: '',
      args: [],
    );
  }

  /// `Enable or disable 3G/4G utilization`
  String get enable_mobile_network_subtitle_label {
    return Intl.message(
      'Enable or disable 3G/4G utilization',
      name: 'enable_mobile_network_subtitle_label',
      desc: '',
      args: [],
    );
  }

  /// `Landscape layout`
  String get landscape_layout_mode_title_label {
    return Intl.message(
      'Landscape layout',
      name: 'landscape_layout_mode_title_label',
      desc: '',
      args: [],
    );
  }

  /// `Changes layout orientation`
  String get landscape_layout_mode_subtitle_label {
    return Intl.message(
      'Changes layout orientation',
      name: 'landscape_layout_mode_subtitle_label',
      desc: '',
      args: [],
    );
  }

  /// `Wait, please!`
  String get wait_please_label {
    return Intl.message(
      'Wait, please!',
      name: 'wait_please_label',
      desc: '',
      args: [],
    );
  }

  /// `HOLD TO RECORD`
  String get record_audio_label {
    return Intl.message(
      'HOLD TO RECORD',
      name: 'record_audio_label',
      desc: '',
      args: [],
    );
  }

  /// `You must have the permissions turn on to continue!`
  String get permission_denied_permanently_primary_text {
    return Intl.message(
      'You must have the permissions turn on to continue!',
      name: 'permission_denied_permanently_primary_text',
      desc: '',
      args: [],
    );
  }

  /// `Please, click on Settings and allow the permissions.`
  String get permission_denied_permanently_secondary_text {
    return Intl.message(
      'Please, click on Settings and allow the permissions.',
      name: 'permission_denied_permanently_secondary_text',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get permission_denied_permanently_primary_button_text {
    return Intl.message(
      'Settings',
      name: 'permission_denied_permanently_primary_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get permission_denied_permanently_secondary_button_text {
    return Intl.message(
      'Close',
      name: 'permission_denied_permanently_secondary_button_text',
      desc: '',
      args: [],
    );
  }

  /// `It seems like you denied the permission!`
  String get permission_denied_primary_text {
    return Intl.message(
      'It seems like you denied the permission!',
      name: 'permission_denied_primary_text',
      desc: '',
      args: [],
    );
  }

  /// `Please, try it again!`
  String get permission_denied_secondary_text {
    return Intl.message(
      'Please, try it again!',
      name: 'permission_denied_secondary_text',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get permission_denied_primary_button_text {
    return Intl.message(
      'Close',
      name: 'permission_denied_primary_button_text',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}