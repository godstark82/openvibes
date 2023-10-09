import 'package:openvibes2/CustomWidgets/box_switch_tile.dart';
import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Screens/Home/saavn.dart' as home_screen;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MusicPlaybackPage extends StatefulWidget {
  final Function? callback;
  const MusicPlaybackPage({this.callback});

  @override
  State<MusicPlaybackPage> createState() => _MusicPlaybackPageState();
}

class _MusicPlaybackPageState extends State<MusicPlaybackPage> {
  String streamingMobileQuality = Hive.box('settings')
      .get('streamingQuality', defaultValue: '96 kbps') as String;
  String streamingWifiQuality = Hive.box('settings')
      .get('streamingWifiQuality', defaultValue: '320 kbps') as String;
  String ytQuality =
      Hive.box('settings').get('ytQuality', defaultValue: 'Low') as String;
  String region =
      Hive.box('settings').get('region', defaultValue: 'India') as String;
  List<String> languages = [
    'Hindi',
    'English',
    'Punjabi',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Kannada',
    'Bhojpuri',
    'Malayalam',
    'Urdu',
    'Haryanvi',
    'Rajasthani',
    'Odia',
    'Assamese',
  ];
  List preferredLanguage = Hive.box('settings')
      .get('preferredLanguage', defaultValue: ['Hindi'])?.toList() as List;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Music Playback',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: [
            ListTile(
              title: const Text(
                'Music Language',
              ),
              subtitle: const Text(
                '',
              ),
              trailing: SizedBox(
                width: 150,
                child: Text(
                  preferredLanguage.isEmpty
                      ? 'None'
                      : preferredLanguage.join(', '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              dense: true,
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    final List checked = List.from(preferredLanguage);
                    return StatefulBuilder(
                      builder: (
                        BuildContext context,
                        StateSetter setStt,
                      ) {
                        return BottomGradientContainer(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    10,
                                    0,
                                    10,
                                  ),
                                  itemCount: languages.length,
                                  itemBuilder: (context, idx) {
                                    return CheckboxListTile(
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      checkColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary ==
                                              Colors.white
                                          ? Colors.black
                                          : null,
                                      value: checked.contains(
                                        languages[idx],
                                      ),
                                      title: Text(
                                        languages[idx],
                                      ),
                                      onChanged: (bool? value) {
                                        value!
                                            ? checked.add(languages[idx])
                                            : checked.remove(
                                                languages[idx],
                                              );
                                        setStt(
                                          () {},
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          preferredLanguage = checked;
                                          Navigator.pop(context);
                                          Hive.box('settings').put(
                                            'preferredLanguage',
                                            checked,
                                          );
                                          home_screen.fetched = false;
                                          home_screen.preferredLanguage =
                                              preferredLanguage;
                                          widget.callback!();
                                        },
                                      );
                                      if (preferredLanguage.isEmpty) {
                                        ShowSnackBar().showSnackBar(
                                          context,
                                          'No Language Selected',
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Ok',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text(
                'Stream Quality',
              ),
              subtitle: const Text(
                '',
              ),
              onTap: () {},
              trailing: DropdownButton(
                value: streamingMobileQuality,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        streamingMobileQuality = newValue;
                        Hive.box('settings').put('streamingQuality', newValue);
                      },
                    );
                  }
                },
                items: <String>['96 kbps', '160 kbps', '320 kbps']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              dense: true,
            ),
            ListTile(
              title: const Text(
                'Stream Wifi Quality',
              ),
              subtitle: const Text(
                '',
              ),
              onTap: () {},
              trailing: DropdownButton(
                value: streamingWifiQuality,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        streamingWifiQuality = newValue;
                        Hive.box('settings')
                            .put('streamingWifiQuality', newValue);
                      },
                    );
                  }
                },
                items: <String>['96 kbps', '160 kbps', '320 kbps']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              dense: true,
            ),
            ListTile(
              title: const Text(
                'Youtube Streaming Quality',
              ),
              subtitle: const Text(
                '',
              ),
              onTap: () {},
              trailing: DropdownButton(
                value: ytQuality,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        ytQuality = newValue;
                        Hive.box('settings').put('ytQuality', newValue);
                      },
                    );
                  }
                },
                items: <String>['Low', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              dense: true,
            ),
            const BoxSwitchTile(
              title: Text(
                'Load Last',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'loadStart',
              defaultValue: true,
            ),
            const BoxSwitchTile(
              title: Text(
                'Reset on Skip',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'resetOnSkip',
              defaultValue: false,
            ),
            const BoxSwitchTile(
              title: Text(
                'Enforce Repeat',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'enforceRepeat',
              defaultValue: false,
            ),
            const BoxSwitchTile(
              title: Text(
                'AutoPlay',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'autoplay',
              defaultValue: true,
              isThreeLine: true,
            ),
            const BoxSwitchTile(
              title: Text(
                'CacheSong',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'cacheSong',
              defaultValue: true,
            ),
          ],
        ),
      ),
    );
  }
}
