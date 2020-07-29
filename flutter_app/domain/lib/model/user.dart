import 'package:meta/meta.dart';

class User {
  const User(
      {@required this.id,
      @required this.name})
      : assert(id != null),
        assert(name != null);

  final int id;
  final String name;
}
