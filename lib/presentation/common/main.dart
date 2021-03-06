import 'package:domain/model/event_result.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/cache/model/complex_condition_cm.dart';
import 'package:flutter_app/data/cache/model/event_cm.dart';
import 'package:flutter_app/data/cache/model/event_trigger_cm.dart';
import 'package:flutter_app/data/cache/model/intervention_cm.dart';
import 'package:flutter_app/data/cache/model/media_information_cm.dart';
import 'package:flutter_app/data/cache/model/observer_cm.dart';
import 'package:flutter_app/data/cache/model/participant_cm.dart';
import 'package:flutter_app/data/cache/model/program_cm.dart';
import 'package:flutter_app/data/cache/model/sensor_cm.dart';
import 'package:flutter_app/data/cache/model/settings_cm.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/auth/login/login_page.dart';
import 'package:flutter_app/presentation/common/general_provider.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/events_list/events_list_page.dart';
import 'package:flutter_app/presentation/intervention/empty_intervention/empty_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/record_audio_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/record_video_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/media_intervention/take_picture_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/closed_question_intervention/closed_question_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/custom_likert_intervention/custom_likert_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/likert_intervention/likert_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/multiple_answer_intervention/multiple_answer_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/open_question_intervention/open_question_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/question_intervention/semantic_diff_intervention/semantic_diff_intervention_page.dart';
import 'package:flutter_app/presentation/intervention/task_intervention/task_intervention_page.dart';
import 'package:flutter_app/presentation/settings/settings_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'main_container/main_container_screen.dart';

//todo: Estou tendo problemas para injetar o Fluro
// então irei seguir sem a injeção, fazendo "na mão"
// volto aqui depois
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Hive.initFlutter();
  Hive
    ..init((await getApplicationDocumentsDirectory()).path)
    ..registerAdapter(EventCMAdapter())
    ..registerAdapter(ComplexConditionCMAdapter())
    ..registerAdapter(EventTriggerCMAdapter())
    ..registerAdapter(InterventionCMAdapter())
    ..registerAdapter(MediaInformationCMAdapter())
    ..registerAdapter(ObserverCMAdapter())
    ..registerAdapter(ParticipantCMAdapter())
    ..registerAdapter(ProgramCMAdapter())
    ..registerAdapter(SensorCMAdapter())
    ..registerAdapter(SettingsCMAdapter());

  Router.appRouter
    ..define(
      RouteNameBuilder.root,
      transitionType: TransitionType.nativeModal,
      handler: Handler(
        handlerFunc: (context, _) => MainContainerScreen.create(),
      ),
    )
    ..define(
      RouteNameBuilder.accompaniment,
      transitionType: TransitionType.native,
      handler: Handler(
        handlerFunc: (context, _) => EventsListPage.create(),
      ),
    )
    ..define(
      '${RouteNameBuilder.taskIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return TaskInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.emptyIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return EmptyInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.multiQuestionIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return MultipleAnswerInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.openQuestionIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return OpenQuestionInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.closedQuestionIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return ClosedQuestionInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.likertIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return LikertInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.customLikertIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return CustomLikertInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.semanticDiffIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return SemanticDiffInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.recordVideoIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return RecordVideoInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.recordAudioIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return RecordAudioInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.takePictureIntervention}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return TakePictureInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.taskInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return TaskInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.emptyInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return EmptyInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.likertInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return LikertInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.customLikertInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return CustomLikertInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.semanticDiffInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return SemanticDiffInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.multiQuestionInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return MultipleAnswerInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.openQuestionInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return OpenQuestionInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.closedQuestionInterventionModal}/:id',
      transitionType: TransitionType.nativeModal,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return ClosedQuestionInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.recordVideoInterventionModal}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return RecordVideoInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.recordAudioInterventionModal}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return RecordAudioInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      '${RouteNameBuilder.takePictureInterventionModal}/:id',
      transitionType: TransitionType.native,
      handler: Handler(handlerFunc: (context, params) {
        final EventResult eventResult =
            ModalRoute.of(context).settings.arguments;

        return TakePictureInterventionPage.create(
          int.parse(params['id'][0]),
          int.parse(params['orderPosition'][0]),
          int.parse(params['flowSize'][0]),
          eventResult,
        );
      }),
    )
    ..define(
      RouteNameBuilder.login,
      transitionType: TransitionType.native,
      handler: Handler(
        handlerFunc: (context, _) => LoginPage.create(),
      ),
    )
    ..define(
      RouteNameBuilder.settings,
      transitionType: TransitionType.native,
      handler: Handler(
        handlerFunc: (context, _) => SettingsPage.create(),
      ),
    );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GeneralProvider(
        child: MaterialApp(
          title: 'Sensem',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          onGenerateRoute: (settings) => Router.appRouter
              .matchRoute(context, settings.name, routeSettings: settings)
              .route,
        ),
      );
}
