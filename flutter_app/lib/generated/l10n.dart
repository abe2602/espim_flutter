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
  String get sensem_title {
    return Intl.message(
      'SENSEM',
      name: 'sensem_title',
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
  String get tasks_title {
    return Intl.message(
      'TASKS',
      name: 'tasks_title',
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
  String get notifications_title {
    return Intl.message(
      'NOTIFICATIONS',
      name: 'notifications_title',
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
  String get got_it_title {
    return Intl.message(
      'GOT IT',
      name: 'got_it_title',
      desc: '',
      args: [],
    );
  }

  /// `BEGIN`
  String get begin_title {
    return Intl.message(
      'BEGIN',
      name: 'begin_title',
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