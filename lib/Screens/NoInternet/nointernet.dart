import 'package:flutter/material.dart';
import 'package:openvibes2/Screens/Library/downloads.dart';
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
      home:const Downloads(),
    );
  }
}
