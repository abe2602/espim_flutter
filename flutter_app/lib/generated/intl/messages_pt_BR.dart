// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
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
  String get localeName => 'pt_BR';

  static m0(howMany) => "${Intl.plural(howMany, one: '1 evento em andamento', other: '${howMany} eventos em andamento')}";

  static m1(currentPage, flowSize) => "Tarefa ${currentPage} de ${flowSize}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "begin_label" : MessageLookupByLibrary.simpleMessage("COMEÇAR"),
    "change_file_label" : MessageLookupByLibrary.simpleMessage("Substituir arquivo"),
    "emptyFieldError" : MessageLookupByLibrary.simpleMessage("Campo Vazio"),
    "events_label" : MessageLookupByLibrary.simpleMessage("Eventos"),
    "finish" : MessageLookupByLibrary.simpleMessage("Finalizar"),
    "google_sign_in" : MessageLookupByLibrary.simpleMessage("Entre com o Google!"),
    "got_it_label" : MessageLookupByLibrary.simpleMessage("ENTENDI"),
    "invalidFieldError" : MessageLookupByLibrary.simpleMessage("Formato Invalido"),
    "next" : MessageLookupByLibrary.simpleMessage("Continuar"),
    "no_events_description" : MessageLookupByLibrary.simpleMessage("Você ainda não possui eventos"),
    "no_events_label" : MessageLookupByLibrary.simpleMessage("Nenhum evento"),
    "non_blocking_generic_error_message" : MessageLookupByLibrary.simpleMessage("Oops! Alguma coisa deu errado. \n Tente novamente mais tarde!"),
    "non_blocking_no_internet_error_message" : MessageLookupByLibrary.simpleMessage("Parece que você está offline \n Tente se conectar à uma rede Wifi!"),
    "notifications_description" : MessageLookupByLibrary.simpleMessage("Se existir uma tarefa agendada, você receberá alertas em seu dispositivo como lembrete para executa-las. Para começar uma tarefa, simplesmente clique na notificação ou responda ao alarme."),
    "notifications_label" : MessageLookupByLibrary.simpleMessage("NOTIFICAÇÃO"),
    "ongoing_events" : m0,
    "open_outside_link" : MessageLookupByLibrary.simpleMessage("Iniciar"),
    "question_label" : MessageLookupByLibrary.simpleMessage("Pergunta"),
    "refresh_label" : MessageLookupByLibrary.simpleMessage("Atualizar"),
    "sensem_description" : MessageLookupByLibrary.simpleMessage("SENSEM é um aplicativo utilizado para receber e executar tarefas. Seu médico, terapeuta, família, e ainda é possível agendar tarefas no website: espim.com.br"),
    "sensem_label" : MessageLookupByLibrary.simpleMessage("SENSEM"),
    "settings_label" : MessageLookupByLibrary.simpleMessage("Configurações"),
    "sign_out_label" : MessageLookupByLibrary.simpleMessage("Sair"),
    "task_flow_pages" : m1,
    "tasks_description" : MessageLookupByLibrary.simpleMessage("Existe uma variedade de tarefas, como responder perguntas, tirar uma foto, ou gravar um áudio."),
    "tasks_label" : MessageLookupByLibrary.simpleMessage("TAREFAS"),
    "upload_files" : MessageLookupByLibrary.simpleMessage("Upload de arquivo"),
    "upload_files_action_label" : MessageLookupByLibrary.simpleMessage("Toque parea fazer o upload do arquivo"),
    "welcome" : MessageLookupByLibrary.simpleMessage("Bem vindo, ")
  };
}
