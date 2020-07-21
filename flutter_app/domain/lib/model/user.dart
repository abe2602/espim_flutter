import 'package:meta/meta.dart';

class User {
  const User(
      {@required this.id,
      @required this.name,
      @required this.accompanimentNumber})
      : assert(id != null),
        assert(name != null),
        assert(accompanimentNumber != null);

  final int id;
  final int accompanimentNumber;
  final String name;
}
