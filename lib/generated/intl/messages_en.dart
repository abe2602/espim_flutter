// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(address) => "Current address: ${address}";

  static m1(howMany) => "${Intl.plural(howMany, one: '1 ongoing event', other: '${howMany} ongoing events')}";

  static m2(currentPage, flowSize) => "Task ${currentPage} of ${flowSize}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "begin_label" : MessageLookupByLibrary.simpleMessage("BEGIN"),
    "change_file_label" : MessageLookupByLibrary.simpleMessage("Change file"),
    "delete_medias_subtitle_label" : MessageLookupByLibrary.simpleMessage("Delete medias that were downloaded nd captured using the SENSEM"),
    "delete_medias_title_label" : MessageLookupByLibrary.simpleMessage("Delete medias to free up space"),
    "emptyFieldError" : MessageLookupByLibrary.simpleMessage("Empty Field"),
    "enable_mobile_network_subtitle_label" : MessageLookupByLibrary.simpleMessage("Enable or disable 3G/4G utilization"),
    "enable_mobile_network_title_label" : MessageLookupByLibrary.simpleMessage("Enable mobile network usage"),
    "enable_notifications_subtitle_label" : MessageLookupByLibrary.simpleMessage("Enable accurate notifications"),
    "enable_notifications_title_label" : MessageLookupByLibrary.simpleMessage("Enable notification on doze media"),
    "events_label" : MessageLookupByLibrary.simpleMessage("Events"),
    "finish" : MessageLookupByLibrary.simpleMessage("Finish"),
    "google_sign_in" : MessageLookupByLibrary.simpleMessage("Sign in with Google!"),
    "got_it_label" : MessageLookupByLibrary.simpleMessage("GOT IT"),
    "home_address_subtitle_label" : m0,
    "home_address_title_label" : MessageLookupByLibrary.simpleMessage("Set home address"),
    "invalidFieldError" : MessageLookupByLibrary.simpleMessage("Invalid Field"),
    "landscape_layout_mode_subtitle_label" : MessageLookupByLibrary.simpleMessage("Changes layout orientation"),
    "landscape_layout_mode_title_label" : MessageLookupByLibrary.simpleMessage("Landscape layout"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "no_events_description" : MessageLookupByLibrary.simpleMessage("You don\'t have events yet"),
    "no_events_label" : MessageLookupByLibrary.simpleMessage("No events"),
    "non_blocking_generic_error_message" : MessageLookupByLibrary.simpleMessage("Oops! Something went wrong!\n Please try again later!"),
    "non_blocking_no_internet_error_message" : MessageLookupByLibrary.simpleMessage("Looks like you\'re offline! \n Try connection to the Internet!"),
    "notifications_description" : MessageLookupByLibrary.simpleMessage("If you have a task  scheduled, you will receive alerts on your device to remember to execute them. To start the tasks, simply click on the notification icon or respond to the sound alert."),
    "notifications_label" : MessageLookupByLibrary.simpleMessage("NOTIFICATIONS"),
    "ongoing_events" : m1,
    "openQuestionLabel" : MessageLookupByLibrary.simpleMessage("Answer"),
    "open_outside_link" : MessageLookupByLibrary.simpleMessage("Start"),
    "question_label" : MessageLookupByLibrary.simpleMessage("Question"),
    "refresh_label" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "sensem_description" : MessageLookupByLibrary.simpleMessage("SENSEM is an application used to receive and execute tasks. Your doctor, your therapist, your family or even you can schedule these tasks in this website: espim.com.br"),
    "sensem_label" : MessageLookupByLibrary.simpleMessage("SENSEM"),
    "settings_label" : MessageLookupByLibrary.simpleMessage("Settings"),
    "sign_out_label" : MessageLookupByLibrary.simpleMessage("Sign out"),
    "task_flow_pages" : m2,
    "tasks_description" : MessageLookupByLibrary.simpleMessage("The tasks can be varied, such as answering questions, taking a picture, or recording an audio."),
    "tasks_label" : MessageLookupByLibrary.simpleMessage("TASKS"),
    "upload_files" : MessageLookupByLibrary.simpleMessage("Upload files"),
    "upload_files_action_label" : MessageLookupByLibrary.simpleMessage("Touch to upload files"),
    "wait_please_label" : MessageLookupByLibrary.simpleMessage("Wait, please!"),
    "welcome" : MessageLookupByLibrary.simpleMessage("Welcome, ")
  };
}
