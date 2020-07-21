import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/async_snapshot_response_view.dart';
import 'package:provider/provider.dart';
import 'package:domain/use_case/get_character_list_uc.dart';
import 'character_list_bloc.dart';
import 'character_list_models.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({@required this.bloc}) : assert(bloc != null);
  final CharacterListPageBloc bloc;

  static Widget create(BuildContext context) =>
      ProxyProvider<GetCharacterListUC, CharacterListPageBloc>(
        update: (context, getCharacterListUC, _) =>
            CharacterListPageBloc(getCharacterListUC: getCharacterListUC),
        child: Consumer<CharacterListPageBloc>(
          builder: (context, bloc, _) => CharacterListPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('Hey!');
              },
            ),
          ],
          backgroundColor: const Color(0xff125193),
        ),
        body: StreamBuilder(
          stream: bloc.onNewState,
          builder: (context, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (successState) {
              final characterList = successState.characterList;
              final user = successState.user;

              return ListView.builder(
                  key: UniqueKey(),
                  itemCount: characterList.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Text(user.name),
                          Text(user.name),
                          Text(user.name),
                        ],
                      );
                    } else {
                      return CharacterCard(
                        name: characterList[index].name,
                        id: characterList[index].id,
                      );
                    }
                  });
            },
            errorWidgetBuilder: (errorState) => Text(errorState.toString()),
          ),
        ),
      );
}

class CharacterCard extends StatelessWidget {
  const CharacterCard({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
        child: Material(
          elevation: 2,
          //shadowColor: Colors.white,
          type: MaterialType.transparency,
          child: Ink(
            color: Colors.orange,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('details');
              },
              child: Row(
                children: [
                  Container(
                    color: const Color(0xff1976d5),
                    child: Text(
                      id.toString(),
                    ),
                  ),
                  Column(
                    children: [
                      Text(name),
                      Text(name),
                      Text(name),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
