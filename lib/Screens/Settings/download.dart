import 'package:openvibes2/CustomWidgets/box_switch_tile.dart';
import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Helpers/picker.dart';
import 'package:openvibes2/Services/ext_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final Box settingsBox = Hive.box('settings');
  String downloadPath = Hive.box('settings')
      .get('downloadPath', defaultValue: '/storage/emulated/0/Music') as String;
  String downloadQuality = Hive.box('settings')
      .get('downloadQuality', defaultValue: '320 kbps') as String;
  String ytDownloadQuality = Hive.box('settings')
      .get('ytDownloadQuality', defaultValue: 'High') as String;
  int downFilename =
      Hive.box('settings').get('downFilename', defaultValue: 0) as int;

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
           'Downloads',
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
                'Download Quality',
              ),
              subtitle: const Text(
                '',
              ),
              onTap: () {},
              trailing: DropdownButton(
                value: downloadQuality,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        downloadQuality = newValue;
                        Hive.box('settings').put('downloadQuality', newValue);
                      },
                    );
                  }
                },
                items: <String>['96 kbps', '160 kbps', '320 kbps']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
              ),
              dense: true,
            ),
            ListTile(
              title: const Text(
                'Youtube Download Quality',
              ),
              subtitle: const Text(
                '',
              ),
              onTap: () {},
              trailing: DropdownButton(
                value: ytDownloadQuality,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(
                      () {
                        ytDownloadQuality = newValue;
                        Hive.box('settings').put('ytDownloadQuality', newValue);
                      },
                    );
                  }
                },
                items: <String>['Low', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
              ),
              dense: true,
            ),
            ListTile(
              title: const Text(
                'Download Location',
              ),
              subtitle: Text(downloadPath),
              trailing: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[700],
                ),
                onPressed: () async {
                  downloadPath = await ExtStorageProvider.getExtStorage(
                        dirName: 'Music',
                        writeAccess: true,
                      ) ??
                      '/storage/emulated/0/Music';
                  Hive.box('settings').put('downloadPath', downloadPath);
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
                  message: 'Select Download Location',
                );
                if (temp.trim() != '') {
                  downloadPath = temp;
                  Hive.box('settings').put('downloadPath', temp);
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
            ListTile(
              title: const Text(
                'Download File Name',
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
                    return BottomGradientContainer(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(
                          0,
                          10,
                          0,
                          10,
                        ),
                        children: [
                          CheckboxListTile(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            title: const Text(
                              '${'Title'} - ${'Artist'}',
                            ),
                            value: downFilename == 0,
                            selected: downFilename == 0,
                            onChanged: (bool? val) {
                              if (val ?? false) {
                                downFilename = 0;
                                settingsBox.put('downFilename', 0);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          CheckboxListTile(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            title: const Text(
                              '${'Artits'} - ${'Title'}',
                            ),
                            value: downFilename == 1,
                            selected: downFilename == 1,
                            onChanged: (val) {
                              if (val ?? false) {
                                downFilename = 1;
                                settingsBox.put('downFilename', 1);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          CheckboxListTile(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            title: const Text(
                              'Title',
                            ),
                            value: downFilename == 2,
                            selected: downFilename == 2,
                            onChanged: (val) {
                              if (val ?? false) {
                                downFilename = 2;
                                settingsBox.put('downFilename', 2);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const BoxSwitchTile(
              title: Text(
                'Create Album Folder',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'createDownloadFolder',
              isThreeLine: true,
              defaultValue: false,
            ),
            const BoxSwitchTile(
              title: Text(
                'Create Youtube Folder',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'createYoutubeFolder',
              isThreeLine: true,
              defaultValue: false,
            ),
            const BoxSwitchTile(
              title: Text(
                'Download Lyrics',
              ),
              subtitle: Text(
                '',
              ),
              keyName: 'downloadLyrics',
              defaultValue: false,
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
