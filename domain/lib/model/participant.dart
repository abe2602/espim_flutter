import 'package:meta/meta.dart';

class Participant {
  Participant({
    @required this.id,
    @required this.name,
    @required this.email,
    this.nickName,
    this.phoneNumber,
    this.profileImageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null);

  final int id;

  final String name;

  final String email;

  final String phoneNumber;

  final String profileImageUrl;

  final String nickName;
}
