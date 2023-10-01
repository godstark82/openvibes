// ignore_for_file: prefer_const_constructors, require_trailing_commas, avoid_void_async, prefer_final_locals, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:openvibes2/constants/languagecodes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

class NoEntry extends StatefulWidget {
  const NoEntry({super.key});

  @override
  State<NoEntry> createState() => _NoEntryState();
}

class _NoEntryState extends State<NoEntry> {
  String path = '';
  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    Directory _path = await getApplicationDocumentsDirectory();
    String _localPath = '${_path.path}${Platform.pathSeparator}Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    path = _localPath;
  }

  @override
  Widget build(BuildContext context) {
    const Locale locale = Locale('en', '');
    // final PageController controller = PageController();
    return MaterialApp(
      // routes: namedRoutesForNoEntry,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageCodes.languageCodes.entries
          .map((languageCode) => Locale(languageCode.value, ''))
          .toList(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Downloads'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Card(
                  child: ListTile(
                      title: Text('Song Name:'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          var options = DownloaderUtils(
                            progressCallback: (current, total) {
                              final progress = (current / total) * 100;
                              print('Downloading: $progress');
                            },
                            file: File('$path/loremipsum.pdf'),
                            progress: ProgressImplementation(),
                            onDone: () {},
                            deleteOnCancel: true,
                          );
                          await Flowder.download(
                            'https://assets.website-files.com/603d0d2db8ec32ba7d44fffe/603d0e327eb2748c8ab1053f_loremipsum.pdf',
                            options,
                          );
                          print('download done');
                        },
                        child: Text('data'),
                      )),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Card(
                  child: ListTile(
                    title: Text('data'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
