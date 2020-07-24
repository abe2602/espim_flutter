import 'package:domain/exceptions.dart';
import 'package:flutter_app/common/main_container/main_container_models.dart';
import 'package:hive/hive.dart';

class UserCDS {
  static const _landingPageBoxKey = 'landingPageBoxKey';

  Future<Box> _openLandingPageBox() => Hive.openBox(_landingPageBoxKey);

  Future<bool> checkHasShownLandingPage() => _openLandingPageBox().then(
        (box) => box.get(_landingPageBoxKey)??false
      );

  Future<void> markLandingPageAsSeen() =>
      _openLandingPageBox()
          .then((box) => box.put(_landingPageBoxKey, true));
}
