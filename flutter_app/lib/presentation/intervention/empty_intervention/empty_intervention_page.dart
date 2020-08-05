import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:flutter_app/presentation/intervention/empty_intervention/empty_intervention_bloc.dart';
import 'package:provider/provider.dart';
import 'package:domain/use_case/get_intervention_uc.dart';

import 'empty_intervention_models.dart';

class EmptyInterventionPage extends StatelessWidget {
  const EmptyInterventionPage({@required this.bloc}) : assert(bloc != null);
  final EmptyInterventionBloc bloc;

  static Widget create(int eventId, int pageNumber) =>
      ProxyProvider<GetInterventionUC, EmptyInterventionBloc>(
        update: (context, getInterventionUC, _) => EmptyInterventionBloc(
          eventId: eventId,
          pageNumber: pageNumber,
          getInterventionUC: getInterventionUC,
        ),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<EmptyInterventionBloc>(
          builder: (context, bloc, _) => EmptyInterventionPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: StreamBuilder(
          stream: bloc.onNewState,
          builder: (context, snapshot) => AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (successState) {return Text('deu bom na view!');},
            errorWidgetBuilder: (errorState) {return Text('deu ruim na view');},
          ),
        ),
      );
}
