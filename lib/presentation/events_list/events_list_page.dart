import 'package:domain/model/event.dart';
import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:domain/use_case/get_actives_events_list_uc.dart';
import 'package:domain/use_case/get_logged_user_uc.dart';
import 'package:domain/use_case/logout_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:flutter_app/presentation/common/view_utils.dart';
import 'package:provider/provider.dart';

import 'events_list_bloc.dart';
import 'events_list_models.dart';

class EventsListPage extends StatelessWidget {
  const EventsListPage({@required this.bloc}) : assert(bloc != null);
  final EventsListBloc bloc;

  static Widget create() => ProxyProvider3<GetActiveEventsListUC,
          GetLoggedUserUC, LogoutUC, EventsListBloc>(
        update: (context, getEventsListUC, getLoggedUserUC, logoutUC, _) =>
            EventsListBloc(
                getEventsListUC: getEventsListUC,
                getLoggedUserUC: getLoggedUserUC,
                logoutUC: logoutUC),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<EventsListBloc>(
          builder: (context, bloc, _) => EventsListPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final _appBarOptions = [
      S.of(context).settings_label,
      S.of(context).refresh_label,
      S.of(context).sign_out_label,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).events_label),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (_) {},
            itemBuilder: (context) => _appBarOptions
                .map(
                  (choice) => PopupMenuItem<String>(
                    value: choice,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (choice == S.of(context).settings_label) {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(RouteNameBuilder.settingsPage());
                        } else if (choice == S.of(context).sign_out_label) {
                          bloc.onLogout.add(null);
                        } else {
                          bloc.onTryAgain.add(null);
                        }
                      },
                      child: Text(choice),
                    ),
                  ),
                )
                .toList(),
          )
        ],
        backgroundColor: SenSemColors.primaryColor,
      ),
      body: SensemActionListener(
        actionStream: bloc.onActionEvent,
        onReceived: (event) {
          if (event is LogoutSuccess) {
            Navigator.of(context, rootNavigator: false).pushNamedAndRemoveUntil(
                RouteNameBuilder.loginPage(), (_) => false);
          }
        },
        child: StreamBuilder(
          stream: bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (successState) {
              final eventsList = successState.eventsList;
              final user = successState.user;

              return RefreshIndicator(
                onRefresh: () async => bloc.onTryAgain.add(null),
                child: ListView.builder(
                  key: UniqueKey(),
                  itemCount: eventsList.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 15, bottom: 15, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).welcome + user.name,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: SenSemColors.mediumGray,
                              ),
                            ),
                            Text(
                              S
                                  .of(context)
                                  .ongoing_events(eventsList.length - 1),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: SenSemColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ProgramCard(
                        event: eventsList[index],
                        borderRadius: 4,
                        index: index,
                      );
                    }
                  },
                ),
              );
            },
            errorWidgetBuilder: (errorState) {
              if (errorState is EmptyListError) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('images/img_empty.png'),
                        Column(
                          children: [
                            Text(
                              S.of(context).no_events_label,
                              style: TextStyle(
                                color: SenSemColors.mediumGray,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4),
                            ),
                            Text(
                              S.of(context).no_events_description,
                              style: TextStyle(
                                color: SenSemColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                        FlatButton(
                          color: SenSemColors.royalBlue,
                          onPressed: () {
                            bloc.onTryAgain.add(null);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                S.of(context).refresh_label,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Text(errorState.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    @required this.event,
    @required this.borderRadius,
    @required this.index,
  })  : assert(event != null),
        assert(borderRadius != null),
        assert(index != null);

  final Event event;
  final double borderRadius;
  final int index;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                RouteNameBuilder.modalInterventionType(
                    event.interventionList[0].type,
                    event.id,
                    1,
                    event.interventionList.length),
                arguments: EventResult(
                  eventId: event.id,
                  startTime: DateTime.now().millisecondsSinceEpoch,
                  interventionsIds: <int>[],
                  interventionResultsList: <InterventionResult>[],
                  eventTrigger: event.eventTriggerList[0].id,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: SenSemColors.lightWhite,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 7,
                    decoration: BoxDecoration(
                      color: event.color.toColor(),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 12, right: 12),
                      child: Text(
                        index.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height / 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              //maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.height / 37,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              event.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.height / 39,
                                color: SenSemColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
