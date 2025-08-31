import 'package:flutter/material.dart';
import 'route_constants.dart';
import 'package:launcher/pages/pages.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.home:
        return MaterialPageRoute(
          builder: (_) => const HomePageWidget(),
        );
      case RouteConstants.app:
        return MaterialPageRoute(
          builder: (_) => const AppPageWidget(),
        );
      case RouteConstants.sport:
        return MaterialPageRoute(
          builder: (_) => const SportPageWidget(),
        );
      case RouteConstants.chat:
        return MaterialPageRoute(
          builder: (_) => const ChatPageWidget(),
        );
      case RouteConstants.quick:
        return MaterialPageRoute(
          builder: (_) => const QuickPageWidget(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomePageWidget(),
        );
    }
  }
}