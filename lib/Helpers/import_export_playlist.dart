
import 'dart:convert';
import 'dart:io';

import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Helpers/picker.dart';
import 'package:openvibes2/Helpers/songs_count.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportPlaylist(
  BuildContext context,
  String playlistName,
  String showName,
) async {
  try {
    final String dirPath = await Picker.selectFolder(
      context: context,
      message: 'Select Export Location',
    );
    if (dirPath == '') {
      ShowSnackBar().showSnackBar(
        context,
        '${'Export Failed'} "$showName"',
      );
      return;
    }
    await Hive.openBox(playlistName);
    final Box playlistBox = Hive.box(playlistName);
    final Map songsMap = playlistBox.toMap();
    final String songs = json.encode(songsMap);
    File file;
    try {
      file = await File('$dirPath/$showName.json').create(recursive: true);
    } catch (e) {
      Logger.root.severe(
        'Error creating export playlist file. Retrying with file access permission',
      );
      await [
        Permission.manageExternalStorage,
      ].request();
      file = await File('$dirPath/$showName.json').create(recursive: true);
    }
    await file.writeAsString(songs);
    ShowSnackBar().showSnackBar(
      context,
      '${'Exported'} "$showName"',
    );
  } catch (e) {
    Logger.root.severe('Error while exporting playlist', e);
    ShowSnackBar().showSnackBar(
      context,
      'Export Failed',
    );
  }
}

Future<void> sharePlaylist(
  BuildContext context,
  String playlistName,
  String showName,
) async {
  final Directory appDir = await getApplicationDocumentsDirectory();
  final String temp = appDir.path;

  await Hive.openBox(playlistName);
  final Box playlistBox = Hive.box(playlistName);
  final Map songsMap = playlistBox.toMap();
  final String songs = json.encode(songsMap);
  final File file = await File('$temp/$showName.json').create(recursive: true);
  await file.writeAsString(songs);
  final files = <XFile>[XFile(file.path)];
  await Share.shareXFiles(
    files,
    text: 'Share Playlist',
  );
  await Future.delayed(const Duration(seconds: 10), () {});
  if (await file.exists()) {
    await file.delete();
  }
}

Future<List> importFilePlaylist(
  BuildContext? context,
  List playlistNames, {
  String? path,
  bool pickFile = true,
}) async {
  try {
    String temp = '';
    if ((pickFile || path == null) && context != null) {
      try {
        temp = await Picker.selectFile(
          context: context,
          // ext: ['json'],
          message: 'Select Json Import',
        );
      } catch (e) {
        temp = await Picker.selectFile(
          context: context,
          message: 'Select Json Import',
        );
      }
    } else {
      if (path != null) {
        temp = path;
      }
    }
    if (temp == '') {
      Logger.root.severe('Error while importing playlist', 'path is empty');
      if (context != null) {
        ShowSnackBar().showSnackBar(
          context,
          'Failed Import',
        );
      }
      return playlistNames;
    }

    Logger.root.severe('Got playlist path', temp);
    final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
    String playlistName = temp
        .split('/')
        .last
        .replaceAll('.json', '')
        .replaceAll(avoid, '')
        .replaceAll('  ', ' ');

    final File file = File(temp);
    final String finString = await file.readAsString();
    final Map songsMap = json.decode(finString) as Map;
    final List songs = songsMap.values.toList();
    // playlistBox.put(mediaItem.id.toString(), info);
    // Hive.box(play)

    if (playlistName.trim() == '') {
      playlistName = 'Playlist ${playlistNames.length}';
    }
    if (playlistNames.contains(playlistName)) {
      playlistName = '$playlistName (1)';
    }
    playlistNames.add(playlistName);

    await Hive.openBox(playlistName);
    final Box playlistBox = Hive.box(playlistName);
    await playlistBox.putAll(songsMap);
    await Hive.box('settings').put('playlistNames', playlistNames);

    addSongsCount(
      playlistName,
      songs.length,
      songs.length >= 4 ? songs.sublist(0, 4) : songs.sublist(0, songs.length),
    );

    if (context != null) {
      ShowSnackBar().showSnackBar(
        context,
        '${'Import Successful'} "$playlistName"',
      );
    }
    return playlistNames;
  } catch (e) {
    Logger.root.severe('Error while importing playlist', e);
    if (context != null) {
      ShowSnackBar().showSnackBar(
        context,
        '${'Import Failed'}\nError: $e',
      );
    }
  }
  return playlistNames;
}
