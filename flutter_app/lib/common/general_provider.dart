import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data/remote/data_source/character_rds.dart';
import 'package:flutter_app/data/remote/infrastructure/espim_dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GeneralProvider extends StatelessWidget {
  const GeneralProvider({@required this.child}) : assert(child != null);
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._buildRDSProviders(),
    ],
    child: child,
  );

  List<SingleChildWidget> _buildRDSProviders() => [
    Provider<Dio>(
      create: (context) {
        final options = BaseOptions(
          baseUrl:
          'https://www.breakingbadapi.com/api/',
        );

        return EspimDio(options);
      },
    ),
    ProxyProvider<Dio, CharacterRDS>(
      update: (context, dio, _) => CharacterRDS(dio: dio),
    ),
  ];
}