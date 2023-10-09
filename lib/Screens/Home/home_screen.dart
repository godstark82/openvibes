// ignore_for_file: prefer_const_constructors, require_trailing_commas, avoid_void_async, prefer_single_quotes, avoid_print, unused_local_variable

import 'dart:io';
import 'package:launch_app_store/launch_app_store.dart';
import 'package:openvibes2/CustomWidgets/textinput_dialog.dart';
import 'package:openvibes2/Screens/Home/saavn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:openvibes2/Screens/Settings/new_settings_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isUpdateAvailable = false;
  String globalHeading = 'Ram Ram,';

  @override
  void initState() {
    getNewVersion();
    checkNewMsg();
    super.initState();
  }

  void checkNewMsg() async {
    final response = await http.get(Uri.parse(
        'https://app-direct-link.blogspot.com/2023/09/functions-for-openvibes-20.html'));
    final html = parse(response.body);
    final msgCheck = html.getElementById('msgCheck');
    final msg = html.getElementById('msg');
    final heading = html.getElementById('heading');
    globalHeading = heading!.text;
    setState(() {});
    if (msgCheck?.text == '1') {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('New Message'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${msg?.text}'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'))
              ],
            );
          });
    } else {
      debugPrint('No New MSG');
    }
  }

  void getNewVersion() async {
    const url =
        'https://app-direct-link.blogspot.com/2023/09/functions-for-openvibes-20.html';
    final response = await http.get(Uri.parse(url));
    final body = response.body;
    final html = parse(body);
    final title = html.getElementById('post-body-9176555639996960720 > h2');
    final storeVersion = title?.text;
    String localVersion = '';
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    localVersion = packageInfo.version;
    if (localVersion != storeVersion && Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Update Available'),
              content: Text('There is a new update available on store'),
              actions: [
                TextButton(
                    onPressed: () async {
                     LaunchReview.launch(androidAppId: 'com.venom82.openvibes2'); 
                      // await launchUrl(Uri.parse(
                      //     'https://play.google.com/store/apps/details?id=com.venom82.openvibes2'),mode: LaunchMode.externalApplication);
                    },
                    child: Text('Download')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Later')),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String name =
        Hive.box('settings').get('name', defaultValue: 'Guest') as String;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    return Stack(
      children: [
        NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxScrolled,
          ) {
            return <Widget>[
              // SliverAppBar(
              //   backgroundColor: Colors.transparent,
              //   elevation: 0,
              //   automaticallyImplyLeading: false,
              //   centerTitle: true,
              //   title: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'OpenVibes',
              //         style: TextStyle(fontSize: 22),
              //       ),
              //     ],
              //   ),
              // ),

              SliverAppBar(
                expandedHeight: 100,
                backgroundColor: Colors.transparent,
                elevation: 0,
                // pinned: true,
                toolbarHeight: 65,
                // floating: true,
                automaticallyImplyLeading: false,
                flexibleSpace: LayoutBuilder(
                  builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    return FlexibleSpaceBar(
                      // collapseMode: CollapseMode.parallax,
                      background: GestureDetector(
                        onTap: () async {
                          showTextInputDialog(
                            context: context,
                            title: 'Name',
                            initialText: name,
                            keyboardType: TextInputType.name,
                            onSubmitted: (String value, BuildContext context) {
                              Hive.box('settings').put(
                                'name',
                                value.trim(),
                              );
                              // name = value.trim();
                              Navigator.pop(context);
                            },
                          );
                          // setState(() {});
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                        ),
                                        child: Text(
                                          globalHeading,
                                          style: TextStyle(
                                            letterSpacing: 2,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: Hive.box(
                                            'settings',
                                          ).listenable(),
                                          builder: (
                                            BuildContext context,
                                            Box box,
                                            Widget? child,
                                          ) {
                                            return Text(
                                              (box.get('name') == null ||
                                                      box.get('name') == '')
                                                  ? 'Guest'
                                                  : box
                                                      .get(
                                                        'name',
                                                      )
                                                      .split(
                                                        ' ',
                                                      )[0]
                                                      .toString(),
                                              style: const TextStyle(
                                                letterSpacing: 2,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //START
                              Row(
                                children: [
                                  
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/recent');
                                      },
                                      icon: Icon(Icons.history_toggle_off)),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return NewSettingsPage();
                                        }));
                                      },
                                      icon: Icon(Icons.settings)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              //[SEARCH BAR BELOW]

              // SliverAppBar(
              //   automaticallyImplyLeading: false,
              //   pinned: true,
              //   backgroundColor: Colors.transparent,
              //   elevation: 0,
              //   stretch: true,
              //   toolbarHeight: 65,
              //   title: Align(
              //     alignment: Alignment.centerRight,
              //     child: AnimatedBuilder(
              //       animation: _scrollController,
              //       builder: (context, child) {
              //         return GestureDetector(
              //           child: AnimatedContainer(
              //             width: (!_scrollController.hasClients ||
              //                     _scrollController.positions.length > 1)
              //                 ? MediaQuery.of(context).size.width
              //                 : max(
              //                     MediaQuery.of(context).size.width -
              //                         _scrollController.offset.roundToDouble(),
              //                     MediaQuery.of(context).size.width -
              //                         (rotated ? 0 : 75),
              //                   ),
              //             height: 55.0,
              //             duration: const Duration(
              //               milliseconds: 150,
              //             ),
              //             padding: const EdgeInsets.all(2.0),
              //             // margin: EdgeInsets.zero,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(
              //                 10.0,
              //               ),
              //               color: Theme.of(context).cardColor,
              //               boxShadow: const [
              //                 BoxShadow(
              //                   color: Colors.black26,
              //                   blurRadius: 5.0,
              //                   offset: Offset(1.5, 1.5),
              //                   // shadow direction: bottom right
              //                 ),
              //               ],
              //             ),
              //             child: Row(
              //               children: [
              //                 const SizedBox(
              //                   width: 10.0,
              //                 ),
              //                 Icon(
              //                   CupertinoIcons.search,
              //                   color: Theme.of(context).colorScheme.secondary,
              //                 ),
              //                 const SizedBox(
              //                   width: 10.0,
              //                 ),
              //                 Text(
              //                   AppLocalizations.of(
              //                     context,
              //                   )!
              //                       .searchText,
              //                   style: TextStyle(
              //                     fontSize: 16.0,
              //                     color: Theme.of(context)
              //                         .textTheme
              //                         .bodySmall!
              //                         .color,
              //                     fontWeight: FontWeight.normal,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           onTap: () => Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => const SearchPage(
              //                 query: '',
              //                 fromHome: true,
              //                 autofocus: true,
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ];
          },
          body: SaavnHomePage(),
        ),
        // if (!rotated)
        // homeDrawer(
        //     context: context,
        //     padding: const EdgeInsets.only(top: 8.0, left: 4.0),
        //   ),
      ],
    );
  }
}
