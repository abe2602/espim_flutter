import 'package:meta/meta.dart';

class Character {
  const Character(
      {@required this.id, @required this.name, @required this.imgUrl})
      : assert(id != null),
        assert(name != null),
        assert(imgUrl != null);

  final int id;
  final String name;
  final String imgUrl;
}
