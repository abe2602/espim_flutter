import 'package:domain/model/event_result.dart';
import 'package:domain/model/intervention_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/loading_indicator.dart';
import 'package:flutter_app/presentation/common/route_name_builder.dart';
import 'package:flutter_app/presentation/common/sensem_action_listener.dart';
import 'package:flutter_app/presentation/intervention/intervention_models.dart';

import 'media_intervention_bloc.dart';

class MediaInterventionBody extends StatelessWidget {
  const MediaInterventionBody({
    @required this.bloc,
    @required this.eventId,
    @required this.flowSize,
    @required this.eventResult,
    @required this.startTime,
    @required this.child,
  })  : assert(bloc != null),
        assert(eventId != null),
        assert(flowSize != null),
        assert(eventResult != null),
        assert(startTime != null),
        assert(child != null);

  final EventResult eventResult;
  final MediaInterventionBloc bloc;
  final Widget child;
  final int eventId;
  final int flowSize;
  final int startTime;

  @override
  Widget build(BuildContext context) =>
      SensemActionListener<InterventionResponseState>(
        actionStream: bloc.onActionEventStream,
        onReceived: (receivedEvent) async {
          if (receivedEvent is UploadLoading) {
            await showDialog(
              context: context,
              child: AlertDialog(
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        S.of(context).wait_please_label,
                      ),
                    ),
                    LoadingIndicator(),
                  ],
                ),
              ),
            );
          } else if (receivedEvent is Success) {
            Navigator.pop(context);
            if (receivedEvent.nextPage == 0) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              eventResult.interventionResultsList.add(
                InterventionResult(
                  interventionType: receivedEvent.intervention.type,
                  startTime: startTime,
                  endTime: DateTime.now().millisecondsSinceEpoch,
                  interventionId: receivedEvent.intervention.interventionId,
                  answer: receivedEvent.mediaUrl,
                ),
              );

              eventResult.interventionsIds
                  .add(receivedEvent.intervention.interventionId);

              await Navigator.of(context).pushNamed(
                RouteNameBuilder.interventionType(
                    receivedEvent.nextInterventionType,
                    eventId,
                    receivedEvent.nextPage,
                    flowSize),
                arguments: eventResult,
              );
            }
          }
        },
        child: child,
      );
}
