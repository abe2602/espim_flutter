import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

extension RouteFactoryGenerator on Router {
  Route<dynamic> routeGeneratorFactory(
      BuildContext context, RouteSettings routeSettings) =>
      matchRoute(context, routeSettings.name, routeSettings: routeSettings)
          .route;
}