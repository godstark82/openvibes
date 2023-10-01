// ignore_for_file: unreachable_from_main, avoid_print, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable, require_trailing_commas

import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:openvibes2/Helpers/config.dart';
import 'package:openvibes2/Helpers/handle_native.dart';
import 'package:openvibes2/Helpers/import_export_playlist.dart';
import 'package:openvibes2/Helpers/logging.dart';
import 'package:openvibes2/Helpers/route_handler.dart';
import 'package:openvibes2/Screens/Common/routes.dart';
import 'package:openvibes2/Screens/Player/audioplayer.dart';
import 'package:openvibes2/constants/constants.dart';
import 'package:openvibes2/constants/languagecodes.dart';
import 'package:openvibes2/firebase_options.dart';
import 'package:openvibes2/no_entry.dart';
import 'package:openvibes2/providers/audio_service_provider.dart';
import 'package:openvibes2/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkNetworkConnection();
  await getActivationCode();
  Paint.enableDithering = true;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('OpenVibes');
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await Hive.initFlutter();
  }
  for (final box in hiveBoxes) {
    await openHiveBox(
      box['name'].toString(),
      limit: box['limit'] as bool? ?? false,
    );
  }
  if (Platform.isAndroid) {
    setOptimalDisplayMode();
  }
  await startService();
  // runApp(checkActivation());
  runApp(const NoEntry());
}

Future<void> getActivationCode() async {
  const url =
      'https://app-direct-link.blogspot.com/2023/06/activator-for-open-vibes.html';
  final response = await http.get(Uri.parse(url));
  final body = response.body;
  final html = parse(body);
  final title = html.getElementById('post-body-8767850006469421885 > h1');
  activationCode = title!.text;
  print('ActivationCode:  $activationCode');
}

Future<void> checkNetworkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      internetAvailable = true;
    }
  } on SocketException catch (_) {
    internetAvailable = false;
  }
}

Widget checkActivation() {
  if (activationCode == '1' && internetAvailable == true) {
    return MyApp();
  } else if (activationCode == '0' || internetAvailable == false) {
    return const NoEntry();
  } else {
    return const MaterialApp(home: Center(child: Text('Error')));
  }
}

Future<void> setOptimalDisplayMode() async {
  await FlutterDisplayMode.setHighRefreshRate();
  // final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  // final DisplayMode active = await FlutterDisplayMode.active;

  // final List<DisplayMode> sameResolution = supported
  //     .where(
  //       (DisplayMode m) => m.width == active.width && m.height == active.height,
  //     )
  //     .toList()
  //   ..sort(
  //     (DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate),
  //   );

  // final DisplayMode mostOptimalMode =
  //     sameResolution.isNotEmpty ? sameResolution.first : active;

  // await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

Future<void> startService() async {
  await initializeLogging();
  MetadataGod.initialize();
  final audioHandlerHelper = AudioHandlerHelper();
  final AudioPlayerHandler audioHandler =
      await audioHandlerHelper.getAudioHandler();
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
  GetIt.I.registerSingleton<MyTheme>(MyTheme());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    Logger.root.severe('Failed to open $boxName Box', error, stackTrace);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/openvibes2/$boxName.hive');
      lockFile = File('$dirPath/openvibes2/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

/// Called when Doing Background Work initiated from Widget
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? data) async {
  if (data?.host == 'controls') {
    final audioHandler = await AudioHandlerHelper().getAudioHandler();
    if (data?.path == '/play') {
      audioHandler.play();
    } else if (data?.path == '/pause') {
      audioHandler.pause();
    } else if (data?.path == '/skipNext') {
      audioHandler.skipToNext();
    } else if (data?.path == '/skipPrevious') {
      audioHandler.skipToPrevious();
    }

    // await HomeWidget.saveWidgetData<String>(
    //   'title',
    //   audioHandler?.mediaItem.value?.title,
    // );
    // await HomeWidget.saveWidgetData<String>(
    //   'subtitle',
    //   audioHandler?.mediaItem.value?.displaySubtitle,
    // );
    // await HomeWidget.updateWidget(name: 'openvibes2MusicWidget');
  }
}

class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  late StreamSubscription _intentTextStreamSubscription;
  late StreamSubscription _intentDataStreamSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    _intentTextStreamSubscription.cancel();
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('com.venom82.openvibes2');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
    final String systemLangCode = Platform.localeName.substring(0, 2);
    if (LanguageCodes.languageCodes.values.contains(systemLangCode)) {
      _locale = Locale(systemLangCode);
    } else {
      final String lang =
          Hive.box('settings').get('lang', defaultValue: 'English') as String;
      _locale = Locale(LanguageCodes.languageCodes[lang] ?? 'en');
    }

    AppTheme.currentTheme.addListener(() {
      setState(() {});
    });

    if (Platform.isAndroid || Platform.isIOS) {
      // For sharing or opening urls/text coming from outside the app while the app is in the memory
      _intentTextStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen(
        (String value) {
          Logger.root.info('Received intent on stream: $value');
          handleSharedText(value, navigatorKey);
        },
        onError: (err) {
          Logger.root.severe('ERROR in getTextStream', err);
        },
      );

      // For sharing or opening urls/text coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialText().then(
        (String? value) {
          Logger.root.info('Received Intent initially: $value');
          if (value != null) handleSharedText(value, navigatorKey);
        },
        onError: (err) {
          Logger.root.severe('ERROR in getInitialTextStream', err);
        },
      );

      // For sharing files coming from outside the app while the app is in the memory
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getMediaStream().listen(
        (List<SharedMediaFile> value) {
          if (value.isNotEmpty) {
            for (final file in value) {
              if (file.path.endsWith('.json')) {
                final List playlistNames = Hive.box('settings')
                        .get('playlistNames')
                        ?.toList() as List? ??
                    ['Favorite Songs'];
                importFilePlaylist(
                  null,
                  playlistNames,
                  path: file.path,
                  pickFile: false,
                ).then(
                  (value) => navigatorKey.currentState?.pushNamed('/playlists'),
                );
              }
            }
          }
        },
        onError: (err) {
          Logger.root.severe('ERROR in getDataStream', err);
        },
      );

      // For sharing files coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialMedia()
          .then((List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          for (final file in value) {
            if (file.path.endsWith('.json')) {
              final List playlistNames = Hive.box('settings')
                      .get('playlistNames')
                      ?.toList() as List? ??
                  ['Favorite Songs'];
              importFilePlaylist(
                null,
                playlistNames,
                path: file.path,
                pickFile: false,
              ).then(
                (value) => navigatorKey.currentState?.pushNamed('/playlists'),
              );
            }
          }
        }
      });
    }
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: AppTheme.themeMode == ThemeMode.system
            ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                ? Brightness.light
                : Brightness.dark
            : AppTheme.themeMode == ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarIconBrightness:
            AppTheme.themeMode == ThemeMode.system
                ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark
                : AppTheme.themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizerUtil.setScreenSize(constraints, orientation);
              return MaterialApp(
                title: 'OpenVibes 2.0',
                restorationScopeId: 'openvibes2',
                debugShowCheckedModeBanner: false,
                themeMode: AppTheme.themeMode,
                theme: AppTheme.lightTheme(
                  context: context,
                ),
                darkTheme: AppTheme.darkTheme(
                  context: context,
                ),
                locale: _locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: LanguageCodes.languageCodes.entries
                    .map((languageCode) => Locale(languageCode.value, ''))
                    .toList(),
                routes: namedRoutes,
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
            },
          );
        },
      ),
    );
  }
}
