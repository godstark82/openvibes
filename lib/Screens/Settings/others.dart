import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:openvibes2/CustomWidgets/box_switch_tile.dart';
import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/CustomWidgets/textinput_dialog.dart';
import 'package:openvibes2/Helpers/picker.dart';
import 'package:openvibes2/constants/languagecodes.dart';
import 'package:openvibes2/main.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({super.key});

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  final Box settingsBox = Hive.box('settings');
  final ValueNotifier<bool> includeOrExclude = ValueNotifier<bool>(
    Hive.box('settings').get('includeOrExclude', defaultValue: false) as bool,
  );
  List includedExcludedPaths = Hive.box('settings')
      .get('includedExcludedPaths', defaultValue: []) as List;
  String lang =
      Hive.box('settings').get('lang', defaultValue: 'English') as String;
  bool useProxy =
      Hive.box('settings').get('useProxy', defaultValue: false) as bool;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(
              context,
            )!
                .others,
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
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .lang,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .langSub,
              ),
              onTap: () {},
              trailing: DropdownButton(
                value: lang,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        lang = newValue;
                        MyApp.of(context).setLocale(
                          Locale.fromSubtags(
                            languageCode:
                                LanguageCodes.languageCodes[newValue] ?? 'en',
                          ),
                        );
                        Hive.box('settings').put('lang', newValue);
                      },
                    );
                  }
                },
                items: LanguageCodes.languageCodes.keys
                    .map<DropdownMenuItem<String>>((language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(
                      language,
                    ),
                  );
                }).toList(),
              ),
              dense: true,
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .includeExcludeFolder,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .includeExcludeFolderSub,
              ),
              dense: true,
              onTap: () {
                final GlobalKey<AnimatedListState> listKey =
                    GlobalKey<AnimatedListState>();
                showModalBottomSheet(
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return BottomGradientContainer(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: AnimatedList(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(
                          0,
                          10,
                          0,
                          10,
                        ),
                        key: listKey,
                        initialItemCount: includedExcludedPaths.length + 2,
                        itemBuilder: (cntxt, idx, animation) {
                          if (idx == 0) {
                            return ValueListenableBuilder(
                              valueListenable: includeOrExclude,
                              builder: (
                                BuildContext context,
                                bool value,
                                Widget? widget,
                              ) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        ChoiceChip(
                                          label: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!
                                                .excluded,
                                          ),
                                          selectedColor: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.2),
                                          labelStyle: TextStyle(
                                            color: !value
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                            fontWeight: !value
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          selected: !value,
                                          onSelected: (bool selected) {
                                            includeOrExclude.value = !selected;
                                            settingsBox.put(
                                              'includeOrExclude',
                                              !selected,
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ChoiceChip(
                                          label: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!
                                                .included,
                                          ),
                                          selectedColor: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.2),
                                          labelStyle: TextStyle(
                                            color: value
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                            fontWeight: value
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          selected: value,
                                          onSelected: (bool selected) {
                                            includeOrExclude.value = selected;
                                            settingsBox.put(
                                              'includeOrExclude',
                                              selected,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5.0,
                                        top: 5.0,
                                        bottom: 10.0,
                                      ),
                                      child: Text(
                                        value
                                            ? AppLocalizations.of(
                                                context,
                                              )!
                                                .includedDetails
                                            : AppLocalizations.of(
                                                context,
                                              )!
                                                .excludedDetails,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          if (idx == 1) {
                            return ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.addNew,
                              ),
                              leading: const Icon(
                                CupertinoIcons.add,
                              ),
                              onTap: () async {
                                final String temp = await Picker.selectFolder(
                                  context: context,
                                );
                                if (temp.trim() != '' &&
                                    !includedExcludedPaths.contains(temp)) {
                                  includedExcludedPaths.add(temp);
                                  Hive.box('settings').put(
                                    'includedExcludedPaths',
                                    includedExcludedPaths,
                                  );
                                  listKey.currentState!.insertItem(
                                    includedExcludedPaths.length,
                                  );
                                } else {
                                  if (temp.trim() == '') {
                                    Navigator.pop(context);
                                  }
                                  ShowSnackBar().showSnackBar(
                                    context,
                                    temp.trim() == ''
                                        ? 'No folder selected'
                                        : 'Already added',
                                  );
                                }
                              },
                            );
                          }

                          return SizeTransition(
                            sizeFactor: animation,
                            child: ListTile(
                              leading: const Icon(
                                CupertinoIcons.folder,
                              ),
                              title: Text(
                                includedExcludedPaths[idx - 2].toString(),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.clear,
                                  size: 15.0,
                                ),
                                tooltip: 'Remove',
                                onPressed: () {
                                  includedExcludedPaths.removeAt(idx - 2);
                                  Hive.box('settings').put(
                                    'includedExcludedPaths',
                                    includedExcludedPaths,
                                  );
                                  listKey.currentState!.removeItem(
                                    idx,
                                    (context, animation) => Container(),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .minAudioLen,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .minAudioLenSub,
              ),
              dense: true,
              onTap: () {
                showTextInputDialog(
                  context: context,
                  title: AppLocalizations.of(
                    context,
                  )!
                      .minAudioAlert,
                  initialText: (Hive.box('settings')
                          .get('minDuration', defaultValue: 10) as int)
                      .toString(),
                  keyboardType: TextInputType.number,
                  onSubmitted: (String value, BuildContext context) {
                    if (value.trim() == '') {
                      value = '0';
                    }
                    Hive.box('settings').put('minDuration', int.parse(value));
                    Navigator.pop(context);
                  },
                );
              },
            ),
            BoxSwitchTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .liveSearch,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .liveSearchSub,
              ),
              keyName: 'liveSearch',
              isThreeLine: false,
              defaultValue: true,
            ),
            BoxSwitchTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .useDown,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .useDownSub,
              ),
              keyName: 'useDown',
              isThreeLine: true,
              defaultValue: true,
            ),
            BoxSwitchTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .getLyricsOnline,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .getLyricsOnlineSub,
              ),
              keyName: 'getLyricsOnline',
              isThreeLine: true,
              defaultValue: true,
            ),
            BoxSwitchTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .supportEq,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .supportEqSub,
              ),
              keyName: 'supportEq',
              isThreeLine: true,
              defaultValue: false,
            ),
            BoxSwitchTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .stopOnClose,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .stopOnCloseSub,
              ),
              isThreeLine: true,
              keyName: 'stopForegroundService',
              defaultValue: true,
            ),
            // const BoxSwitchTile(
            //   title: Text('Remove Service from foreground when paused'),
            //   subtitle: Text(
            //       "If turned on, you can slide notification when paused to stop the service. But Service can also be stopped by android to release memory. If you don't want android to stop service while paused, turn it off\nDefault: On\n"),
            //   isThreeLine: true,
            //   keyName: 'stopServiceOnPause',
            //   defaultValue: true,
            // ),

            ListTile(
              title: Text(
                AppLocalizations.of(
                  context,
                )!
                    .clearCache,
              ),
              subtitle: Text(
                AppLocalizations.of(
                  context,
                )!
                    .clearCacheSub,
              ),
              trailing: SizedBox(
                height: 70.0,
                width: 70.0,
                child: Center(
                  child: FutureBuilder(
                    future: File(Hive.box('cache').path!).length(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<int> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          '${((snapshot.data ?? 0) / (1024 * 1024)).toStringAsFixed(2)} MB',
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              dense: true,
              isThreeLine: true,
              onTap: () async {
                Hive.box('cache').clear();
                setState(
                  () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
