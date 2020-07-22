import 'package:domain/exceptions.dart';
import 'package:domain/model/character.dart';
import 'package:domain/use_case/get_character_list_uc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/presentation/character_list/character_list_models.dart';
import 'package:flutter_app/presentation/common/subscription_bag.dart';
import 'package:rxdart/rxdart.dart';
import 'package:domain/model/user.dart';

class CharacterListBloc with SubscriptionBag {
  CharacterListBloc({@required this.getCharacterListUC})
      : assert(getCharacterListUC != null) {
    MergeStream([
      _getCharacterList(),
    ]).listen(_onNewStateSubject.add).addTo(subscriptionsBag);
  }

  final GetCharacterListUC getCharacterListUC;

  final _onNewStateSubject = BehaviorSubject<CharacterListResponseState>();
  final _onTryAgainSubject = PublishSubject<void>();

  Stream<CharacterListResponseState> get onNewState => _onNewStateSubject;

  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<CharacterListResponseState> _getCharacterList() async* {
    yield Loading();

    try {
      final characterListAux = await getCharacterListUC.getFuture();
      final characterList = <Character>[null];

      characterListAux.forEach(characterList.add);

      yield Success(
        characterList: characterList,
        user: const User(id: 1, name: 'Bruno', accompanimentNumber: 5),
      );
    } catch (error) {
      print(error.toString());
      if (error is NoInternetException) {
        yield NoInternetError();
      } else {
        yield GenericError();
      }
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
  }

}
