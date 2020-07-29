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

  /// `Oops! Something went wrong!\n Please try again later!`
  String get non_blocking_generic_error_message {
    return Intl.message(
      'Oops! Something went wrong!\n Please try again later!',
      name: 'non_blocking_generic_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you're offline! \n Try connection to the Internet!`
  String get non_blocking_no_internet_error_message {
    return Intl.message(
      'Looks like you\'re offline! \n Try connection to the Internet!',
      name: 'non_blocking_no_internet_error_message',
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