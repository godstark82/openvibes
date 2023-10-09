// ignore_for_file: prefer_const_constructors, require_trailing_commas, avoid_void_async, prefer_final_locals, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NoEntry extends StatefulWidget {
  const NoEntry({super.key});

  @override
  State<NoEntry> createState() => _NoEntryState();
}

class _NoEntryState extends State<NoEntry> {
  List<String> downloadLinks = [
    'https://drive.google.com/uc?export=download&id=1vgRZB0zxVkjTJNdRBxA-MBS2yxsSDy3Q',
    'https://drive.google.com/uc?export=download&id=19xUSozi4xiPArW7bJDOysxcXjJwI7W3q',
    'https://drive.google.com/uc?export=download&id=1Uz5yK4FaBurXAN3fbhNm30ZWHXoNIyhC',
  ];
  List<Map> songInfo = [
    {
      'name': 'happy-day-background-vlog-music-NCS',
      'type': 'mp3',
      'Copyright': 'No Copyright'
    },
    {
      'name': 'summer-party',
      'type': 'mp3',
      'Copyright': 'No Copyright',
    },
    {
      'name': 'tvari-tokyo-cafe',
      'type': 'mp3',
      'Copyright': 'No Copyright',
    },
  ];
  late String _localPath;
  late bool _permissionReady;
  final TargetPlatform platform = TargetPlatform.android;

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return '/sdcard/download/';
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 112, 84),
              elevation: 0,
              title: const Text(
                'OpenVibes',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blueAccent,
                  Colors.red
                ])
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'No Copyright Songs Downloader for Background Music',
                        style:
                            TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                                leading: Icon(Icons.music_note_outlined),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${songInfo[index]['name']}.mp3'),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    title: Text('Song Info'),
                                                    content: Center(
                                                      child: SizedBox(
                                                        height: height * 0.25,
                                                        width: width * 0.9,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                'Song Name: ${songInfo[index]['name']}'),
                                                            Text(
                                                                'Song Name: ${songInfo[index]['type']}'),
                                                            Text(
                                                                'Song Name: ${songInfo[index]['Copyright']}'),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              });
                                        },
                                        icon: Icon(Icons.info)),
                                  ],
                                ),
                                trailing: IconButton.filled(
                                  onPressed: () async {
                                    _permissionReady = await _checkPermission();
                                    if (_permissionReady) {
                                      await _prepareSaveDir();
            
                                      try {
                                        await Dio().download(
                                            'https://drive.google.com/uc?export=download&id=1vgRZB0zxVkjTJNdRBxA-MBS2yxsSDy3Q',
                                            '$_localPath/music1.mp3');
            
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Downloading'),
                                          duration: Duration(seconds: 2),
                                        ));
                                        await Future.delayed(
                                            Duration(seconds: 3));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text('Download Done')));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Download Failed \n $e')));
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.download),
                                )));
                      }),
                ],
              ),
            )));
  }
}
