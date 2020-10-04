import 'package:domain/data_repository/user_data_repository.dart';
import 'package:domain/model/settings.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:meta/meta.dart';

class GetSettingsUC extends UseCase<void, Settings> {
  GetSettingsUC({
    @required this.userRepository,
  }) : assert(userRepository != null);

  final UserDataRepository userRepository;

  @override
  Future<Settings> getRawFuture({void params}) => userRepository.getSettings();
}
