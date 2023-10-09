import 'package:flutter/material.dart';
import 'package:openvibes2/Helpers/route_handler.dart';
import 'package:openvibes2/Screens/Common/routes.dart';
import 'package:openvibes2/Screens/Player/audioplayer.dart';
import 'package:openvibes2/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenVibes 2.0',
      restorationScopeId: 'openvibes2',
      debugShowCheckedModeBanner: false,
      themeMode: AppTheme.themeMode,
      // theme: AppTheme.lightTheme(
      // context: context,
      // ),
      darkTheme: AppTheme.darkTheme(
        context: context,
      ),
      routes: namedRoutesForNoInternet,
      navigatorKey: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/player') {
          return PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => const PlayScreen(),
          );
        }
        return HandleRoute.handleRoute(settings.name);
      },
    );
  }
}
