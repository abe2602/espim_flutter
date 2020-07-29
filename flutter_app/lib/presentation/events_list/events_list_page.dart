import 'package:domain/model/event.dart';
import 'package:domain/use_case/get_events_list_uc.dart';
import 'package:domain/use_case/get_logged_user_uc.dart';
import 'package:domain/use_case/logout_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:provider/provider.dart';

import 'events_list_bloc.dart';
import 'events_list_models.dart';

class EventsListPage extends StatelessWidget {
  const EventsListPage({@required this.bloc}) : assert(bloc != null);
  final EventsListBloc bloc;

  static Widget create() => ProxyProvider3<GetEventsListUC, GetLoggedUserUC,
          LogoutUC, EventsListBloc>(
        update: (context, getCharacterListUC, getLoggedUserUC, logoutUC, _) =>
            EventsListBloc(
                getCharacterListUC: getCharacterListUC,
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
            onSelected: (context) {},
            itemBuilder: (context) => _appBarOptions
                .map(
                  (choice) => PopupMenuItem<String>(
                    value: choice,
                    child: GestureDetector(
                      onTap: () {
                        if (choice == S.of(context).settings_label) {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed('settings');
                        } else if (choice == S.of(context).sign_out_label) {
                          bloc.onLogout.add(null);
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
            Navigator.of(context, rootNavigator: false)
                .pushNamedAndRemoveUntil(
                'login', (route) => false);
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
                      return EventCard(
                        event: eventsList[index],
                        borderRadius: 4,
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

class EventCard extends StatelessWidget {
  const EventCard({@required this.event, @required this.borderRadius})
      : assert(event != null),
        assert(borderRadius != null);

  final Event event;
  final double borderRadius;

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
              Navigator.of(context).pushNamed('details');
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
                    height: 75,
                    decoration: BoxDecoration(
                      color: SenSemColors.royalBlue,
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
                        event.id.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          event.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: SenSemColors.mediumGray,
                          ),
                        ),
                        Text(
                          event.owner,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: SenSemColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
