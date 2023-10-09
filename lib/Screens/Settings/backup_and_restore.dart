import 'package:openvibes2/CustomWidgets/box_switch_tile.dart';
import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Helpers/backup_restore.dart';
import 'package:openvibes2/Helpers/config.dart';
import 'package:openvibes2/Helpers/picker.dart';
import 'package:openvibes2/Services/ext_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

class BackupAndRestorePage extends StatefulWidget {
  const BackupAndRestorePage({super.key});

  @override
  State<BackupAndRestorePage> createState() => _BackupAndRestorePageState();
}

class _BackupAndRestorePageState extends State<BackupAndRestorePage> {
  final Box settingsBox = Hive.box('settings');
  final MyTheme currentTheme = GetIt.I<MyTheme>();
  String autoBackPath = Hive.box('settings').get(
    'autoBackPath',
    defaultValue: '/storage/emulated/0/openvibes2/Backups',
  ) as String;

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
            'Backup and Restore',
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
                'Create Backup',
              ),
              subtitle: const Text(
                '',
              ),
              dense: true,
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    final List playlistNames = Hive.box('settings').get(
                      'playlistNames',
                      defaultValue: ['Favorite Songs'],
                    ) as List;
                    if (!playlistNames.contains('Favorite Songs')) {
                      playlistNames.insert(0, 'Favorite Songs');
                      settingsBox.put(
                        'playlistNames',
                        playlistNames,
                      );
                    }

                    final List<String> persist = [
                     'Settings',
                      'Playlists',
                    ];

                    final List<String> checked = [
                     'Settings',
                      'Downloads',
                      'Playlists',
                    ];

                    final List<String> items = [
                      'Settings',
                      'Playlists',
                      'Downloads',
                      'Cache',
                    ];

                    final Map<String, List> boxNames = {
                      'settings': ['settings'],
                      'cache': ['cache'],
                      'downloads': ['downloads'],
                      'playlists': playlistNames,
                    };
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
                                  itemCount: items.length,
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
                                        items[idx],
                                      ),
                                      title: Text(
                                        items[idx],
                                      ),
                                      onChanged: persist.contains(items[idx])
                                          ? null
                                          : (bool? value) {
                                              value!
                                                  ? checked.add(
                                                      items[idx],
                                                    )
                                                  : checked.remove(
                                                      items[idx],
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
                                      createBackup(
                                        context,
                                        checked,
                                        boxNames,
                                      );
                                      Navigator.pop(context);
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
                'Restore',
              ),
              subtitle: const Text(
                '',
              ),
              dense: true,
              onTap: () async {
                await restore(context);
                currentTheme.refresh();
              },
            ),
            const BoxSwitchTile(
              title: Text(
                'Auto Backup',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'autoBackup',
              defaultValue: false,
            ),
            ListTile(
              title: const Text(
                'Auto Backup Location',
              ),
              subtitle: Text(autoBackPath),
              trailing: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                ),
                onPressed: () async {
                  autoBackPath = await ExtStorageProvider.getExtStorage(
                        dirName: 'openvibes2/Backups',
                        writeAccess: true,
                      ) ??
                      '/storage/emulated/0/openvibes2/Backups';
                  Hive.box('settings').put('autoBackPath', autoBackPath);
                  setState(
                    () {},
                  );
                },
                child: const Text(
                  'Reset',
                ),
              ),
              onTap: () async {
                final String temp = await Picker.selectFolder(
                  context: context,
                  message: 'Select Backup Location',
                );
                if (temp.trim() != '') {
                  autoBackPath = temp;
                  Hive.box('settings').put('autoBackPath', temp);
                  setState(
                    () {},
                  );
                } else {
                  ShowSnackBar().showSnackBar(
                    context,
                    'No Folder Selected',
                  );
                }
              },
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
