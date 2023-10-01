import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:openvibes2/CustomWidgets/bottom_nav_bar.dart';
import 'package:openvibes2/CustomWidgets/drawer.dart';
import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
import 'package:openvibes2/CustomWidgets/miniplayer.dart';
import 'package:openvibes2/Helpers/route_handler.dart';
import 'package:openvibes2/Screens/Common/routes.dart';
import 'package:openvibes2/Screens/Home/home_screen.dart';
import 'package:openvibes2/Screens/Library/library.dart';
import 'package:openvibes2/Screens/LocalMusic/downed_songs.dart';
import 'package:openvibes2/Screens/LocalMusic/downed_songs_desktop.dart';
import 'package:openvibes2/Screens/Player/audioplayer.dart';
import 'package:openvibes2/Screens/Settings/new_settings_page.dart';
import 'package:openvibes2/Screens/Top Charts/top.dart';
import 'package:openvibes2/Screens/YouTube/youtube_home.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  String? appVersion;
  String name =
      Hive.box('settings').get('name', defaultValue: 'Guest') as String;
  bool checkUpdate =
      Hive.box('settings').get('checkUpdate', defaultValue: false) as bool;
  bool autoBackup =
      Hive.box('settings').get('autoBackup', defaultValue: false) as bool;
  List sectionsToShow = Hive.box('settings').get(
    'sectionsToShow',
    defaultValue: ['Home', 'Top Charts', 'YouTube', 'Library'],
  ) as List;
  DateTime? backButtonPressTime;
  final bool useDense = false;

  void callback() {
    sectionsToShow = Hive.box('settings').get(
      'sectionsToShow',
      defaultValue: ['Home', 'Top Charts', 'YouTube', 'Library'],
    ) as List;
    onItemTapped(0);
    setState(() {});
  }

  void onItemTapped(int index) {
    _selectedIndex.value = index;
    _controller.jumpToTab(
      index,
    );
  }

  // Future<bool> handleWillPop(BuildContext? context) async {
  //   if (context == null) return false;
  //   final now = DateTime.now();
  //   final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
  //       backButtonPressTime == null ||
  //           now.difference(backButtonPressTime!) > const Duration(seconds: 3);

  //   if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
  //     backButtonPressTime = now;
  //     ShowSnackBar().showSnackBar(
  //       context,
  //       AppLocalizations.of(context)!.exitConfirm,
  //       duration: const Duration(seconds: 2),
  //       noAction: true,
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  final PageController _pageController = PageController();
  final PersistentTabController _controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    final miniplayer = MiniPlayer();
    return GradientContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: GradientContainer(
            child: CustomScrollView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  stretch: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.2,
                  flexibleSpace: FlexibleSpaceBar(
                    title: RichText(
                      text: TextSpan(
                        text: 'OpenVibes ',
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: appVersion == null ? '' : '\nv$appVersion',
                            style: const TextStyle(
                              fontSize: 7.0,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.end,
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 40.0),
                    centerTitle: true,
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.1),
                          ],
                        ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height),
                        );
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        image: AssetImage(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'assets/header-dark.jpg'
                              : 'assets/header.jpg',
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ValueListenableBuilder(
                        valueListenable: _selectedIndex,
                        builder: (
                          BuildContext context,
                          int snapshot,
                          Widget? child,
                        ) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.home,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                leading: const Icon(
                                  Icons.home_rounded,
                                ),
                                selected: _selectedIndex.value ==
                                    sectionsToShow.indexOf('Home'),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                onTap: () {
                                  Navigator.pop(context);
                                  if (_selectedIndex.value != 0) {
                                    onItemTapped(0);
                                  }
                                },
                              ),
                              ListTile(
                                title:
                                    Text(AppLocalizations.of(context)!.myMusic),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                leading: Icon(
                                  MdiIcons.folderMusic,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          (Platform.isWindows ||
                                                  Platform.isLinux ||
                                                  Platform.isMacOS)
                                              ? const DownloadedSongsDesktop()
                                              : const DownloadedSongs(
                                                  showPlaylists: true,
                                                ),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title:
                                    Text(AppLocalizations.of(context)!.downs),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                leading: Icon(
                                  Icons.download_done_rounded,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/downloads');
                                },
                              ),
                              ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.playlists,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                leading: Icon(
                                  Icons.playlist_play_rounded,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/playlists');
                                },
                              ),
                              ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.settings,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                // miscellaneous_services_rounded,
                                leading: const Icon(Icons.settings_rounded),
                                selected: _selectedIndex.value ==
                                    sectionsToShow.indexOf('Settings'),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                onTap: () {
                                  Navigator.pop(context);
                                  final idx =
                                      sectionsToShow.indexOf('Settings');
                                  if (idx != -1) {
                                    if (_selectedIndex.value != idx) {
                                      onItemTapped(idx);
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NewSettingsPage(callback: callback),
                                      ),
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                title:
                                    Text(AppLocalizations.of(context)!.about),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                leading: Icon(
                                  Icons.info_outline_rounded,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/about');
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 30, 5, 20),
                          child: Center(
                            child: Text(
                              'Made by VENOM',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Row(
          children: [
            if (rotated)
              SafeArea(
                child: ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder:
                      (BuildContext context, int indexValue, Widget? child) {
                    return NavigationRail(
                      minWidth: 70.0,
                      groupAlignment: 0.0,
                      backgroundColor:
                          // Colors.transparent,
                          Theme.of(context).cardColor,
                      selectedIndex: indexValue,
                      onDestinationSelected: (int index) {
                        onItemTapped(index);
                      },
                      labelType: screenWidth > 1050
                          ? NavigationRailLabelType.selected
                          : NavigationRailLabelType.none,
                      selectedLabelTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelTextStyle: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                      ),
                      selectedIconTheme: Theme.of(context).iconTheme.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      unselectedIconTheme: Theme.of(context).iconTheme,
                      useIndicator: screenWidth < 1050,
                      indicatorColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                      leading: homeDrawer(
                        context: context,
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      destinations: sectionsToShow.map((e) {
                        switch (e) {
                          case 'Home':
                            return NavigationRailDestination(
                              icon: const Icon(Icons.home_rounded),
                              label: Text(AppLocalizations.of(context)!.home),
                            );
                          case 'Top Charts':
                            return NavigationRailDestination(
                              icon: const Icon(Icons.trending_up_rounded),
                              label: Text(
                                AppLocalizations.of(context)!.topCharts,
                              ),
                            );
                          case 'YouTube':
                            return NavigationRailDestination(
                              icon: const Icon(MdiIcons.youtube),
                              label:
                                  Text(AppLocalizations.of(context)!.youTube),
                            );
                          case 'Library':
                            return NavigationRailDestination(
                              icon: const Icon(Icons.my_library_music_rounded),
                              label:
                                  Text(AppLocalizations.of(context)!.library),
                            );
                          default:
                            return NavigationRailDestination(
                              icon: const Icon(Icons.settings_rounded),
                              label: Text(
                                AppLocalizations.of(context)!.settings,
                              ),
                            );
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            Expanded(
              child: PersistentTabView.custom(
                context,
                controller: _controller,
                itemCount: sectionsToShow.length,
                navBarHeight: (rotated ? 55 : 55 + 70) + (useDense ? 0 : 15),
                // confineInSafeArea: false,
                onItemTapped: onItemTapped,
                routeAndNavigatorSettings:
                    CustomWidgetRouteAndNavigatorSettings(
                  routes: namedRoutes,
                  onGenerateRoute: (RouteSettings settings) {
                    if (settings.name == '/player') {
                      return PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => const PlayScreen(),
                      );
                    }
                    return HandleRoute.handleRoute(settings.name);
                  },
                ),
                customWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    miniplayer,
                    if (!rotated)
                      ValueListenableBuilder(
                        valueListenable: _selectedIndex,
                        builder: (
                          BuildContext context,
                          int indexValue,
                          Widget? child,
                        ) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 60,
                            child: CustomBottomNavBar(
                              currentIndex: indexValue,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.9)
                                  : Colors.white.withOpacity(0.9),
                              onTap: (index) {
                                onItemTapped(index);
                              },
                              items: _navBarItems(context),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                screens: sectionsToShow.map((e) {
                  switch (e) {
                    case 'Home':
                      return const SafeArea(child: HomeScreen());
                    case 'Top Charts':
                      return SafeArea(
                        child: TopCharts(
                          pageController: _pageController,
                        ),
                      );
                    case 'YouTube':
                      return const SafeArea(child: YouTube());
                    case 'Library':
                      return const LibraryPage();
                    default:
                      return NewSettingsPage(callback: callback);
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CustomBottomNavBarItem> _navBarItems(BuildContext context) {
    return sectionsToShow.map((section) {
      switch (section) {
        case 'Home':
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.home_rounded),
            title: Text(AppLocalizations.of(context)!.home),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Top Charts':
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.trending_up_rounded),
            title: Text(AppLocalizations.of(context)!.topCharts),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'YouTube':
          return CustomBottomNavBarItem(
            icon: const Icon(MdiIcons.youtube),
            title: Text(AppLocalizations.of(context)!.youTube),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Library':
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.my_library_music_rounded),
            title: Text(AppLocalizations.of(context)!.library),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        default:
          return CustomBottomNavBarItem(
            icon: const Icon(Icons.settings_rounded),
            title: Text(AppLocalizations.of(context)!.settings),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
      }
    }).toList();
  }
}
