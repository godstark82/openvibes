import 'package:flutter/material.dart';
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
import 'package:openvibes2/Screens/Player/audioplayer.dart';
import 'package:openvibes2/Screens/Search/search.dart';
import 'package:openvibes2/Screens/Settings/new_settings_page.dart';
import 'package:openvibes2/Screens/Top%20Charts/top.dart';
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
    // defaultValue: ['Home', 'Top Charts', 'YouTube', 'Library'],
    defaultValue: [
      'Home',
      'Search',
      'Top Charts',
      'Library',
    ],
  ) as List;
  DateTime? backButtonPressTime;
  final bool useDense = false;

  void callback() {
    sectionsToShow = Hive.box('settings').get(
      'sectionsToShow',
      // defaultValue: ['Home', 'Youtube', 'Library'],
      defaultValue: [
        'Home',
        'Search',
        'Top Charts',
        'Library',
      ],
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
        backgroundColor: Colors.black,
        body: Container(
          decoration:  const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(159, 102, 7, 0),
              Color.fromARGB(160, 0, 57, 104),
            ],
          ),),
          child: Row(
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
                              return const NavigationRailDestination(
                                icon: Icon(Icons.home_rounded),
                                label: Text('Home'),
                              );
                            case 'Top Charts':
                              return const NavigationRailDestination(
                                icon: Icon(Icons.trending_up_rounded),
                                label: Text('Top Charts'),
                              );
                            case 'Library':
                              return const NavigationRailDestination(
                                icon: Icon(Icons.library_music_rounded),
                                label: Text('Library'),
                              );
                            case 'Search':
                              return const NavigationRailDestination(
                                icon: Icon(Icons.search),
                                label: Text('Search'),
                              );
                            default:
                              return const NavigationRailDestination(
                                icon: Icon(Icons.settings_rounded),
                                label: Text(
                                  'Search',
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
                        return const SafeArea(
                          child: TopCharts(
                          ),
                        );

                      case 'Library':
                        return const SafeArea(child: LibraryPage());
                      case 'Search':
                        return const SearchPage(
                          query: '',
                          fromHome: true,
                          autofocus: true,
                          // autofocus: true,
                        );
                      default:
                        return NewSettingsPage(callback: callback);
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CustomBottomNavBarItem> _navBarItems(BuildContext context) {
    return sectionsToShow.map((section) {
      switch (section) {
        case 'Home':
          return CustomBottomNavBarItem(
            selectedIcon: const Icon(Icons.home_filled),
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Top Charts':
          return CustomBottomNavBarItem(
            selectedIcon: const Icon(Icons.trending_up),
            icon: const Icon(Icons.trending_up_outlined),
            title: const Text('Top Charts'),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Library':
          return CustomBottomNavBarItem(
            selectedIcon: const Icon(Icons.library_music),
            icon: const Icon(Icons.my_library_music_outlined),
            title: const Text('Library'),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        case 'Search':
          return CustomBottomNavBarItem(
            selectedIcon: const Icon(MdiIcons.clipboardTextSearch
            ),
            icon: const Icon(Icons.search_outlined),
            title: const Text('Search'),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        default:
          return CustomBottomNavBarItem(
            selectedIcon: const Icon(Icons.settings),
            icon: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
      }
    }).toList();
  }
}
