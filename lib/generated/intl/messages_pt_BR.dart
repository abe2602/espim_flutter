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

  static m0(address) => "Endereço atual: ${address}";

  static m1(howMany) => "${Intl.plural(howMany, one: '1 evento em andamento', other: '${howMany} eventos em andamento')}";

  static m2(currentPage, flowSize) => "Tarefa ${currentPage} de ${flowSize}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "begin_label" : MessageLookupByLibrary.simpleMessage("COMEÇAR"),
    "change_file_label" : MessageLookupByLibrary.simpleMessage("Substituir arquivo"),
    "delete_medias_subtitle_label" : MessageLookupByLibrary.simpleMessage("Apague as mídias baixadas e capturadas pelo SENSEM"),
    "delete_medias_title_label" : MessageLookupByLibrary.simpleMessage("Apagar mídias para liberar espaço"),
    "empty_field_error" : MessageLookupByLibrary.simpleMessage("Campo Vazio"),
    "enable_mobile_network_subtitle_label" : MessageLookupByLibrary.simpleMessage("Habilitar ou desbilitar uso de 3G/4G"),
    "enable_mobile_network_title_label" : MessageLookupByLibrary.simpleMessage("Habilitar uso de rede movel"),
    "enable_notifications_subtitle_label" : MessageLookupByLibrary.simpleMessage("Habilitar notificações"),
    "enable_notifications_title_label" : MessageLookupByLibrary.simpleMessage("Habilitar notificações de mídias agendadas"),
    "events_label" : MessageLookupByLibrary.simpleMessage("Eventos"),
    "finish" : MessageLookupByLibrary.simpleMessage("Finalizar"),
    "generic_error_button_text" : MessageLookupByLibrary.simpleMessage("Fechar"),
    "generic_error_primary_text" : MessageLookupByLibrary.simpleMessage("Oops! Algo não está certo."),
    "generic_error_secondary_text" : MessageLookupByLibrary.simpleMessage("Tente novamente mais tarde."),
    "google_sign_in" : MessageLookupByLibrary.simpleMessage("Entre com o Google!"),
    "got_it_label" : MessageLookupByLibrary.simpleMessage("ENTENDI"),
    "home_address_subtitle_label" : m0,
    "home_address_title_label" : MessageLookupByLibrary.simpleMessage("Defina seu endereço"),
    "invalid_field_error" : MessageLookupByLibrary.simpleMessage("Formato Invalido"),
    "landscape_layout_mode_subtitle_label" : MessageLookupByLibrary.simpleMessage("Mudar a orientação da tela"),
    "landscape_layout_mode_title_label" : MessageLookupByLibrary.simpleMessage("Tela na horizontal"),
    "next" : MessageLookupByLibrary.simpleMessage("Continuar"),
    "no_events_description" : MessageLookupByLibrary.simpleMessage("Você ainda não possui eventos"),
    "no_events_label" : MessageLookupByLibrary.simpleMessage("Nenhum evento"),
    "no_internet_button_text" : MessageLookupByLibrary.simpleMessage("Fechar"),
    "no_internet_primary_text" : MessageLookupByLibrary.simpleMessage("Parece que você está sem internet!"),
    "no_internet_secondary_text" : MessageLookupByLibrary.simpleMessage("Tente se conectar à uma rede."),
    "notifications_description" : MessageLookupByLibrary.simpleMessage("Se existir uma tarefa agendada, você receberá alertas em seu dispositivo como lembrete para executa-las. Para começar uma tarefa, simplesmente clique na notificação ou responda ao alarme."),
    "notifications_label" : MessageLookupByLibrary.simpleMessage("NOTIFICAÇÃO"),
    "ongoing_events" : m1,
    "open_outside_link" : MessageLookupByLibrary.simpleMessage("Iniciar"),
    "open_question_label" : MessageLookupByLibrary.simpleMessage("Pergunta"),
    "permission_denied_permanently_primary_button_text" : MessageLookupByLibrary.simpleMessage("Configurações"),
    "permission_denied_permanently_primary_text" : MessageLookupByLibrary.simpleMessage("Você precisa de permissões para continuar!"),
    "permission_denied_permanently_secondary_button_text" : MessageLookupByLibrary.simpleMessage("Fechar"),
    "permission_denied_permanently_secondary_text" : MessageLookupByLibrary.simpleMessage("Clique em Configurações e adicione-as."),
    "permission_denied_primary_button_text" : MessageLookupByLibrary.simpleMessage("Fechar"),
    "permission_denied_primary_text" : MessageLookupByLibrary.simpleMessage("Parece que você negou a permissão!"),
    "permission_denied_secondary_text" : MessageLookupByLibrary.simpleMessage("Por favor, tente novamente."),
    "record_audio_label" : MessageLookupByLibrary.simpleMessage("PRESSIONE PARA GRAVAR"),
    "refresh_label" : MessageLookupByLibrary.simpleMessage("Atualizar"),
    "sensem_description" : MessageLookupByLibrary.simpleMessage("SENSEM é um aplicativo utilizado para receber e executar tarefas. Seu médico, terapeuta, família, e ainda é possível agendar tarefas no website: espim.com.br"),
    "sensem_label" : MessageLookupByLibrary.simpleMessage("SENSEM"),
    "settings_label" : MessageLookupByLibrary.simpleMessage("Configurações"),
    "sign_out_label" : MessageLookupByLibrary.simpleMessage("Sair"),
    "task_flow_pages" : m2,
    "tasks_description" : MessageLookupByLibrary.simpleMessage("Existe uma variedade de tarefas, como responder perguntas, tirar uma foto, ou gravar um áudio."),
    "tasks_label" : MessageLookupByLibrary.simpleMessage("TAREFAS"),
    "upload_files" : MessageLookupByLibrary.simpleMessage("Upload de arquivo"),
    "upload_files_action_label" : MessageLookupByLibrary.simpleMessage("Toque parea fazer o upload do arquivo"),
    "wait_please_label" : MessageLookupByLibrary.simpleMessage("Aguarde, por favor!"),
    "welcome" : MessageLookupByLibrary.simpleMessage("Bem vindo, ")
  };
}
